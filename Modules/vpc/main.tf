# Create Custom VPC
resource "aws_vpc" "lington-vpc" {
  cidr_block = var.vpc-cidr

  tags = {
    Name = "lington-vpc"
  }
}