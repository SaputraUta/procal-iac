variable "public_domain" { type = string }
variable "private_domain" { type = string }
variable "vpc_id" { type = string }
variable "tags" {
  type    = map(string)
  default = {}
}