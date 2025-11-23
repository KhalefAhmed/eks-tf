variable "cluster_name" {
  type        = string
  default     = "cluster-eks"
  description = "The name of the EKS cluster"
}

variable "vpc_cidr" {}

variable "environment" {}

variable "public_subnet_count" {}

variable "private_subnet_count" {}

variable "availability_zones" {}

variable "private_availability_zones" {}

variable "public_subnet_cidrs" {}

variable "private_subnet_cidrs" {}

variable "public_subnet_name" {}

variable "private_subnet_name" {}


variable "endpoint_private_access" {}

variable "endpoint_public_access" {}

variable "eks_version" {}

variable "public_route_table_name" {}

variable "private_route_table_name" {}

variable "nat_gateway_name" {}

variable "eks_cluster_sg_name" {}

variable "is_eks_enabled" {
  type = bool
}

variable "is_eks_role_enabled" {
  type = bool
}

variable "addons" {
  type = list(object({
    name    = string
    version = string
  }))
}

variable "desired_capacity_on_demand" {}

variable "min_capacity_on_demand" {}

variable "max_capacity_on_demand" {}

variable "ondemand_instance_types" {}

variable "spot_instance_types" {}