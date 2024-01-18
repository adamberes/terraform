terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.31"
    }
  }
  required_version = ">= 1.6.0"
}

# Define AWS as our provider
provider "aws" {
  region = "us-east-1"
}
