resource "aws_ecs_cluster" "cluster" {
  name = "${var.prefix}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

#resource "aws_ecs_task_definition" "frontend_task" {
#  family                   = "${var.prefix}-frontend-task"
#  requires_compatibilities = ["FARGATE"]
#  network_mode             = "awsvpc"
#  cpu                      = var.task_definition_cpu
#  memory                   = var.task_definition_memory
#  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
#  task_role_arn            = aws_iam_role.frontend_task_role.arn
#
#  ephemeral_storage {
#    size_in_gib = 200
#  }
#
#  container_definitions = jsonencode([
#    {
#      name      = "${var.prefix}-frontend-container"
#      image     = "${aws_ecr_repository.frontend.repository_url}:${local.frontend_dockerfile_dir_hash}"
#      cpu       = var.container_cpu
#      memory    = var.container_memory
#      essential = true
#      portMappings = [
#        {
#          containerPort = 80
#          hostPort      = 80
#        }
#      ]
#    }
#  ])
#}

resource "aws_ecs_task_definition" "ecs_task" {
  family                   = "${var.prefix}-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.task_definition_cpu
  memory                   = var.task_definition_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.backend_task_role.arn

  ephemeral_storage {
    size_in_gib = 200
  }

  container_definitions = jsonencode([
    {
      name      = "${var.prefix}-frontend-container"
      image     = "${aws_ecr_repository.frontend.repository_url}:${local.frontend_dockerfile_dir_hash}"
      cpu       = var.container_cpu
      memory    = var.container_memory
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    },
    {
      name      = "${var.prefix}-backend-container"
      image     = "${aws_ecr_repository.backend.repository_url}:${local.backend_dockerfile_dir_hash}"
      cpu       = var.container_cpu
      memory    = var.container_memory
      essential = true
    }
  ])
}

resource "aws_ecs_service" "frontend_service" {
  name            = "${var.prefix}-frontend-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.ecs_task.arn
  desired_count   = 1
#  iam_role        = aws_iam_role.foo.arn

  load_balancer {
    target_group_arn = aws_lb_target_group.lb_target_group.arn
    container_name   = "${var.prefix}-frontend-container"
    container_port   = 80
  }
}