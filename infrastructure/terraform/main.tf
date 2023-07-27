terraform {
  required_version = ">=1.5.1"

    required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.5"
    }
  }
}

variable "aws_ec2_web_app_ami" {}
variable "aws_ec2_jenkins_ami" {}
variable "aws_region" {}
variable "aws_ec2_user" {}
variable "access_key" {}
variable "secret_key" {}
variable "ansible_working_dir" {}
variable "ec2_ssh_private_key" {}
variable "jenkins_ssh_private_key" {}

provider "aws" {
  region = var.aws_region
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_instance" "intern-devops" {
  ami           = var.aws_ec2_web_app_ami
  instance_type = "t2.micro"

  key_name = "jenkins"
  security_groups = ["Jenkins"]

  tags = {
    Name = "intern-devops"
  }

  provisioner "local-exec" {
    working_dir = var.ansible_working_dir
    command = "ansible-playbook --inventory ${self.public_ip}, --private-key ${var.ec2_ssh_private_key} --user ${var.aws_ec2_user} config-new-ec2-instance.yaml"
  }
}

resource "aws_instance" "jenkins" {
  ami           = var.aws_ec2_jenkins_ami
  instance_type = "t2.micro"

  security_groups = ["Jenkins"]
  key_name = "jenkins"

  tags = {
    Name = "jenkins"
  }

  provisioner "local-exec" {
    working_dir = var.ansible_working_dir
    command = "ansible-playbook --inventory ${self.public_ip}, --private-key ${var.jenkins_ssh_private_key} --user ${var.aws_ec2_user} config-jenkins-instance.yaml"
  }
}


