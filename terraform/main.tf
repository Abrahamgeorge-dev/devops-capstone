terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  cloud {
    organization = "babaseyi-terraform"

    workspaces {
      name = "devops-capstone"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}
