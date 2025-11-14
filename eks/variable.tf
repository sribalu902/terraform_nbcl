###########################################
# EKS MAIN CONFIG VARIABLES
###########################################


variable "node_instance_type" {
  description = "EC2 instance type for worker nodes (self-managed)"
  type        = string
}


variable "node_ami_id" {
  description = "Amazon EKS-Optimized AMI ID"
  type        = string
}

variable "desired_capacity" {
  description = "ASG desired number of worker nodes"
  type        = number
}

variable "min_size" {
  description = "ASG minimum worker nodes"
  type        = number
}

variable "max_size" {
  description = "ASG maximum worker nodes"
  type        = number
}

variable "ssh_key_name" {
  description = "SSH key name for worker nodes"
  type        = string
}
