variable "aws_region" {
  type = string
  default = "us-east-2"
}


variable "tags" {
  type = object({
    name = string
    environment = string
    developer = string
    team = string
  })

  default = {
    name = "EphraimX"
    developer = "TheJackalX"
    environment = "Production"
    team = "Boogey Team"
  }
}

variable "DB_PORT" {
  type = number
  sensitive = true
}


variable "DB_NAME" {
  type = string
  default = "roi_calculator"
}


variable "DB_USER" {
  type = string
  sensitive = true
}


variable "DB_PASSWORD" {
  type = string
  sensitive = true
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


variable "DB_TYPE" {
  type = string
  default = "postgresql"
}


# variable "NEXT_PUBLIC_APIURL" {
#   type = string
#   sensitive = true
# }


variable "CLIENT_URL" {
  type = string
  default = "*"
}
