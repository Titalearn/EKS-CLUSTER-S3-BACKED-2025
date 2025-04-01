# This Terraform configuration creates an S3 bucket for storing Terraform state files
# and a DynamoDB table for state locking. It includes versioning for the S3 bucket

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Corrected the AWS provider version
    }
  }

  required_version = ">= 1.0.0" # Specify the minimum Terraform version
}
provider "aws" {
  region = "us-east-1"                            # Replace with your desired AWS region
}

# S3 Bucket for Terraform state storage
resource "aws_s3_bucket" "TerraformStateBucket" {
  bucket = "alexaedge-bucket" # Replace with a globally unique bucket name

  tags = {
    Name        = "TerraformStateBucket"
    Environment = "Dev"
  }
}

# S3 Bucket Versioning Configuration
resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.TerraformStateBucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# DynamoDB Table for state locking
resource "aws_dynamodb_table" "terraform_lock_table" {
  name         = "terraform-lock-table"
  billing_mode = "PAY_PER_REQUEST" #    Dynamically scales based on usage

  attribute {
    name = "LockID"
    type = "S"
  }

  hash_key = "LockID" # Specify the hash key for DynamoDB

  tags = {
    Name        = "TerraformLockTable"
    Environment = "Dev"
  }
}

# Outputs for S3 Bucket and DynamoDB Table
output "s3_bucket_name" {
  value = aws_s3_bucket.TerraformStateBucket.id
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.terraform_lock_table.name
}
