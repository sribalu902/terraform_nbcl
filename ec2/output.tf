output "ec2_instance_id" {
    value = aws_instance.nbsl_ec2[*].id
}

