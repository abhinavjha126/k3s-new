resource "aws_key_pair" "ssh_key" {
  key_name   = "k3s_key"
  public_key = var.ssh_key
}

