variable "cluster_name" {
  type        = string
  default     = "cluster-eks"
  description = "The name of the EKS cluster"
}

variable "vpc_cidr" {
  default = ""
}

variable "environment" {
  default = ""
}

variable "public_subnet_count" {
  default = ""
}

variable "availability_zones" {
  default = ""
}

variable "public_subnet_cidrs" {
  default = ""
}

variable "public_subnet_name" {
  default = ""
}

variable "public_route_table_name" {
  default = ""
}

variable "private_route_table_name" {
  default = ""
}

variable "nat_gateway_name" {
  default = ""
}

variable "eks_cluster_sg_name" {
  default = ""
}