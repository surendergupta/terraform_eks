# Fetch the availability zones
data "aws_availability_zones" "available" {}

locals {
  availability_zones = data.aws_availability_zones.available.names
}

module "iam_role_cluster" {
  source        = "./modules/iam_role"
  iam_role_name = var.iam_cluster_role_name
  eks_cluster_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "eks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

module "vpc" {
  source     = "./modules/vpc"
  tag_name   = var.vpc_tag_name
  cidr_block = var.vpc_cidr_block
}

module "igw" {
  source       = "./modules/igw"
  igw_vpc_id   = module.vpc.id
  igw_tag_name = var.igw_tag_name
}

module "subnet" {
  source                   = "./modules/subnets"
  count                    = var.subnets_count
  subnet_vpc_id            = module.vpc.id
  subnet_cidr_block        = cidrsubnet(module.vpc.cidr_block, 8, count.index)
  subnet_availability_zone = element(local.availability_zones, count.index)
  tag_name                 = "${var.subnet_tag_name}-${count.index}"
}

module "route_table" {
  source         = "./modules/route_table"
  vpc_id         = module.vpc.id
  igw_id         = module.igw.id
  route_tag_name = var.route_tag_name
}

# Associate the Public Subnets with the Route Table
resource "aws_route_table_association" "public" {
  for_each = { for idx, subnet in module.subnet : idx => subnet }
  # count          = length(module.subnet.id)
  subnet_id      = each.value.id
  route_table_id = module.route_table.id
}

module "eks_cluster" {
  depends_on = [
    module.iam_role_cluster.EKSClusterPolicy,
    module.iam_role_cluster.EKSServicePolicy,
  ]

  source          = "./modules/eks_cluster"
  my_cluster_name = var.eks_cluster_name
  cluster_arn     = module.iam_role_cluster.cluster_arn
  subnet_ids      = [for subnet in module.subnet : subnet.id]
}

module "iam_role_node_group" {
  source        = "./modules/iam_role"
  iam_role_name = var.iam_node_group_role_name
  eks_cluster_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

module "cluster_node_group" {
  depends_on = [
    module.iam_role_node_group.EKSWorkerNodePolicy,
    module.iam_role_node_group.EKS_CNI_Policy,
    module.iam_role_node_group.EC2ContainerRegistryReadOnly,
  ]

  source                = "./modules/eks_node_group"
  node_cluster_name     = module.eks_cluster.name
  node_group_name       = var.eks_cluster_node_group_name
  node_group_role_arn   = module.iam_role_node_group.cluster_arn
  node_group_subnet_ids = [for subnet in module.subnet : subnet.id]
  node_desired_size     = 2
  node_max_size         = 5
  node_min_size         = 2
  node_instance_types   = var.node_instance_type
  node_disk_size        = 25
}
