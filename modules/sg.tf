#
# SECURITY GROUP
resource "aws_security_group" "apache-vpc-sg" {
  description = "Allow HTTPS, HTTP and SSH"
  name        = "apache-server-sg"
  vpc_id      = aws_vpc.apache-vpc.id
  
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH"
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
  }

  ingress {
    from_port       = 443
    description     = "HTTPS"
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [aws_security_group.apache-lb-sg.id]
  }

  ingress {
    from_port       = 80
    description     = "HTTP"
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [aws_security_group.apache-lb-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "apache-lb-sg" {
  name        = "apache-lb-sg"
  description = "Security group for the load balancer"
  vpc_id      = aws_vpc.apache-vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#
# ROUTE TABLE
resource "aws_route_table" "apache-vpc-rtb" {
  vpc_id = aws_vpc.apache-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.apache-vpc-igw.id
  }
}

# Route table association
resource "aws_route_table_association" "apache-sever-rtb-associate-1" {
  route_table_id = aws_route_table.apache-vpc-rtb.id
  subnet_id = aws_subnet.apache-subnet1.id
}


resource "aws_route_table_association" "apache-sever-rtb-associate-2" {
  route_table_id = aws_route_table.apache-vpc-rtb.id
  subnet_id = aws_subnet.apache-subnet2.id
}

resource "aws_route_table_association" "apache-sever-rtb-associate-3" {
  route_table_id = aws_route_table.apache-vpc-rtb.id
  subnet_id = aws_subnet.apache-subnet3.id
}