variable "name_prefix" {
  type = string
}
variable "subnet_ids" {
  type = list(string)
}
variable "app_sg_id" {
  type = string
}
variable "target_group_arn" {
  type = string
}
variable "instance_type" {
  type = string
  default = "t3.micro"
}
variable "desired_capacity" {
  type = number
  default = 1
}
variable "min_size" {
  type = number
  default = 1
}
variable "max_size" {
  type = number
  default = 2
}
variable "health_check_type" {
  type = string
  default = "EC2"
}
variable "tags" {
  type = map(string)
  default = {}
}