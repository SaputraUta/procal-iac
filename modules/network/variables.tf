variable "name_prefix" {
  type        = string
  description = "Prefix for resource names"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "azs" {
  type        = list(string)
  description = "AZs, e.g. [\"ap-southeast-1a\", \"ap-southeast-1b\"]"
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to all network resources"
  default     = {}
}