terraform {
  required_version = ">=1.5.1"

    required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.5"
    }
  }
}

//aws config
variable "access_key" {}
variable "secret_key" {}
variable "aws_region" {}

//ansible config
variable "ansible_working_dir" {}

//web app
variable "aws_ec2_web_app_user" {}
variable "aws_ec2_web_app_ami" {}
variable "aws_ec2_web_app_instance_type" {}
variable "aws_ec2_web_app_key_name" {}
variable "aws_ec2_web_app_security_groups" {}
variable "aws_ec2_web_app_tag_name" {}
variable "aws_ec2_web_app_ssh_private_key" {}
variable "aws_ec2_web_app_ansible_file" {}


//jenkins
variable "aws_ec2_jenkins_user" {}
variable "aws_ec2_jenkins_ami" {}
variable "aws_ec2_jenkins_instance_type" {}
variable "aws_ec2_jenkins_key_name" {}
variable "aws_ec2_jenkins_security_groups" {}
variable "aws_ec2_jenkins_tag_name" {}
variable "aws_ec2_jenkins_ssh_private_key" {}
variable "aws_ec2_jenkins_ansible_file" {}







provider "aws" {
  region = var.aws_region
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_instance" "web_app" {
  ami           = var.aws_ec2_web_app_ami
  instance_type = var.aws_ec2_web_app_instance_type

  key_name = var.aws_ec2_web_app_key_name
  security_groups = var.aws_ec2_jenkins_security_groups

  tags = {
    Name = var.aws_ec2_jenkins_tag_name
  }  

  provisioner "local-exec" {
    working_dir = var.ansible_working_dir
    command = <<-EOT
      echo ${self.public_ip} ansible_ssh_private_key_file=${var.aws_ec2_web_app_ssh_private_key} ansible_user=${var.aws_ec2_web_app_user} >> aws_public_ips.txt
      echo ${self.private_ip} web_app >> aws_private_ips.txt
      ansible-playbook --inventory ${self.public_ip}, --private-key ${var.aws_ec2_web_app_ssh_private_key} --user ${var.aws_ec2_web_app_user} ${var.aws_ec2_web_app_ansible_file} 
    EOT
  }
}

resource "aws_instance" "jenkins" {
  ami           = var.aws_ec2_jenkins_ami
  instance_type = var.aws_ec2_jenkins_instance_type

  key_name = var.aws_ec2_jenkins_key_name
  security_groups = var.aws_ec2_jenkins_security_groups

  tags = {
    Name = var.aws_ec2_jenkins_tag_name
  }  

  provisioner "local-exec" {
    working_dir = var.ansible_working_dir
    command = <<-EOT
      echo ${self.public_ip} ansible_ssh_private_key_file=${var.aws_ec2_jenkins_ssh_private_key} ansible_user=${var.aws_ec2_jenkins_user} >> aws_public_ips.txt
      echo ${self.private_ip} jenkins >> aws_private_ips.txt
      ansible-playbook --inventory ${self.public_ip}, --private-key ${var.aws_ec2_jenkins_ssh_private_key} --user ${var.aws_ec2_jenkins_user} ${var.aws_ec2_jenkins_ansible_file}
    EOT
  }
}

//automatically add dns entries so aws services can communicate to each other using aliases(Updating...)
resource "null_resource" "wait_for_resources" {
    depends_on = [
      aws_instance.web_app,
      aws_instance.jenkins
    ]
    provisioner "local-exec" {
      working_dir = var.ansible_working_dir
      command = <<-EOT
        echo "the main code will be placed here and updated soon"
        rm -f aws_private_ips.txt aws_public_ips.txt
      EOT
    }
}


