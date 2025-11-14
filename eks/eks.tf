############################################
# DYNAMIC VPC
############################################
data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["nbsl-vpc"]
  }
}

############################################
# DYNAMIC SUBNETS
############################################
data "aws_subnets" "private" {
  filter {
    name   = "tag:Type"
    values = ["private"]
  }
}

############################################
# SECURITY GROUP FOR NODES (dynamic)
############################################
data "aws_security_group" "workers" {
  filter {
    name   = "group-name"
    values = ["ec2-public-sg"]
  }
}

############################################
# EKS CONTROL PLANE IAM ROLE
############################################
resource "aws_iam_role" "eks_cluster_role" {
  name = "nbsl-eks-cluster-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "eks.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

############################################
# EKS CLUSTER
############################################
resource "aws_eks_cluster" "eks" {
  name     = "nbsl-eks-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    # subnet_ids = concat(
    #   data.aws_subnets.private.ids,
    #   data.aws_subnets.public.ids
    # )
    subnet_ids = data.aws_subnets.private.ids
    endpoint_public_access = false
    endpoint_private_access = true
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy
  ]
}


############################################
# NODE IAM ROLE
############################################
resource "aws_iam_role" "node_role" {
  name = "nbsl-eks-cluster-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "ec2.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "worker_node_policy" {
  role       = aws_iam_role.node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "cni_policy" {
  role       = aws_iam_role.node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_instance_profile" "worker_profile" {
  name = "nbsl-eks-cluster-worker-profile"
  role = aws_iam_role.node_role.name
}

############################################
# LAUNCH TEMPLATE
############################################
resource "aws_launch_template" "worker_lt" {
  name_prefix   = "nbsl-eks-cluster-lt-"
  image_id      = var.node_ami_id
  instance_type = var.node_instance_type
  key_name      = var.ssh_key_name

  iam_instance_profile {
    name = aws_iam_instance_profile.worker_profile.name
  }

  network_interfaces {
    security_groups = [data.aws_security_group.workers.id]
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    /etc/eks/bootstrap.sh nbsl-eks-cluster
  EOF
  )
}

############################################
# AUTO SCALING GROUP
############################################
resource "aws_autoscaling_group" "worker_asg" {
  name                = "nbsl-eks-cluster-asg"
  desired_capacity    = var.desired_capacity
  min_size            = var.min_size
  max_size            = var.max_size

  vpc_zone_identifier = data.aws_subnets.private.ids

  launch_template {
    id      = aws_launch_template.worker_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "kubernetes.io/cluster/nbsl-eks-cluster"
    value               = "owned"
    propagate_at_launch = true
  }
}
