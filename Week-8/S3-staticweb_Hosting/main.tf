provider "aws" {
    region = "ap-south-1"
}

resource "aws_s3_bucket" "praveen_bucket" {
    bucket = "my-bucket-praveenraj"    
}

resource "aws_s3_bucket_public_access_block" "bucket_to_public" {
    bucket = aws_s3_bucket.praveen_bucket.id

    block_public_acls = false
    block_public_policy = false
    ignore_public_acls = false
    restrict_public_buckets = false
  
}

resource "aws_s3_bucket_ownership_controls" "bucket_ownership" {
    bucket = aws_s3_bucket.praveen_bucket.id
    rule {
      object_ownership = "BucketOwnerPreferred"
    }
}

resource "aws_s3_bucket_acl" "bucket_acl" {
    bucket = aws_s3_bucket.praveen_bucket.id
    acl = "public-read"
}

resource "aws_s3_object" "object" {
    acl          = "public-read"
    for_each = {
        "index.html" = {
            path          = "C:\\Users\\prave\\OneDrive\\Desktop\\Doc\\Terraform-1\\index.html"
            content_type  = "text/html"
        }
        "img.jpeg" = {
            path          = "C:\\Users\\prave\\OneDrive\\Desktop\\Doc\\Terraform-1\\Sanji.jpg"
            content_type  = "Sanji/jpg"
        }
    }

    bucket       = aws_s3_bucket.praveen_bucket.id
    key          = each.key
    source       = each.value.path
    content_type = each.value.content_type
}

resource "aws_s3_bucket_website_configuration" "website_config" {
    bucket = aws_s3_bucket.praveen_bucket.id

    index_document {
    suffix = "index.html"
    }
}

output "website_url" {
  value = aws_s3_bucket_website_configuration.website_config.website_endpoint
}
