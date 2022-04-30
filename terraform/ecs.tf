resource "aws_ecs_cluster" "cluster" {
  name = "${var.prefix}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_ecs_task_definition" "ecs_frontend_task" {
  family                   = "${var.prefix}-frontend-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.task_definition_cpu
  memory                   = var.task_definition_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.backend_task_role.arn

  container_definitions = jsonencode([
    {
      name         = "${var.prefix}-frontend-container"
      image        = "${aws_ecr_repository.frontend.repository_url}:${local.frontend_dockerfile_dir_hash}"
      cpu          = var.container_cpu
      memory       = var.container_memory
      essential    = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-region        = data.aws_region.current.name
          awslogs-group         = aws_cloudwatch_log_group.frontend_cw.name
          awslogs-stream-prefix = "frontend-ecs"
        }
      }
    }
  ])

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_ecs_service" "frontend_service" {
  name            = "${var.prefix}-frontend-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.ecs_frontend_task.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  load_balancer {
    target_group_arn = aws_lb_target_group.frontend_target_group.arn
    container_name   = "${var.prefix}-frontend-container"
    container_port   = 80
  }

  network_configuration {
    subnets          = data.aws_subnets.default.ids
    assign_public_ip = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_ecs_task_definition" "ecs_backend_task" {
  family                   = "${var.prefix}-backend-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.task_definition_cpu
  memory                   = var.task_definition_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.backend_task_role.arn

  container_definitions = jsonencode([
    {
      name         = "${var.prefix}-backend-container"
      image        = "${aws_ecr_repository.backend.repository_url}:${local.backend_dockerfile_dir_hash}"
      cpu          = var.container_cpu
      memory       = var.container_memory
      essential    = true
      portMappings = [
        {
          containerPort = 5000
          hostPort      = 5000
        }
      ]
      environment = [
        {
          name  = "DB_ENDPOINT"
          value = aws_db_instance.default.address
        },
        {
          name  = "DB_NAME"
          value = aws_db_instance.default.db_name
        },
        {
          name  = "DB_USER"
          value = var.db_user
        },
        {
          name  = "DB_PASSWORD"
          value = var.db_password
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-region        = data.aws_region.current.name
          awslogs-group         = aws_cloudwatch_log_group.backend_cw.name
          awslogs-stream-prefix = "backend-ecs"
        }
      }
    }
  ])

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_ecs_service" "backend_service" {
  name            = "${var.prefix}-backend-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.ecs_backend_task.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  load_balancer {
    target_group_arn = aws_lb_target_group.backend_target_group.arn
    container_name   = "${var.prefix}-backend-container"
    container_port   = 5000
  }

  network_configuration {
    subnets          = data.aws_subnets.default.ids
    security_groups = [aws_security_group.backend_sg.id]
    assign_public_ip = true
  }

  lifecycle {
    create_before_destroy = true
  }
}