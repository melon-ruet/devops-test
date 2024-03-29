resource "aws_appautoscaling_target" "ecs_frontend_target" {
  max_capacity       = 4
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.cluster.name}/${aws_ecs_service.frontend_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
  role_arn           = aws_iam_role.autoscaling_role.arn
}

resource "aws_appautoscaling_policy" "ecs_frontend_target_cpu" {
  name               = "${var.prefix}-frontend-autoscaling-policy-cpu"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_frontend_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_frontend_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_frontend_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value = 80
  }
  depends_on = [aws_appautoscaling_target.ecs_frontend_target]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_appautoscaling_policy" "ecs_frontend_target_memory" {
  name               = "${var.prefix}-frontend-autoscaling-policy-memory"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_frontend_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_frontend_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_frontend_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    target_value = 80
  }
  depends_on = [aws_appautoscaling_target.ecs_frontend_target]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_appautoscaling_target" "ecs_backend_target" {
  max_capacity       = 4
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.cluster.name}/${aws_ecs_service.backend_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
  role_arn           = aws_iam_role.autoscaling_role.arn
}

resource "aws_appautoscaling_policy" "ecs_backend_target_cpu" {
  name               = "${var.prefix}-backend-autoscaling-policy-cpu"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_backend_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_backend_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_backend_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value = 80
  }
  depends_on = [aws_appautoscaling_target.ecs_backend_target]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_appautoscaling_policy" "ecs_backend_target_memory" {
  name               = "${var.prefix}-backend-autoscaling-policy-memory"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_backend_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_backend_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_backend_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    target_value = 80
  }
  depends_on = [aws_appautoscaling_target.ecs_backend_target]

  lifecycle {
    create_before_destroy = true
  }
}