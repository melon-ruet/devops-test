resource "aws_cloudwatch_log_group" "frontend_cw" {
  name              = "/ecs/${var.prefix}-frontend-log"
  retention_in_days = 90
}

resource "aws_cloudwatch_log_group" "backend_cw" {
  name              = "/ecs/${var.prefix}-backend-log"
  retention_in_days = 90
}