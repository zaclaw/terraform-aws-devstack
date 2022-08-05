terraform {
  cloud {
    organization = "zac-corp"
    workspaces {
      name = "dev_stack_demo"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

