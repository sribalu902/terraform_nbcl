variable "ami_ids" {
  description = "List of AMI IDs for the EC2 instances"
  type        = list(string)
  
}

variable "instance_types" {
  description = "List of instance types for the EC2 instances"
  type        = list(string)


}

variable "subnet_id" {
  description = "List of subnet IDs for the EC2 instances"
  type        = list(string) #if you want to pass multiple subnet ids you can use this or else string type for single subnet id
}

variable "security_group_id" {
  description = "List of security group IDs to associate with the EC2 instances"
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