terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.14.0"
    }
  }
}

provider "aws" {
  region  = var.region
  profile = "tinong-profile"
}

terraform {
  backend "s3" {
    bucket  = "tinong-test-code"
    key     = "dev-terraform.tfstate"
    region  = "us-east-1"
    profile = "tinong-profile"
    #dynamodb_table = "terraform-state-lock"  Just one person running the code at the moment so no need for this.
  }
}