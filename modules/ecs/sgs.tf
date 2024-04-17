resource "aws_security_group" "instance_sg" {
  description = "controls direct access to application instances"
  vpc_id      = var.vpc_id
  name        = "application-instances-sg"
 
  ingress {
    protocol    = "tcp"
    from_port   = 32768
    to_port     = 65535
    description = "Access from ALB"
 
    security_groups = [
      var.alb_sg_id,
    ]
  }
 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}