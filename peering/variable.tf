variable "vpc_id_1" {
  description = "VPC ID for first VPC"
  type        = string
}

variable "vpc_id_2" {
  description = "VPC ID for second VPC"
  type        = string
}

variable "vpc_cidr_1" {
  description = "CIDR for first VPC"
  type        = string
}

variable "vpc_cidr_2" {
  description = "CIDR for second VPC"
  type        = string
}

# Expect lists (one or more RT ids). We'll use the first element.
variable "private_rt_vpc1" {
  description = "List of private route table IDs for VPC1 (we will use index 0)"
  type        = list(string)
}

variable "private_rt_vpc2" {
  description = "List of private route table IDs for VPC2 (we will use index 0)"
  type        = list(string)
}

variable "peering_name" {
  description = "Name tag for the peering connection"
  type        = string
  default     = "vpc-peering"
}
