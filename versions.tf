terraform {
  cloud {
    organization = "zac-corp"
    workspaces {
      name = "hashi_demo2"
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

