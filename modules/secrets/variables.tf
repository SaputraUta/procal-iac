variable "name_prefix" { type = string }
variable "secrets" {
  type = map(object({
    description = string
  }))
  default = {
    "dora"  = { description = "dora app secrets (JWT, etc.)" }
    "boots" = { description = "boots SMTP creds" }
  }
}
variable "tags" {
  type    = map(string)
  default = {}
}