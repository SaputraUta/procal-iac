variable "name" { type = string }
variable "vpc_id" { type = string }
variable "subnet_id" { type = string }
variable "alb_sg_id" { type = string }
variable "https_listener_arn" { type = string }
variable "public_zone_id" { type = string }
variable "alb_dns_name" { type = string }
variable "alb_zone_id" { type = string }
variable "hostname" { type = string }
variable "app_port" { type = number }
variable "health_check_path" {
  type    = string
  default = "/"
}
variable "listener_priority" { type = number }
variable "instance_type" {
  type    = string
  default = "t3.small"
}
variable "policy_arns" {
  type    = list(string)
  default = []
}
variable "tags" {
  type    = map(string)
  default = {}
}