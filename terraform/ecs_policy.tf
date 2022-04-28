data "aws_iam_policy_document" "ecs_task_assume_role" {
  version = "2012-10-17"

  statement {
    sid    = "EcsTaskAssumeRole"
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      identifiers = [
        "ecs-tasks.amazonaws.com"
      ]
      type = "Service"
    }
  }
}

data "aws_iam_policy_document" "ecs_autoscaling_role" {
  version = "2012-10-17"

  statement {
    sid    = "EcsAutoScalingRole"
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      identifiers = [
        "application-autoscaling.amazonaws.com"
      ]
      type = "Service"
    }
  }
}
