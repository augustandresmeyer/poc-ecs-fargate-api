data "aws_iam_policy_document" "exec_trust" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "exec_policy" {
  statement {
    sid       = "EcrPull"
    actions   = ["ecr:GetAuthorizationToken", "ecr:BatchCheckLayerAvailability", "ecr:GetDownloadUrlForLayer", "ecr:BatchGetImage"]
    resources = ["*"]
  }
  statement {
    sid       = "LogsWrite"
    actions   = ["logs:CreateLogStream", "logs:PutLogEvents"]
    resources = ["${aws_cloudwatch_log_group.api.arn}:*"]
  }
}

resource "aws_iam_role" "exec" {
  name               = "${var.app_name}-exec"
  assume_role_policy = data.aws_iam_policy_document.exec_trust.json
}

resource "aws_iam_policy" "exec" {
  name   = "${var.app_name}-exec"
  policy = data.aws_iam_policy_document.exec_policy.json
}

resource "aws_iam_role_policy_attachment" "exec_attach" {
  role       = aws_iam_role.exec.name
  policy_arn = aws_iam_policy.exec.arn
}
