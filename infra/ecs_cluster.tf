resource "aws_ecs_cluster" "poc_cluster" {
    name = var.app_name
}