# This file is used to create an EKS cluster using Terraform.
# It includes the necessary provider configuration, remote state data source, and the EKS cluster resource definition.
# The cluster is created in a VPC defined in a separate Terraform configuration.
# The VPC is expected to be created in a separate module and its state is stored in an S3 bucket.

provider "aws" {
  region = "us-east-1" # Replace with your desired AWS region
  
}

data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = "alexaedge-bucket" # Replace with the actual bucket name for the network state
    key    = "vpc/terraform.tfstate"    # Replace with the actual key for the network state
    region = "us-east-1"                # Replace with the correct region
  }
}

terraform {
  backend "s3" {
    bucket = "alexaedge-bucket"
    key    = "eks/terraform.tfstate"
    region = "us-east-1" # Correct region

  # For State Locking
    dynamodb_table = "terraform-lock-table"  # Correct table name  
    encrypt        = true # Encrypt the state file
  }
}

# Create EKS Cluster
resource "aws_eks_cluster" "demo" {
  name     = "alexaedge-cluster" # Replace with your desired cluster name
  role_arn = data.terraform_remote_state.network.outputs.node_role

  vpc_config {
    subnet_ids = [
      data.terraform_remote_state.network.outputs.public[0],
      data.terraform_remote_state.network.outputs.public[1],
      data.terraform_remote_state.network.outputs.private[0],
      data.terraform_remote_state.network.outputs.private[1]
    ]
  }
}
