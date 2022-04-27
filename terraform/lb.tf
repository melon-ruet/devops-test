resource "aws_lb" "lb" {
  name               = "${var.prefix}-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [for subnet in data.aws_subnets.default.ids : subnet]
}

resource "aws_lb_target_group" "lb_target_group" {
  name        = "${var.prefix}-lb-group"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.default.id
  target_type = "ip"
}

resource "aws_alb_listener" "app_http" {
  load_balancer_arn = aws_lb.lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.lb_target_group.arn
    type             = "forward"
  }
}