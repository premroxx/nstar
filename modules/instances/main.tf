resource "aws_security_group" "sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
}

resource "aws_instance" "inst" {
  ami                         = var.ami
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.sg.id]
  subnet_id                   = var.public_subnet_id
  associate_public_ip_address = true
  tags = {
    Name = "inst"
  }
}

resource "aws_launch_template" "asg-lt" {
  name                   = var.aws_launch_template_name
  image_id               = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.server-sg.id]
  # user_data              = filebase64("user-data.sh")
  # depends_on             = [github_repository_file.dbendpoint]

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = var.instance_name
    }
  }
}

resource "aws_alb_target_group" "app-lb-tg" {
  name        = var.load_balancer_target_group_name
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }
}

resource "aws_alb" "app-lb" {
  name               = var.load_balancer_name
  ip_address_type    = "ipv4"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg.id]
  subnets            = [var.public_subnet_id]
}

resource "aws_alb_listener" "app-listener" {
  load_balancer_arn = aws_alb.app-lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.app-lb-tg.arn
  }
}

resource "aws_autoscaling_group" "app-asg" {
  max_size                  = 3
  min_size                  = 1
  desired_capacity          = 2
  name                      = var.aws_autoscaling_group_name
  health_check_grace_period = 300
  health_check_type         = "ELB"
  target_group_arns         = [aws_alb_target_group.app-lb-tg.arn]
  vpc_zone_identifier       = aws_alb.app-lb.subnets

  launch_template {
    id      = aws_launch_template.asg-lt.id
    version = aws_launch_template.asg-lt.latest_version
    # version = "$Latest"
  }
}