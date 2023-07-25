terraform {
  required_version = ">=1.5.1"

    required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.5"
    }
  }
}

variable "access_key" {}
variable "secret_key" {}
variable "ansible_working_dir" {}
variable "ec2_ssh_private_key" {}
variable "jenkins_ssh_private_key" {}

provider "aws" {
  region = "ap-southeast-1"
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_instance" "intern-devops" {
  ami           = "ami-0df7a207adb9748c7"
  instance_type = "t2.micro"

  key_name = "web-server"
  security_groups = ["launch-wizard-4"]

  tags = {
    Name = "intern-devops"
  }

  provisioner "local-exec" {
    working_dir = var.ansible_working_dir
    command = "ansible-playbook --inventory ${self.public_ip}, --private-key ${var.ec2_ssh_private_key} --user ubuntu config-new-ec2-instance.yaml"
  }
}

resource "aws_instance" "jenkins" {
  ami           = "ami-0df7a207adb9748c7"
  instance_type = "t2.micro"

  security_groups = ["launch-wizard-4"]
  key_name = "jenkins"

  tags = {
    Name = "jenkins"
  }

  provisioner "local-exec" {
    working_dir = var.ansible_working_dir
    command = "ansible-playbook --inventory ${self.public_ip}, --private-key ${var.jenkins_ssh_private_key} --user ubuntu config-jenkins-instance.yaml"
  }
}


