terraform {
  required_version = "1.5.1"

    required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.5"
    }
  }
}

variable "access_key" {}
variable "secret_key" {}

provider "aws" {
  region = "ap-southeast-1"
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_instance" "intern-devops" {
  ami           = "ami-0df7a207adb9748c7"
  instance_type = "t2.micro"
  security_groups = ["launch-wizard-4"]

  tags = {
    Name = "intern-devops"
  }
}
