provider "aws" {
   access_key = ""
   secret_key = ""
    region = "us-east-2"
}


resource "aws_instance" "apache-server-1" {
  ami               = var.ami
  instance_type     = "t2.micro"
  availability_zone = "us-east-2a"
  key_name          = var.keypair
  subnet_id         = aws_subnet.apache-subnet1.id
  security_groups   = [aws_security_group.apache-vpc-sg.id]
}

# Create a instance2

resource "aws_instance" "apache-server-2" {
  ami               = var.ami
  instance_type     = "t2.micro"
  availability_zone = "us-east-2b"
  key_name          = var.keypair
  subnet_id         = aws_subnet.apache-subnet2.id
  security_groups   = [aws_security_group.apache-vpc-sg.id]
}

# Create a instance3

resource "aws_instance" "apache-server-3" {
  ami               = var.ami
  instance_type     = "t2.micro"
  availability_zone = "us-east-2c"
  key_name          = var.keypair
  subnet_id         = aws_subnet.apache-subnet3.id
  security_groups   = [aws_security_group.apache-vpc-sg.id]
}



#provider "hashicorp/local-exec" {
#  version = "1.3.7"
#  command = "echo '${local.instance_1_public_ip}\n${local.instance_2_public_ip}\n${local.instance_3_public_ip}' > inventory "
#}

#data "aws_instance" "apache-server" {
 # filter {
 #   name   = "apache"
  #  values = [aws_vpc.apache-vpc.id]
#  }
#}


