resource "aws_subnet" "public_subnet" {
  count = "${length(var.az)}"
  cidr_block = "${element(var.public_subnet, count.index)}"
  vpc_id     = aws_vpc.vpc_prod.id
  availability_zone = "${element(var.az,count.index)}"
  enable_resource_name_dns_a_record_on_launch = "true"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "subnet_${element(var.az,count.index)}_public"
  }
}

resource "aws_route_table" "public_rt" {
  count = "${length(var.az)}"
  vpc_id = aws_vpc.vpc_prod.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "rt_${element(var.az,count.index)}_public"
  }
}

resource "aws_route_table_association" "a" {
  count = "${length(var.public_subnet)}"
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_rt[count.index].id
}