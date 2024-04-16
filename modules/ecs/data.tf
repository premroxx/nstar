# Get the latest ECS AMI
data "aws_ami" "sys-ecs-ami" {
  most_recent = true
 
  filter {
    name   = "name"
    values = ["*amazon-ecs-optimized"]
  }
 
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
 
# User data for ECS cluster
data "template_file" "ecs-cluster" {
  template = "${file("../modules/ecs/ecs-cluster.tpl")}"
 
  vars = {
    ecs_cluster = "${aws_ecs_cluster.sys-web.name}"
  }
}

data "aws_region" "current" {}