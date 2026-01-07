resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_website_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls   = false
  block_public_policy = false
}


resource "aws_s3_object" "site" {
  for_each = fileset(var.dist_path, "**")

  bucket = aws_s3_bucket.this.id
  key    = each.value
  source = "${var.dist_path}/${each.value}"
  etag   = filemd5("${var.dist_path}/${each.value}")
}
