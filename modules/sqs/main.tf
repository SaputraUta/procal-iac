resource "aws_sqs_queue" "this" {
  name                      = "${var.name_prefix}-emails"
  receive_wait_time_seconds = 20
  message_retention_seconds = 345600
  tags                      = merge(var.tags, { Name = "${var.name_prefix}-emails" })
}