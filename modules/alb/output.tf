output "lb_sg_id" {
  description = "The ID of the EC2 Security Group."
  value       = aws_security_group.lb_sg.id
}

output "alb_arn" {
  value = aws_alb.nstar-us-alb.arn
}

output "aws_alb_target_group_id" {
      value = aws_alb_target_group.nginx.id
}

output "alb_url" {
  value = aws_alb.nstar-us-alb.dns_name
}