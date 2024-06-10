# Create the Public Subnets
resource "aws_subnet" "public" {
  vpc_id            = var.subnet_vpc_id
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.subnet_availability_zone  
  map_public_ip_on_launch = true
  tags = {
    Name = var.tag_name
  }
}