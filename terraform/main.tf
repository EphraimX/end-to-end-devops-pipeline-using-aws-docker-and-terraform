resource "aws_vpc" "roi_calculator_vpc" {
  cidr_block = "10.10.0.0/16"
  tags = var.tags
}


resource "aws_subnet" "roi_calculator_public_subnet_one" {
  vpc_id = aws_vpc.roi_calculator_vpc.id
  cidr_block = "10.10.10.0/24"
  tags = var.tags
}


resource "aws_subnet" "roi_calculator_public_subnet_two" {
  vpc_id = aws_vpc.roi_calculator_vpc.id
  cidr_block = "10.10.20.0/24"
  tags = var.tags
}


resource "aws_subnet" "roi_calculator_private_subnet_one" {
  vpc_id = aws_vpc.roi_calculator_vpc.id
  cidr_block = "10.10.30.0/24"
  tags = var.tags
}


resource "aws_subnet" "roi_calculator_private_subnet_two" {
  vpc_id = aws_vpc.roi_calculator_vpc.id
  cidr_block = "10.10.40.0/24"
  tags = var.tags
}


resource "aws_internet_gateway" "roi_calculator_igw" {
  vpc_id = aws_vpc.roi_calculator_vpc.id
  tags = var.tags
}


resource "aws_internet_gateway_attachment" "roi_calculator_igw_attachment" {
  internet_gateway_id = aws_internet_gateway.roi_calculator_igw.id
  vpc_id = aws_vpc.roi_calculator_vpc.id
}


resource "aws_route_table" "roi_calculator_route_table" {
  vpc_id = aws_vpc.roi_calculator_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.roi_calculator_igw.id
  }

  tags = var.tags 
}


resource "aws_route_table_association" "roi_calculator_route_table_association_public_subnet_one" {
  route_table_id = aws_route_table.roi_calculator_route_table.id
  subnet_id = aws_subnet.roi_calculator_public_subnet_one.id
}


resource "aws_route_table_association" "roi_calculator_route_table_association_public_subnet_two" {
  route_table_id = aws_route_table.roi_calculator_route_table.id
  subnet_id = aws_subnet.roi_calculator_public_subnet_two.id
}


resource "aws_security_group" "roi_calculator_bastion_host_sg" {
  name = "roi-calculator-bastion-host-sg"
  vpc_id = aws_vpc.roi_calculator_vpc.id
}


resource "aws_vpc_security_group_ingress_rule" "roi_calculator_grafana_sg_ingress" {
  security_group_id = aws_security_group.roi_calculator_bastion_host_sg.id
  description = "grafana"
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 3000
  to_port = 3000
  ip_protocol = "tcp"
}


resource "aws_vpc_security_group_ingress_rule" "roi_calculator_ssh_ingress" {
  security_group_id = aws_security_group.roi_calculator_bastion_host_sg.id
  description = "ssh"
  cidr_ipv4         = "0.0.0.0/0"   # Open to the world – for production, restrict this!
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}


resource "aws_vpc_security_group_egress_rule" "bastion_host_allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.roi_calculator_bastion_host_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}


resource "aws_security_group" "roi_calculator_production_host_sg" {
  name = "roi-calculator-production-host-sg"
  vpc_id = aws_vpc.roi_calculator_vpc.id
  tags = var.tags
}


resource "aws_vpc_security_group_ingress_rule" "roi_calculator_http_sg_ingress" {
  security_group_id = aws_security_group.roi_calculator_production_host_sg.id
  description = "http"
  cidr_ipv4 = aws_vpc.roi_calculator_vpc.cidr_block
  from_port = 80
  to_port = 80
  ip_protocol = "tcp"
}


resource "aws_vpc_security_group_ingress_rule" "roi_calculator_https_sg_ingress" {
  security_group_id = aws_security_group.roi_calculator_production_host_sg.id
  description = "https"
  cidr_ipv4 = aws_vpc.roi_calculator_vpc.cidr_block
  from_port = 443
  to_port = 443
  ip_protocol = "tcp"
}


resource "aws_vpc_security_group_ingress_rule" "roi_calculator_fastapi_sg_ingress" {
  security_group_id = aws_security_group.roi_calculator_production_host_sg.id
  description = "fastapi"
  cidr_ipv4 = aws_vpc.roi_calculator_vpc.cidr_block
  from_port = 8000
  to_port = 8000
  ip_protocol = "tcp"
}


