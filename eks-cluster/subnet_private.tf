resource "aws_subnet" "private_subnet" {
  count = "${length(var.az)}"
  cidr_block = "${element(var.private_subnet, count.index)}"
  vpc_id     = aws_vpc.vpc_prod.id
  availability_zone = "${element(var.az,count.index)}"
  tags = {
    Name = "subnet_${element(var.az,count.index)}_private"
  }
}

resource "aws_route_table" "private_rt" {
  count = "${length(var.az)}"
  vpc_id = aws_vpc.vpc_prod.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ng_private[count.index].id
  }

  tags = {
    Name = "ng_${element(var.az,count.index)}"
  }
}

resource "aws_route_table_association" "private_ass" {
  count = "${length(var.public_subnet)}"
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_rt[count.index].id
}