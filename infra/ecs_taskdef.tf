resource "aws_ecs_task_definition" "api" {
    family = var.app_name
    requires_compatibilities = ["FARGATE"]
    network_mode = "awsvpc"
    cpu = "256"
    memory = "512"

    execution_role_arn = aws_iam_role.exec.arn
    task_role_arn = aws_iam_role.task.arn

    container_definitions = jsonencode([
        {
            name = "api"
            image = var.image_uri
            essential = true

            portMappings = [
                { containerPort = 8080, hostPort = 8080, protocol = "tcp" }
            ]

            environment = [
                { name = "SECRET_NAME", value = var.secret_name }
            ]

            logConfiguration = {
                logDriver = "awslogs",
                options = {
                    awslogs-group = aws_cloudwatch_log_group.api.name,
                    awslogs-region = var.aws_region,
                    awslogs-stream-prefix = "ecs"
                }
            }
        }
    ])
}