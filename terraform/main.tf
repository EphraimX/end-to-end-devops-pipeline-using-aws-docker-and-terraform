resource "aws_db_instance" "roi_calculator" {
  identifier = "roi-calculator"
  allocated_storage = 5
  db_name = "roi_calculator"
  engine = "postgres"
  engine_version = "17.5"
  instance_class = "db.t3.micro"
  username = "foo"
  password = "foogazzi"
  skip_final_snapshot = true
  port = 5432
  publicly_accessible = true
}