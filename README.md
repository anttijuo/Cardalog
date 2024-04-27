# Cardalog
A personal Trading Card collection Catalog based on AWS infrastructure

# Architecture

Initial Architecture Plan:

- Image-data stored in S3
- Text-data stored in DynamoDB
- Lambdas stored in separate S3
- Lambda polls DynamoDB based on input parameters, and returns text data
- Separate Lambda polls S3 based on input parameters, and returns matching image data
- Frontend stored in separate S3
- Frontend triggers Lambdas through API gateway

Tools used:

- Terraform for managing AWS resource state
- Git for version control

# NODE

## Initialize NPM Modules

NOTE: Following assumes that you have Nodejs 18 installed on your local machine

1. Navigate to Node/desired lambda function
2. Call:
```
npm init
```
3. Call:
```
npm install
```
4. Call:
```
npm install aws-sdk --save
```

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