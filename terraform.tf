terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region  = "ap-south-1"

}

resource "aws_s3_bucket" "traform_main"{
bucket= "tf-website-learner-16e6b602c04c23b0e55d892e6f"
}

backend "s3"{
bucket="tf-website-learner-16e6b602c04c23b0e55d892e6f"
key="terraform/terraform.tfstate"
}

