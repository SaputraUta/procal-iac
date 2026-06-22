output "instance_id" {
  value = aws_instance.this.id
}
output "private_id" {
  value = aws_instance.this.private_ip
}
output "url" {
  value = "https://${var.hostname}"
}