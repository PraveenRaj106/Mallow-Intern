provider "aws" {
    region = "ap-south-1"
}

resource "aws_s3_bucket" "praveen_bucket" {
    bucket = "my-bucket-praveenraj"    
}

resource "aws_s3_object" "object" {
    for_each = {
        "index.html" = {
            path          = "C:\\Users\\prave\\OneDrive\\Desktop\\Doc\\Terraform-1\\index.html"
            content_type  = "text/html"
        }
        "img.jpeg" = {
            path          = "C:\\Users\\prave\\OneDrive\\Desktop\\Doc\\Terraform-1\\Sanji.jpg"
            content_type  = "img.jpeg"
        }
    }

    bucket       = aws_s3_bucket.praveen_bucket.id
    key          = each.key
    source       = each.value.path
    content_type = each.value.content_type
}

resource "aws_s3_bucket_policy" "bucket_policy" {
    bucket = aws_s3_bucket.praveen_bucket.id
    policy = jsonencode({
        "Version": "2008-10-17",
        "Id": "PolicyForCloudFrontPrivateContent",
        "Statement": [
            {
                "Sid": "AllowCloudFrontServicePrincipal",
                "Effect": "Allow",
                "Principal": {
                    "Service": "cloudfront.amazonaws.com"
                },
                "Action": "s3:GetObject",
                "Resource": "${aws_s3_bucket.praveen_bucket.arn}/*",
                "Condition": {
                    "StringEquals": {
                        "AWS:SourceArn": "${aws_cloudfront_distribution.cdn.arn}"
                    }
                }
            }
        ]
    })
}


locals {
  s3_origin_id = "myS3Origin"
}

resource "aws_cloudfront_distribution" "cdn" {
    origin {
        domain_name = aws_s3_bucket.praveen_bucket.bucket_regional_domain_name
        origin_access_control_id = aws_cloudfront_origin_access_control.default.id
        origin_id = local.s3_origin_id
    }
    enabled             = true
    is_ipv6_enabled     = true
    default_root_object = "index.html"
    
    
    default_cache_behavior {
        allowed_methods  = ["GET", "HEAD", "OPTIONS"]
        cached_methods   = ["GET", "HEAD"]
        target_origin_id = local.s3_origin_id

        forwarded_values {
            query_string = false

            cookies {
                forward = "none"
            }
        }

        viewer_protocol_policy = "allow-all"
        min_ttl                = 0
        default_ttl            = 3600
        max_ttl                = 86400
    }

    restrictions {
        geo_restriction {
            restriction_type = "none"
        }
    }
    viewer_certificate {
        cloudfront_default_certificate = true
    }
}

resource "aws_cloudfront_origin_access_control" "default" {
  name                              = "default-oac"
  description                       = "OAC for S3 origin"
  origin_access_control_origin_type  = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

output "cloudfront_dns" {
  value       = aws_cloudfront_distribution.cdn.domain_name
  description = "The DNS name of the CloudFront distribution"
}