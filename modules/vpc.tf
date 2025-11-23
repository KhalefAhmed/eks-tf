terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.99.1"
    }
  }
}
locals {
  cluster_name = var.cluster_name
}


resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    name = "${local.cluster_name}-vpc"
    env  = var.environment
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    name                                          = "${local.cluster_name}-igw"
    env                                           = var.environment
    "kubernetes.io/cluster/${local.cluster_name}" = "owned"
  }

  depends_on = [aws_vpc.vpc]
}
