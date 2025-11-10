output "ecr_repository_url" {
    value = aws_ecr_repository.api_repo.repository_url
}

output "ddb_table_name" {
    value = aws_dynamodb_table.items.name
}

output "ddb_table_arn" {
    value = aws_dynamodb_table.items.arn
}
