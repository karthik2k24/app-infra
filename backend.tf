terraform {
  backend "s3" {
    bucket         = "tf-bucket-pvt-app-cluster"
    key            = "terraform/state.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

terraform {
  backend "s3" {
    bucket         = "tf-bucket-pvt-app-cluster"
    key            = "terraform.tfstate"  # Default name
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}