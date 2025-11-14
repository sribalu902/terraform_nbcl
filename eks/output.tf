###########################################
# EKS OUTPUTS
###########################################

output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = aws_eks_cluster.eks.name
}

output "cluster_endpoint" {
  description = "EKS API Server endpoint"
  value       = aws_eks_cluster.eks.endpoint
}

output "cluster_certificate" {
  description = "Cluster CA certificate"
  value       = aws_eks_cluster.eks.certificate_authority[0].data
}

output "worker_asg_name" {
  description = "Name of the worker Auto Scaling Group"
  value       = aws_autoscaling_group.worker_asg.name
}

output "launch_template_id" {
  description = "Launch Template ID for worker nodes"
  value       = aws_launch_template.worker_lt.id
}

output "node_role_arn" {
  description = "IAM role used by worker nodes"
  value       = aws_iam_role.node_role.arn
}
