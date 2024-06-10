output "cluster_arn" {
    value = aws_iam_role.eks_role.arn
}

output "EKSClusterPolicy" {
  value = aws_iam_role_policy_attachment.eks_cluster_AmazonEKSClusterPolicy
}

output "EKSServicePolicy" {
  value = aws_iam_role_policy_attachment.eks_cluster_AmazonEKSServicePolicy
}

output "EKSWorkerNodePolicy" {
  value = aws_iam_role_policy_attachment.eks_node_AmazonEKSWorkerNodePolicy
}

output "EKS_CNI_Policy" {
  value = aws_iam_role_policy_attachment.eks_node_AmazonEKS_CNI_Policy
}

output "EC2ContainerRegistryReadOnly" {
  value = aws_iam_role_policy_attachment.eks_node_AmazonEC2ContainerRegistryReadOnly
}