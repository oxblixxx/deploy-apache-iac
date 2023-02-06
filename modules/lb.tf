#
# LOAD BALANCER
resource "aws_lb" "apache-vpc-lb" {
 # count = 3
  name               = "example-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.apache-vpc-sg.id]
  subnets =  [aws_subnet.apache-subnet1.id, aws_subnet.apache-subnet2.id, aws_subnet.apache-subnet3.id ]
}


# Load balancer listener
resource "aws_lb_listener" "apache-vpc-lb-listener" {
 # count = 3
  load_balancer_arn = aws_lb.apache-vpc-lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn =  aws_lb_target_group.apache-vpc-tg.arn
    type             = "forward"
  }
}

resource "aws_lb_target_group" "apache-vpc-tg" {
  name     = "apache-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.apache-vpc.id
}

resource "aws_lb_target_group_attachment" "lb-tg-attachment" {
#  count            = 3
  target_group_arn =  aws_lb_target_group.apache-vpc-tg.arn
  target_id        = aws_instance.apache-server-1.id
  port             = 80
}


resource "aws_lb_target_group_attachment" "lb-tg-attachment-2" {
#  count            = 3
  target_group_arn =  aws_lb_target_group.apache-vpc-tg.arn
  target_id        = aws_instance.apache-server-1.id
  port             = 80
}


resource "aws_lb_target_group_attachment" "lb-tg-attachment-3" {
#  count            = 3
  target_group_arn =  aws_lb_target_group.apache-vpc-tg.arn
  target_id        = aws_instance.apache-server-2.id
  port             = 80
}


## LOAD BALANCER LISTENER RULE
resource "aws_lb_listener_rule" "apache-vpc-lb-listener-rule" {
 # count = 3
  listener_arn = aws_lb_listener.apache-vpc-lb-listener.arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn =  aws_lb_target_group.apache-vpc-tg.arn
  }

  condition {
    path_pattern {
      values = ["/"]
    }
  }
}

