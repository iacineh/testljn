resource "aws_eip" "nat_eip" {
  count = "${length(var.public_subnet)}"
  vpc      = true
  tags = {
    Name = "ng_${element(var.az,count.index)}"
  }
}

resource "aws_nat_gateway" "ng_private" {
  count = "${length(var.public_subnet)}"
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = aws_subnet.public_subnet[count.index].id

  tags = {
    Name = "ng_${element(var.az,count.index)}_public"
  }
}