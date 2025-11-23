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

variable "private_subnet_count" {
  default = ""
}

variable "availability_zones" {
  default = ""
}

variable "private_availability_zones" {
  default = ""
}

variable "public_subnet_cidrs" {
  default = ""
}

variable "private_subnet_cidrs" {
  default = ""
}

variable "public_subnet_name" {
  default = ""
}

variable "private_subnet_name" {
  default = ""
}


variable "endpoint_private_access" {}

variable "endpoint_public_access" {}

variable "eks_version" {
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

variable "is_eks_enabled" {
  default = ""
}

variable "addons" {
  type = list(object({
    name    = string
    version = string
  }))
}

variable "desired_capacity_on_demand" {
  default = ""
}

variable "min_capacity_on_demand" {
  default = ""
}

variable "max_capacity_on_demand" {
  default = ""
}

variable "ondemand_instance_types" {
  default = ""
}

variable "spot_instance_types" {
  default = ""
}