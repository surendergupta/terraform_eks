output "name" {
  value = aws_eks_cluster.eks.name
}
output "endpoint" {
  description = "EKS cluster endpoint"
  value = aws_eks_cluster.eks.endpoint
}
output "cluster_security_group_id" {
  description = "Security group ID of the EKS cluster"
  value = aws_eks_cluster.eks.vpc_config[0].cluster_security_group_id
}