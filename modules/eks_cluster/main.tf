# Create the EKS cluster
resource "aws_eks_cluster" "eks" {
  name     = var.my_cluster_name
  role_arn = var.cluster_arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }
}