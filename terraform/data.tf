data "http" "my_ip" {
  url = "https://checkip.amazonaws.com"
}

data "aws_vpc" "default" {
  default = true
}