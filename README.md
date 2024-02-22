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