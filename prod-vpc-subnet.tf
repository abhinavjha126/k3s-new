

resource "aws_vpc" "prod" {
  provider = aws
  cidr_block = var.vpc_cidr
  tags = {
    Name = "vpc-prod"
   }
  enable_dns_support = true
  enable_dns_hostnames = true
}


resource "aws_subnet" "master_subnets" {
  for_each          = var.master_subnets
  cidr_block        = each.value.cidr
  availability_zone = lookup(each.value, "az", null)
  vpc_id            = aws_vpc.prod.id
  tags = {
    Name = each.value.name
    Type = "master"
   }
}

resource "aws_subnet" "worker_subnets" {
  for_each          = var.worker_subnets
  cidr_block        = each.value.cidr
  availability_zone = lookup(each.value, "az", null)
  vpc_id            = aws_vpc.prod.id
  tags = {
    Name = each.value.name
    Type = "worker"
   }
}
