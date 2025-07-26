terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.5.0"
    }
  }
}


provider "aws" {
  region = var.aws_region
  access_key = "AKIAU6TXZX7PDDOIOF4V"
  secret_key = "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"
}

