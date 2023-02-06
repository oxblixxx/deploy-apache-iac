variable "cidr-block" {
 #   type = string
    default = "10.0.0.0/16"
}

variable "subnet_ids" {
  type = list(string)
}

variable "ami" {
  default = "ami-0ab0629dba5ae551d"
}

variable "keypair" {
  default = "apache-ec2-server"
}