output "instance_ips-1" {
  value = aws_instance.apache-server-1.public_ip
}


output "instance_ips-2" {
  value = aws_instance.apache-server-2.public_ip
}


output "instance_ips-3" {
  value = aws_instance.apache-server-3.public_ip
}

output "nnames-servers" {
    value = try(aws_route53_zone.oxlava.tags_all, {})
}