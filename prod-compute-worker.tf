resource "aws_instance" "workers" {
  provider = aws
  ami           = var.ami_image
  key_name = aws_key_pair.ssh_key.key_name
  instance_type = var.worker_instance_type
  for_each = var.worker_instances
  subnet_id = [for subnet in aws_subnet.worker_subnets: subnet.id if subnet.availability_zone == each.value.az][0]
  vpc_security_group_ids = [aws_security_group.main.id]
  private_ip = each.value.ip_address
  user_data = data.template_file.user_data_worker.rendered




  root_block_device {
    volume_type = var.worker_root_volume_type
    volume_size = var.worker_root_volume_size
    delete_on_termination = "true"
  }

  tags = merge(
    {
      Name        = "worker${each.value.id}"
      Project     = var.project
      Environment = var.prod_env
      ManagedBy   = "terraform"
    }
  )
}



data "template_file" "user_data_worker" {
  template = file("cloud-init-worker")
    vars = {
    k3s-version = var.k3s_version
    hostname = var.kube_master_hostname 

  }
}


