# Terraform block
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Provider block

provider "aws" {
  region = "us-east-1"
}

#Add the desired profile below e.g i added manager.This must be a user existing in aws

/*provider "aws" {
  region = "us-east-1"
  profile = "manager"
 } */
