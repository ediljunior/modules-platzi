#provider "aws" {
#    region="us-east-1"
#}
#resource "aws_instance" "platzi-instance" {
#    ami = "ami-0e7c23b8309b570b7"
#    instance_type = "t2.micro"
#    tags = {
#      Name = "practica-1"
#      Environment = "Dev"
#    }
#}

provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "ssh_conection" {
  name = var.sg_name

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  dynamic "egress" {
    for_each = var.egress_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }
}

resource "aws_instance" "platzi-instance" {
  ami             = var.ami_id
  instance_type   = var.instance_type
  tags            = var.tags
  security_groups = ["${aws_security_group.ssh_conection.name}"]
}

