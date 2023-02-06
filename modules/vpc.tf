#
#  VPC
resource "aws_vpc" "apache-vpc" {
  cidr_block = var.cidr-block


}


#
#  INTERNET GATEWAY
resource "aws_internet_gateway" "apache-vpc-igw" {
  vpc_id = aws_vpc.apache-vpc.id
}

resource "aws_subnet" "apache-subnet1" {
  vpc_id                  = aws_vpc.apache-vpc.id
  cidr_block              = "10.0.1.0/28"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-2a"
}

# Create Public Subnet-2

resource "aws_subnet" "apache-subnet2" {
  vpc_id                  = aws_vpc.apache-vpc.id
  cidr_block              = "10.0.2.0/28"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-2b"
}

# Create Public Subnet-3

resource "aws_subnet" "apache-subnet3" {
  vpc_id                  = aws_vpc.apache-vpc.id
  cidr_block              = "10.0.3.0/28"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-2c"
}


# Associate public subnet 1 with public route table

resource "aws_route_table_association" "apache-vpc-rtb-association-1" {
  subnet_id      = aws_subnet.apache-subnet1.id
  route_table_id = aws_route_table.apache-vpc-rtb.id
}

# Associate public subnet 2 with public route table

resource "aws_route_table_association" "apache-vpc-rtb-association-2" {
  subnet_id      = aws_subnet.apache-subnet2.id
  route_table_id = aws_route_table.apache-vpc-rtb.id
}

# Associate public subnet 3 with public route table

resource "aws_route_table_association" "apache-vpc-rtb-association-3" {
  subnet_id      = aws_subnet.apache-subnet3.id
  route_table_id = aws_route_table.apache-vpc-rtb.id
}



