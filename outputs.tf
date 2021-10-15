output "instance_ips" {
  value = aws_instance.master.public_ip
}