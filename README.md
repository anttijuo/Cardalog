# Cardalog
A personal Trading Card collection Catalog based on AWS infrastructure

# Architecture

Initial Architecture Plan:

- Image-data stored in S3
- Text-data stored in DynamoDB
- Lambda polls DynamoDB based on input parameters, and returns text and image data
- Frontend stored in S3
- Frontend triggers Lambdas through API gateway

Tools used:

- Terraform for managing AWS resource state
- Git for version control

# AWS

## Configure AWS access credentials:

1. Open Command Line/Command Prompt
2. Call:
```
aws configure
```
3. Input the relevant information of an authorized AWS account

# Terraform

## Initialize Terraform resources:

1. Open Command Line/Command Prompt
2. Navigate to Terraform/ directory
3. Call:
```
terraform init
```

## Check Terraform changes before updating:

1. Open Command Line/Command Prompt
2. Navigate to Terraform/ directory
3. Call:
```
terraform plan
```
4. Confirm whether or not logged changes are desired

## Deploy Terraform changes to cloud:

1. Open Command Line/Command Prompt
2. Navigate to Terraform/ directory
3. Call:
```
terraform apply
```
4. When prompted, input:
```
yes
```