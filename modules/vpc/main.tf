# Create the VPC
resource "aws_vpc" "main" {
  cidr_block = var.cidr_block

  tags = {
    Name = var.tag_name
  }
}