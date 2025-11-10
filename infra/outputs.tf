output "ecr_repository_url" {
  value = aws_ecr_repository.api_repo.repository_url
}

output "ddb_table_name" {
  value = aws_dynamodb_table.items.name
}

output "ddb_table_arn" {
  value = aws_dynamodb_table.items.arn
}

output "secret_arn" {
  value = aws_secretsmanager_secret.app.arn
}

output "secret_name" {
  value = aws_secretsmanager_secret.app.name
}

output "exec_role_arn" {
  value = aws_iam_role.exec.arn

}
output "task_role_arn" {
  value = aws_iam_role.task.arn
}
output "log_group_name" {
  value = aws_cloudwatch_log_group.api.name
}
