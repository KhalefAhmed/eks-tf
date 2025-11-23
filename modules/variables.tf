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
