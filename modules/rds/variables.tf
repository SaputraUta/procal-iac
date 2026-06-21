variable "name_prefix" {
  type = string
}
variable "subnet_ids" {
  type = list(string)
}
variable "vpc_security_group_ids" {
  type = list(string)
}
variable "instance_class" {
  type = string
  default = "db.t3.micro"
}
variable "allocated_storage" {
  type = number
  default = 20
}
variable "engine_version" {
  type = string
  default = "16"
}
variable "db_name" {
  type = string
  default = "procal"
}
variable "master_username" {
  type = string
  default = "procal"
}
variable "multi_az" {
  type = bool
  default = false
}
variable "tags" {
  type = map(string)
  default = {}
}
