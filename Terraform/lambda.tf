provider "aws" {
  region = "eu-north-1"
  alias = "lambda"
}

resource "random_pet" "lambda_bucket_suffix" {
  length    = 2  # specify the length of the random string
  separator = "-"
}

resource "aws_s3_bucket" "cardalog_lambda_bucket" {
  bucket = "cardalog-lambda-bucket-${random_pet.lambda_bucket_suffix.id}"
}

resource "aws_lambda_permission" "cardalog_s3_invoke_lambda" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.cardalog_data_reader.arn
  principal     = "s3.amazonaws.com"

  # Specify the ARN of the S3 bucket that will trigger the Lambda function
  #source_arn = aws_s3_bucket.example_bucket.arn

  # Specify the S3 event types that will trigger the Lambda function
  #source_account = "${var.aws_account_id}"  # Replace with your AWS account ID
  # Events: s3:ObjectCreated:*, s3:ObjectRemoved:* etc.
  # You can specify more detailed events based on your requirements
  # For example, you can specify only s3:ObjectCreated events by using ["s3:ObjectCreated:*"]
  # or a specific prefix/key with ["s3:ObjectCreated:*"] and filter_suffix
  # (e.g., filter_suffix = ".jpg" to only trigger for .jpg files)
  # Uncomment the following line and adjust the event types as needed:
  # events = ["s3:ObjectCreated:*"]
}

data "archive_file" "cardalog_lambda_zip" {
  type        = "zip"
  output_path = "cardalog_data_reader.zip"
  source_dir  = "../Node/cardalog_data_reader"  # Path to the directory containing your Lambda function code
}

resource "aws_s3_object" "cardalog_lambda_zip_object" {
  bucket = aws_s3_bucket.cardalog_lambda_bucket.id
  key    = "cardalog_data_reader.zip"
  source = data.archive_file.cardalog_lambda_zip.output_path
}

#resource "random_pet" "lambda_suffix" {
#  length    = 2  # specify the length of the random string
#  separator = "-"
#}

resource "aws_lambda_function" "cardalog_data_reader" {
  filename         = "cardalog_data_reader.zip"  # path to the ZIP file containing your Lambda code
  #function_name    = "cardalog_data_reader-${random_pet.lambda_suffix.id}"  # name of your Lambda function
  function_name    = "cardalog_data_reader"
  role             = aws_iam_role.cardalog_lambda_role.arn  # ARN of the IAM role associated with your Lambda function
  handler          = "index.handler"  # name of the handler function in your Lambda code
  runtime          = "nodejs18.x"  # runtime environment for your Lambda function
  
  # Optional configuration
  memory_size      = 128  # memory allocated to the Lambda function in MB
  timeout          = 30   # maximum execution time for the Lambda function in seconds
}

# IAM role for Lambda function
resource "aws_iam_role" "cardalog_lambda_role" {
  name = "cardalog_lambda_execution_role"  # name of the IAM role
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# IAM policy for Lambda function
resource "aws_iam_policy" "cardalog_lambda_policy" {
  name        = "cardalog_lambda_execution_policy"  # name of the IAM policy
  description = "Policy for Lambda execution role"  # description of the IAM policy

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "logs:CreateLogGroup",
      "Resource": "arn:aws:logs:*:*:*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    },
    {
      "Effect": "Allow",
      "Action": "dynamodb:GetItem",
      "Resource": "arn:aws:dynamodb:*:*:*"
    }
  ]
}
EOF
}

# Attach the policy to the IAM role
resource "aws_iam_role_policy_attachment" "cardalog_lambda_policy_attachment" {
  role       = aws_iam_role.cardalog_lambda_role.name
  policy_arn = aws_iam_policy.cardalog_lambda_policy.arn
}