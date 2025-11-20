##########################################
# VPC PEERING CONNECTION
##########################################

resource "aws_vpc_peering_connection" "peer" {
  vpc_id      = var.vpc_id_1
  peer_vpc_id = var.vpc_id_2
  auto_accept = true

  tags = {
    Name = var.peering_name
  }
}
##################################################
# Route from VPC1 -> VPC2 using the FIRST private RT of VPC1
##################################################################
resource "aws_route" "vpc1_to_vpc2" {
  # use the first private route table id (index 0)
  route_table_id            = var.private_rt_vpc1[0]
  destination_cidr_block    = var.vpc_cidr_2
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
  depends_on = [aws_vpc_peering_connection.peer]
}

###################################################
# Route from VPC2 -> VPC1 using the FIRST private RT of VPC2
###################################################
resource "aws_route" "vpc2_to_vpc1" {
  route_table_id            = var.private_rt_vpc2[0]
  destination_cidr_block    = var.vpc_cidr_1
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
  depends_on = [aws_vpc_peering_connection.peer]
}
