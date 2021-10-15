resource "aws_internet_gateway" "prod" {
  vpc_id = aws_vpc.prod.id
}



resource "aws_eip" "prod_nat_gateway_eip" {
    depends_on = [aws_internet_gateway.prod]
}


resource "aws_nat_gateway" "prod_nat_gateway" {
  allocation_id = aws_eip.prod_nat_gateway_eip.id
  subnet_id     = aws_subnet.master_subnets.1.id

  tags = {
    Name = "gw NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.prod]
}








resource "aws_eip" "prod_controller_eip" {
  for_each = aws_instance.controllers
  instance = each.value.id
  vpc      = true
  depends_on = [aws_internet_gateway.prod]

}



resource "aws_eip" "prod_master_eip" {
  instance = aws_instance.master.id
  vpc      = true
  depends_on = [aws_internet_gateway.prod]

}
