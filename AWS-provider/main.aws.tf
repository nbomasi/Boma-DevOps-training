terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  access_key = "AKIA4BZWLA2JGJ43NS5I"
  secret_key = "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"
}
