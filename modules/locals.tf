locals {
  #subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  #azs          = ["us-east-2a", "us-east-2b", "us-east-2c"]
 # subnet_ids = [ "10.0.1.0/28", "10.0.2.0/28", "10.0.3.0/28"]
 instance_1_public_ip = aws_instance.apache-server-1.public_ip
 instance_2_public_ip = aws_instance.apache-server-1.public_ip
 instance_3_public_ip = aws_instance.apache-server-1.public_ip

 # public_ips = [aws_instance.apache-server1. , aws_instance.apache-server2. , aws_instance.apache-server3. ]
}


output "instance_public_ips" {
  value = "${local.instance_1_public_ip}\n${local.instance_2_public_ip}\n${local.instance_3_public_ip}"
}