output "frontend_public_ip" {
  value = aws_instance.tc_frontend.public_ip
}

output "backend_private_ip" {
  value = aws_instance.tc_backend.private_ip
}

output "ops_private_ip" {
  value = aws_instance.tc_ops.private_ip
}

output "ssh_commands" {
  value = {
    frontend = "ssh -i ~/.ssh/${var.key_pair_name}.pem ubuntu@${aws_instance.tc_frontend.public_ip}"
    backend  = "ssh -i ~/.ssh/${var.key_pair_name}.pem ec2-user@${aws_instance.tc_backend.private_ip}"
    ops      = "ssh -i ~/.ssh/${var.key_pair_name}.pem ec2-user@${aws_instance.tc_ops.private_ip}"
  }
}