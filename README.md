# Cardalog
A personal Trading Card collection Catalog based on AWS infrastructure

# Architecture

Initial Architecture Plan:

- Image-data stored in S3
- Text-data stored in DynamoDB
- Lambda polls DynamoDB based on input parameters, and returns text and image data
- Backend triggers Lambdas through API gateway
- Server exists as a Docker-container in EC2
- HTML frontend in ?

Tools used:

- Terraform for managing AWS resource state
- Git for version control

# AWS

Configure AWS access credentials:

1. Open Command Line/Command Prompt
2. Call:
```
aws configure
```
3. Input the relevant information of an authorized AWS account

# Terraform

Initialize Terraform resources:

1. Open Command Line/Command Prompt
2. Navigate to Terraform/ directory
3. Call:
```
terraform init
```