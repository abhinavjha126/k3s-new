

resource "aws_instance" "controllers" {
  provider = aws
  ami      = var.ami_image
  key_name = aws_key_pair.ssh_key.key_name
  instance_type = var.master_instance_type
  for_each = var.master_instances  
  subnet_id = [for subnet in aws_subnet.master_subnets: subnet.id if subnet.availability_zone == each.value.az && subnet.id != 0][0]
  vpc_security_group_ids = [aws_security_group.main.id]
  private_ip = each.value.ip_address
  user_data = data.template_file.user_data_controller.rendered



  root_block_device {
    volume_type = var.master_root_volume_type
    volume_size = var.master_root_volume_size
    delete_on_termination = "true"
  }

  tags = merge(
    {
      Name        = "master${each.value.id}"
      Project     = var.project
      Environment = var.prod_env
      ManagedBy   = "terraform"
    }
  )
}

data "template_file" "user_data_controller" {
  template = file("cloud-init-controller")
      vars = {
    k3s-version = var.k3s_version
    hostname = var.kube_master_hostname 

  }
}

