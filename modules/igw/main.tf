# Create the Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = var.igw_vpc_id

  tags = {
    Name = var.igw_tag_name
  }
}