locals {
  my_ip_cidr = "${chomp(tostring(data.http.my_ip.response_body))}/32"
}

resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "Allow Postgres inbound traffic"
  vpc_id      = data.aws_vpc.default.id  # Replace with your VPC ID

  ingress {
    description = "Allow Postgres from my IP"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [local.my_ip_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


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
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
}