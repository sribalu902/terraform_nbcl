module  vpc  {
  source                      = "../../vpc"
  public_subnet_cidrs         = var.public_subnet_cidrs
  private_subnet_cidrs        = var.private_subnet_cidrs
 public_subnet_azs            = var.public_subnet_azs
 private_subnet_azs           = var.private_subnet_azs
 cluster_name                 = var.cluster_name
}

module security_group{
  source                      = "../../security_group"
  public_sg                   = var.public_sg
  vpc_id                      = module.vpc.vpc_id
}

module ec2_instance {
  source                      = "../../ec2"
  instance_types              =  var.instance_types
  ami_ids                     =  var.ami_ids
  subnet_id                   =  module.vpc.public_subnet_id # module.vpc.public_subnet_id[0] ==> you can use this if you want all ec2 instances in single subnet
  security_group_id          =  [module.security_group.security_group_id]
  key_name                    =  var.key_name
  ec2_instance_names          =  var.ec2_instance_names
}