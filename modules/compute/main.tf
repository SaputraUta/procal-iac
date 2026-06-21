data "aws_ami" "ubuntu" {
  most_recent = true
  owners = ["099720109477"]
  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_iam_role" "this" {
  name = "${var.name_prefix}-ec2-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "this" {
  name = "${var.name_prefix}-ec2-profile"
  role = aws_iam_role.this.name
}

resource "aws_launch_template" "this" {
  name_prefix = "${var.name_prefix}-lt-"
  image_id = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  vpc_security_group_ids = [var.app_sg_id]

  iam_instance_profile {
    arn = aws_iam_instance_profile.this.arn
  }

  tag_specifications {
    resource_type = "instance"
    tags = merge(var.tags, { Name = "${var.name_prefix}-app" })
  }
}

resource "aws_autoscaling_group" "this" {
  name_prefix = "${var.name_prefix}-asg-"
  desired_capacity = var.desired_capacity
  min_size = var.min_size
  max_size = var.max_size
  vpc_zone_identifier = var.subnet_ids
  target_group_arns = [var.target_group_arn]
  health_check_type = var.health_check_type
  health_check_grace_period = 300

  launch_template {
    id = aws_launch_template.this.id
    version = "$Latest"
  }

  tag {
    key = "Name"
    value = "${var.name_prefix}-app"
    propagate_at_launch = true
  }
}