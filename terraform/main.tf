terraform {
  required_version = "~>1.4.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      # 3.26.0 - Minimum version of the AWS provider which supports SSO
      version = "3.26.0"
    }
  }
  backend "s3" {}
}

provider "aws" {
  profile = "myprofile"
  region = "eu-west-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.20230119.1-x86_64-gp2"]
  }

  owners = ["amazon"]
}

resource "aws_instance" "idp_instance" {
  ami   = "ami-0b752bf1df193a6c4"
  instance_type           = var.instance_type
#   subnet_id               = "subnet-0ea23dbf24f6fd635"
#   vpc_security_group_ids  = ["sg-0d89ac6707188b3fb"]
#   disable_api_termination = false
#   ebs_optimized           = true
#   associate_public_ip_address = true
  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      user_data,
      ami,
      root_block_device.0.volume_size,
      instance_type,
      root_block_device,
      ebs_block_device
    ]
  }

  root_block_device {
    volume_size = var.disk_size
    volume_type = var.ebs_type
  }
}