output "ec2_sg_id" {
  description = "The ID of the EC2 Security Group."
  value       = aws_security_group.sg.id
}

output "public_ip" {
  description = "Public IP"
  value       = aws_instance.inst.*.public_ip
}

output "websiteurl" {
  value = "http://${aws_alb.app-lb.dns_name}"
}
