resource "aws_sqs_queue" "this" {
  name                      = "${var.name_prefix}-emails"
  receive_wait_time_seconds = 20
  message_retention_seconds = 345600
  sqs_managed_sse_enabled   = true
  tags                      = merge(var.tags, { Name = "${var.name_prefix}-emails" })
}