#to define variables for subnet cidrs and availability zones
variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}
variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
}
variable "public_subnet_azs" {
  description = "List of availability zones for public subnets"
  type        = list(string)
  
}
variable "private_subnet_azs" {
  description = "List of availability zones for private subnets"
  type        = list(string)
  
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "public_sg" {
  description = "Name of the security group for EC2 instances in the public subnet"
  type        = string
  default     = "ec2-public-sg"
}

variable "ami_ids" {
  description = "List of AMI IDs for the EC2 instances"
  type        = list(string)
  
}

variable "instance_types" {
  description = "List of instance types for the EC2 instances"
  type        = list(string)


}


variable "key_name" {
  description = "Key pair name for SSH access"
  type        = string
  
}
variable "ec2_instance_names" {
  description = "List of names for the EC2 instances"
  type        = list(string)
  
}