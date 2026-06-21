resource "aws_route53_zone" "public" {
  name = var.public_domain
  tags = var.tags
}

resource "aws_route53_zone" "private" {
  name = var.private_domain
  vpc {
    vpc_id = var.vpc_id
  }
  tags = var.tags
}