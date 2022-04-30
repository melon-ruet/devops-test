# Frontend load balancer
resource "aws_lb" "frontend_lb" {
  name               = "${var.prefix}-frontend-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [for subnet in data.aws_subnets.default.ids : subnet]
}

resource "aws_lb_target_group" "frontend_target_group" {
  name        = "${var.prefix}-lb-frontend-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.default.id
  target_type = "ip"
}

resource "aws_alb_listener" "frontend_listener" {
  load_balancer_arn = aws_lb.frontend_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.frontend_target_group.arn
    type             = "forward"
  }
}


# Backend load balancer
resource "aws_lb" "backend_lb" {
  name               = "${var.prefix}-backend-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [for subnet in data.aws_subnets.default.ids : subnet]
}

resource "aws_lb_target_group" "backend_target_group" {
  name        = "${var.prefix}-lb-backend-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.default.id
  target_type = "ip"
}

resource "aws_alb_listener" "backend_listener" {
  load_balancer_arn = aws_lb.backend_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.backend_target_group.arn
    type             = "forward"
  }
}