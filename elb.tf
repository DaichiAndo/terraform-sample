# ==================================
# elb
# ==================================
resource "aws_lb" "alb" {
  name               = "${var.user}-${var.project}-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.alb_sg.id
  ]
  subnets = [
    aws_subnet.public_subnet_1a.id,
    aws_subnet.public_subnet_1c.id,
  ]
}

resource "aws_lb_listener" "alb_listener_http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}

resource "aws_lb_listener" "alb_listener_https" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.ap_northeast_1_cert_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}

resource "aws_lb_target_group" "alb_tg" {
  name        = "${var.user}-${var.project}-alb-tg"
  vpc_id      = aws_vpc.vpc.id
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  health_check {
    path = "/"
    port = 80
  }

  tags = {
    Name    = "${var.user}-${var.project}-alb-tg"
    Project = var.project
    User    = var.user
  }
}
