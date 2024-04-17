# ECS cluster
resource "aws_ecs_cluster" "nstar-web" {
  name = "nstar-web"
}
#Compute
resource "aws_autoscaling_group" "nstar-web-cluster" {
  name                      = "nstar-web-cluster"
  vpc_zone_identifier       = var.public_subnet_ids
  min_size                  = "2"
  max_size                  = "10"
  desired_capacity          = "2"
  launch_configuration      = "${aws_launch_configuration.nstar-web-cluster-lc.name}"
  health_check_grace_period = 120
  default_cooldown          = 30
  termination_policies      = ["OldestInstance"]
 
  tag {
    key                 = "Name"
    value               = "ECS-nstar-web"
    propagate_at_launch = true
  }
}
 
resource "aws_autoscaling_policy" "nstar-web-cluster" {
  name                      = "nstar-web-ecs-auto-scaling"
  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = "90"
  adjustment_type           = "ChangeInCapacity"
  autoscaling_group_name    = "${aws_autoscaling_group.nstar-web-cluster.name}"
 
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
 
    target_value = 40.0
  }
}
 
resource "aws_launch_configuration" "nstar-web-cluster-lc" {
  name_prefix     = "nstar-web-cluster-lc"
  security_groups = ["${aws_security_group.instance_sg.id}"]
 
  # key_name                    = "${aws_key_pair.nstar-webdev.key_name}"
  image_id                    = "${data.aws_ami.nstar-ecs-ami.id}"
  instance_type               = "${var.instance_type}"
  iam_instance_profile        = "${aws_iam_instance_profile.ecs-ec2-role.id}"
  user_data                   = "${data.template_file.ecs-cluster.rendered}"
  associate_public_ip_address = true
 
  lifecycle {
    create_before_destroy = true
  }
}

# NGINX Service
resource "aws_ecs_service" "nginx" {
  name            = "nginx"
  cluster         = "${aws_ecs_cluster.nstar-web.id}"
  task_definition = "${aws_ecs_task_definition.nginx.arn}"
  desired_count   = 4
  iam_role        = "${aws_iam_role.ecs-service-role.arn}"
  depends_on      = ["aws_iam_role_policy_attachment.ecs-service-attach"]
 
  load_balancer {
    target_group_arn = var.aws_alb_target_group_id
    container_name   = "nginx"
    container_port   = "80"
  }
 
  lifecycle {
    ignore_changes = ["task_definition"]
  }
}
 
resource "aws_ecs_task_definition" "nginx" {
  family = "nginx"
 
  container_definitions = <<EOF
[
  {
    "portMappings": [
      {
        "hostPort": 0,
        "protocol": "tcp",
        "containerPort": 80
      }
    ],
    "cpu": 256,
    "memory": 300,
    "image": "nginx:latest",
    "essential": true,
    "name": "nginx",
    "logConfiguration": {
    "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs-nstar-web/nginx",
        "awslogs-region": "${data.aws_region.current.name}",
        "awslogs-stream-prefix": "ecs"
      }
    }
  }
]
EOF
}
 
resource "aws_cloudwatch_log_group" "nginx" {
  name = "/ecs-nstar-web/nginx"
}