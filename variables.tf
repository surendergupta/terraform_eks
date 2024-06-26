variable "iam_cluster_role_name" {
  description = "EKS Cluster role name for IAM ROLE"
  type        = string
}

variable "iam_node_group_role_name" {
  description = "EKS Cluster role name for IAM ROLE"
  type        = string
}

variable "vpc_tag_name" {
  description = "VPC Tag Name"
  type        = string
}

variable "vpc_cidr_block" {
  description = "VPC CIDR block range"
  type        = string
}

variable "igw_tag_name" {
  description = "Tag name for Internet gateway"
  type        = string
}
variable "subnets_count" {
  description = "subnet count"
  type        = number
}
variable "subnet_tag_name" {
  description = "Tag name for Subnets"
  type        = string
}

variable "route_tag_name" {
  description = "Tag name for Subnet Route Table"
  type        = string
}

variable "eks_cluster_name" {
  description = "EKS Cluster name"
  type        = string
}

variable "eks_cluster_node_group_name" {
  description = "EKS Cluster name"
  type        = string
}

variable "node_instance_type" {
  description = "EKS Cluster Node instance type"
  type        = list(string)
}