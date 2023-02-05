provider "aws" {
  region     = "us-east-1"
  access_key = "<access_key>"
  secret_key = "<secret_key>"

}

# Create VPC

resource "aws_vpc" "apache-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "apache-vpc"
  }
}

# Create Internet Gateway

resource "aws_internet_gateway" "apache-vpc-igw" {
  vpc_id = aws_vpc.terraform-vpc.id
  tags = {
    Name = "apache-vpc-igw"
  }
}


# Create a instance1

resource "aws_instance" "apache-server-1" {
  ami               = "ami-0574da719dca65348"
  instance_type     = "t2.micro"
  availability_zone = "us-east-2a"
  key_name          = "barraghanvirus"
  subnet_id         = aws_subnet.apache-subnet1.id
  security_groups   = [aws_security_group.apache-subent1.id]
}

# Create a instance2

resource "aws_instance" "apache-server-2" {
  ami               = "ami-0574da719dca65348"
  instance_type     = "t2.micro"
  availability_zone = "us-east-2b"
  key_name          = "barraghanvirus"
  subnet_id         = aws_subnet.apache-subnet2.id
  security_groups   = [aws_security_group.apache-vpc-sg.id]
}

# Create a instance3

resource "aws_instance" "apache-server-3" {
  ami               = "ami-0574da719dca65348"
  instance_type     = "t2.micro"
  availability_zone = "us-east-2c"
  key_name          = "barraghanvirus"
  subnet_id         = aws_subnet.apache-subnet3.id
  security_groups   = [aws_security_group.apache-vpc-sg.id]
}


# Create public Route Table

resource "aws_route_table" "apache-vpc-rtb" {
  vpc_id = aws_vpc.apache-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.apache-vpc-igw.id
  }
}

# Create Public Subnet-1

resource "aws_subnet" "apache-subnet1" {
  vpc_id                  = aws_vpc.apache-vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-2a"
}

# Create Public Subnet-2

resource "aws_subnet" "apache-subnet2" {
  vpc_id                  = aws_vpc.apache-vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-2b"
}

# Create Public Subnet-3

resource "aws_subnet" "apache-subnet3" {
  vpc_id                  = aws_vpc.apache-vpc.id
  cidr_block              = "10.0.3.0/24"
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



# Create a security group for the load balancer

resource "aws_security_group" "apache-vpc-lb-sg" {
  name        = "lb-sg"
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

# Create Security Group to allow port 22, 80 and 443

resource "aws_security_group" "apache-vpc-sg" {
  name        = "allow_ssh_http_https"
  description = "Allow SSH, HTTP and HTTPS"
  vpc_id      = aws_vpc.apache-vpc.id

  ingress {
    description     = "HTTP"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [aws_security_group.apache-vpc-lb-sg.id]
  }

  ingress {
    description     = "HTTPS"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [aws_security_group.apache-vpc-lb-sg.id]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



# Create an Application Load Balancer

resource "aws_lb" "apache-vpc-lb" {
  name            = "lb"
  internal        = false
  security_groups = [aws_security_group.apache-vpc-lb-sg.id]
  subnets         = [aws_subnet.apache-subnet1.id, aws_subnet.apache-subnet2.id, aws_subnet.apache-subnet3.id]

  enable_deletion_protection = false
  depends_on                 = [aws_instance.apache-server-1, aws_instance.apache-server-2, aws_instance.apache-server-3]
}

# Create the target group

resource "aws_lb_target_group" "apache-lb-tg" {
  name     = "tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.apache-vpc.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# Create the listener

resource "aws_lb_listener" "lb-listener" {
  load_balancer_arn = aws_lb.apache-vpc-lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.apache-lb-tg.arn
  }
}

# Create the listener rule

resource "aws_lb_listener_rule" "lb-rule" {
  listener_arn = aws_lb_listener.lb-listener.arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.apache-lb-tg.arn
  }

  condition {
    path_pattern {
      values = ["/"]
    }
  }
}


# Attach the target group to the load balancer

resource "aws_lb_target_group_attachment" "lb-tg-attach-1" {
  target_group_arn = aws_lb_target_group.apache-lb-tg.arn
  target_id        = aws_instance.apache-server-1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "lb-tg-attach-2" {
  target_group_arn = aws_lb_target_group.apache-lb-tg.arn
  target_id        = aws_instance.apache-server-2.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "lb-tg-attach-3" {
  target_group_arn = aws_lb_target_group.apache-lb-tg.arn
  target_id        = aws_instance.apache-server-3.id
  port             = 80
}

# Export IP addresses of the 3 instances to host-inventory file

resource "local_file" "ip_address" {
  filename = "/home/abdul-barri/terraform/altschool-exercises/host-inventory"
  content  = <<EOT
  ${aws_instance.apache-server-1.public_ip}
  ${aws_instance.apache-server-2.public_ip}
  ${aws_instance.apache-server-3.public_ip}
    EOT
}

# Route 53 and sub-domain name setup

resource "aws_route53_zone" "oxlava" {
  name = "oxlava.live"
}

resource "aws_route53_zone" "sub-domain-name" {
  name = "sudomain.oxlava.live"
}

resource "aws_route53_record" "lava-record" {
  zone_id = aws_route53_zone.oxlava.zone_id
  name    = "subdomain.oxlava.live"
  type    = "A"

  alias {
    name                   = aws_lb.apache-vpc-lb.dns_name
    zone_id                = aws_lb.apache-vpc-lb.zone_id
    evaluate_target_health = true
  }
  depends_on = [
    aws_lb.apache-vpc-lb
  ]
}