# main.tf

# variables.tf
variable "secret_key" {}
variable "access_key" {}

provider "aws" {
  region  = "us-east-1" #The region where the environment 
  secret_key = var.secret_key
  access_key = var.access_key
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.28.0"
    }
  }
}

# TASK DEFINITIOn
module "taskdefinition" {
  source = "./taskdefinition"
}

# ROLES
module "roles" {
  source = "./roles"
}

# VPC - network

module "network" {
  source   = "./network"
}

