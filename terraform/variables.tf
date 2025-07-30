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