variable "aws_region" {
  type = string
  default = "us-east-2"
}


variable "tags" {
  type = object({
    name = "ROI Calculator Terraform"
    environment = "Production"
    developer = "EphraimX"
    teamm = "Crisis Management Team"
  })
}


variable "DB_HOST" {
  type = string
}


variable "DB_PORT" {
  type = number
  default = 5432
}


variable "DB_NAME" {
  type = string
}


variable "DB_USER" {
  type = string
}


variable "DB_PASSWORD" {
  type = string
}


variable "DB_IDENTIFIER" {
  type = string
  default = "roi-calculator"
}


variable "DB_INSTANCE_CLASS" {
  type = string
  default = "db.t3.micro"
}


variable "DB_ENGINE" {
  type = string
  default = "postgres"
}