resource "aws_security_group" "main" {
  name        = "main-sg"
  description = "main security group"
  vpc_id      = aws_vpc.prod.id

  tags = {
    Name        = "k3s-${var.prod_env}-main-sg"
    Role        = "main"
    Project     = "k3s"
    Environment = "prod"
    ManagedBy   = "terraform"
  }
}

resource "aws_security_group_rule" "main_egress_all" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.main.id
}

resource "aws_security_group_rule" "ingress_ssh" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.main.id

}

resource "aws_security_group_rule" "ingress_icmp" {
  type        = "ingress"
  from_port = -1
  to_port = -1
  protocol = "icmp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.main.id

}

resource "aws_security_group_rule" "ingress_k3s" {
  type        = "ingress"
  for_each = var.k3s_ingress_rules

  from_port   = each.value.from_port
  to_port     = each.value.to_port
  protocol    = each.value.protocol
  cidr_blocks = each.value.cidr_blocks
  description = each.value.description

  security_group_id = aws_security_group.main.id


}

