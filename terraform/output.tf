output "aws_rds_address" {
  depends_on = [aws_db_instance.roi_calculator]
  value = aws_db_instance.roi_calculator.address
}


output "production_host_ip_private_subnet_one" {
  depends_on = [aws_instance./scripts/production-host.sh]
  value = aws_instance.roi_calculator_bastion_host_ec2_public_subnet_one.public_ip
}


output "production_host_ip_private_subnet_two" {
  depends_on = [aws_instance.roi_calculator_bastion_host_ec2_public_subnet_one]
  value = aws_instance.roi_calculator_bastion_host_ec2_public_subnet_one.public_ip
}