resource "aws_vpc_security_group_ingress_rule" "roi_calculator_next_js_sg_ingress" {
  security_group_id = aws_security_group.roi_calculator_production_host_sg.id
  description = "next_js"
  cidr_ipv4 = aws_vpc.roi_calculator_vpc.cidr_block
  from_port = 8081
  to_port = 8081
  ip_protocol = "tcp"
}


resource "aws_vpc_security_group_ingress_rule" "roi_calculator_prometheus_sg_ingress" {
  security_group_id = aws_security_group.roi_calculator_production_host_sg.id
  description = "prometheus"
  cidr_ipv4 = aws_vpc.roi_calculator_vpc.cidr_block
  from_port = 9090
  to_port = 9090
  ip_protocol = "tcp"
}


resource "aws_vpc_security_group_ingress_rule" "roi_calculator_cadvisor_sg_ingress" {
  security_group_id = aws_security_group.roi_calculator_production_host_sg.id
  description = "cadvisor"
  cidr_ipv4 = aws_vpc.roi_calculator_vpc.cidr_block
  from_port = 8085
  to_port = 8085
  ip_protocol = "tcp"
}


resource "aws_vpc_security_group_ingress_rule" "roi_calculator_node_exporter_sg_ingress" {
  security_group_id = aws_security_group.roi_calculator_production_host_sg.id
  description = "node_exporter"
  cidr_ipv4 = aws_vpc.roi_calculator_vpc.cidr_block
  from_port = 9113
  to_port = 9113
  ip_protocol = "tcp"
}


resource "aws_vpc_security_group_egress_rule" "production_host_allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.roi_calculator_production_host_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}


resource "aws_security_group" "roi_calculator_alb_sg" {
  name = "roi-calculator-alb-sg"
  vpc_id = aws_vpc.roi_calculator_vpc.id
  tags = var.tags
}


resource "aws_vpc_security_group_ingress_rule" "roi_calculator_alb_sg_http" {
  security_group_id = aws_security_group.roi_calculator_alb_sg.id
  description = "alb_http"
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 80
  to_port = 80
  ip_protocol = "tcp"
}


resource "aws_vpc_security_group_ingress_rule" "roi_calculator_alb_sg_https" {
  security_group_id = aws_security_group.roi_calculator_alb_sg.id
  description = "alb_https"
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 443
  to_port = 443
  ip_protocol = "tcp"
}


resource "aws_vpc_security_group_egress_rule" "alb_allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.roi_calculator_alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}


resource "aws_db_subnet_group" "roi_calculator_rds_db_subnet_group" {
  name       = "roi-calculator-rds-db-subnet-group"
  subnet_ids = [aws_subnet.frontend.id, aws_subnet.backend.id]
  tags = var.tags
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
    cidr_blocks = [aws_vpc.roi_calculator_vpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_vpc.roi_calculator_vpc.cidr_block]
  }
}


resource "aws_db_instance" "roi_calculator" {
  identifier = var.DB_IDENTIFIER
  allocated_storage = 5
  db_name = var.DB_NAME
  engine = var.DB_ENGINE
  engine_version = "17.5"
  instance_class = var.DB_INSTANCE_CLASS
  username = var.DB_USER
  password = var.DB_PASSWORD
  skip_final_snapshot = true
  port = var.DB_PORT
  publicly_accessible = false
  db_subnet_group_name = aws_db_subnet_group.roi_calculator_rds_db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
}


resource "aws_lb" "roi_calculator_aws_lb" {
  name               = "roi-calculator-aws-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.roi_calculator_alb_sg.id]
  subnets            = [aws_subnet.roi_calculator_public_subnet_one.id, aws_subnet.roi_calculator_public_subnet_two.id]

  tags = var.tags
}


resource "aws_lb_target_group" "roi_calculator_aws_lb_target_group" {
  name     = "roi-calculator-aws-lb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.roi_calculator_vpc.id
}


resource "aws_lb_listener" "roi_calculator_alb_sg_listener" {

  load_balancer_arn = aws_lb.roi_calculator_aws_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.roi_calculator_aws_lb_target_group.arn
  }
}