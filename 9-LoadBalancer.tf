resource "aws_lb" "salsaSunday-LB01" {
  name               = "salsaSunday-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.salsaSunday-LB01-SG01.id]
  subnets = [
    aws_subnet.public-us-west-1a.id,
    #aws_subnet.public-us-west-1b.id,
    aws_subnet.public-us-west-1c.id
  ]
  enable_deletion_protection = false
  #Lots of death and suffering here, make sure it's false

  tags = {
    Name    = "salsaSundayLoadBalancer"
    Service = "salsaSunday"
    Owner   = "User"
    Project = "Web Service"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.salsaSunday-LB01.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.salsaSunday-TG01-80.arn
  }
}

# data "aws_acm_certificate" "cert" {
#   domain   = "balerica-aisecops.com"
#   statuses = ["ISSUED"]
#   most_recent = true
# }


# resource "aws_lb_listener" "https" {
#   load_balancer_arn = aws_lb.salsaSunday-LB01.arn
#   port              = 443
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"  # or whichever policy suits your requirements
#   certificate_arn   = data.aws_acm_certificate.cert.arn



#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.salsaSunday_tg.arn
#   }
# }

output "lb_dns_name" {
  value       = aws_lb.salsaSunday-LB01.dns_name
  description = "The DNS name of the salsaSunday Load Balancer."
}
