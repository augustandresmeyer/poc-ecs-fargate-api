variable "aws_region" { default = "us-east-1" }
variable "app_name" { default = "poc1-api" }
variable "ddb_table" { 
    type = string
    default = "Poc1Items"
}
variable "secret_name" { default = "/poc1/app" }