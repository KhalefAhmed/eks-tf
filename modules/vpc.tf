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
    "kubernetes.io/role/elb"                      = "1"
  }

  depends_on = [aws_vpc.vpc]
}


resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = var.public_subnet_count
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    name                                          = var.public_subnet_name
    env                                           = var.environment
    "kubernetes.io/cluster/${local.cluster_name}" = "owned"
    "kubernetes.io/role/elb"                      = "1"
  }

  depends_on = [aws_vpc.vpc]
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id

    tags = {
      name = var.public_route_table_name
      env  = var.environment
    }
  }
}

resource "aws_route_table_association" "public" {
  count          = var.public_subnet_count
  route_table_id = aws_route_table.public_rt.id
  subnet_id      = aws_subnet.public_subnet[count.index].id

  depends_on = [aws_vpc.vpc, aws_subnet.public_subnet]
}

resource "aws_eip" "ngw_eip" {
  domain = "vpc"
  tags = {
    name = var.nat_gateway_name
  }
  depends_on = [aws_vpc.vpc]
}

resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.ngw_eip.id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = {
    name = var.nat_gateway_name
  }

}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw.id
  }

  tags = {
    name = var.private_route_table_name
    env  = var.environment
  }

  depends_on = [aws_vpc.vpc]
}

resource "aws_route_table_association" "private_association" {
  count          = var.public_subnet_count
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.private_rt.id

  depends_on = [aws_vpc.vpc, aws_subnet.public_subnet]
}


resource "aws_security_group" "eks_cluster_sg" {
    name        =  var.eks_cluster_sg_name
    description = "Allow 433 from jump server"
    vpc_id      = aws_vpc.vpc.id

    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

    tags = {
        name = "${local.cluster_name}-eks-cluster-sg"
        env  = var.environment
    }
}
