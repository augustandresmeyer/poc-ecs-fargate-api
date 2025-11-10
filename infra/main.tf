resource "aws_ecr_repository" "api_repo" {
    name = var.app_name

    image_scanning_configuration {
        scan_on_push = true
    }

    encryption_configuration {
        encryption_type = "AES256"
    }

}

resource "aws_dynamodb_table" "items" {
    name = var.ddb_table
    billing_mode = "PAY_PER_REQUEST"

    hash_key = "tenant_id" #PK
    range_key = "ts" #SK

    attribute {
        name = "tenant_id"
        type = "S"
    }

    attribute {
        name = "ts"
        type = "N"
    }

    ttl {
        attribute_name = "ttl_epoch"
        enabled = false
    }

    point_in_time_recovery {
        enabled = false
    }

    server_side_encryption {
        enabled = true
    }

    tags = {
        app = var.app_name
        env = "poc"
    }
}