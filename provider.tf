# terraform fmt -recursive

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.10.0" # >= 4.10.0, < 4.10.1
    }
  }

  required_version = ">= 1.1"
}

variable "aws_access_key" { type = string }
variable "aws_secret_key" { type = string }
variable "region" { type = string }
variable "account-id" { type = string }

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.region
}

data "aws_secretsmanager_secret" "secrets" {
  name = "/goormedu-clone"
}

data "aws_secretsmanager_secret_version" "current" {
  secret_id = data.aws_secretsmanager_secret.secrets.id
}

locals {
  env = jsondecode(nonsensitive(data.aws_secretsmanager_secret_version.current.secret_string))
}

module "backend" {
  source  = "./prod/backend"
  aws-env = data.aws_secretsmanager_secret_version.current.secret_id
}