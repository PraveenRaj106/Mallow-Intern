terraform {
    backend "s3" {
        bucket = "praveenraj-terraform-tfstate1"
        region = "ap-south-1"
        key = "praveenraj/terraform.tfstate"
        dynamodb_table = "terraform-lock"
    }
}