resource "aws_secretsmanager_secret" "this" {
  for_each    = var.secrets
  name        = "${var.name_prefix}/${each.key}"
  description = each.value.description
  tags        = var.tags
}