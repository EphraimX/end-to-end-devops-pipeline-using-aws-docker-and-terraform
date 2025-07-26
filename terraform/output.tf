output "aws_rds_endpoint" {
  depends_on = [aws_db_instance.roi_calculator]
  value = aws_db_instance.roi_calculator.endpoint
}