resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "${var.prefix}-ecs-task-execution"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role" "frontend_task_role" {
  name               = "${var.prefix}-frontend-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role" "backend_task_role" {
  name               = "${var.prefix}-backend-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json

  lifecycle {
    create_before_destroy = true
  }
}
