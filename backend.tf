# backend.tf

terraform {
  backend "s3" {
    bucket = "my-pricing-lambda-terraform-state"
    region = var.aws_region
    key    = "pricing-lambda/terraform.tfstate"
  }
  required_version = ">= 0.13.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 2.7.0"
    }
  }
}