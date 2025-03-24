# terraform {
#   backend "s3" {
#     bucket         = "tf-bucket-pvt-app-cluster"
#     key            = "terraform/terraform.tfstate"
#     region         = "us-east-1"
#     dynamodb_table = "terraform-locks"
#     encrypt        = true
#   }
# }