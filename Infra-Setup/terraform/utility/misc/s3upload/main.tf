provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region     = "${var.aws_region}"
    token      = "${var.token}"
}

resource "aws_s3_bucket_object" "migration_key" {
  bucket = "${var.bucket}"
  key    = "${var.key}"
  source = "${var.source}"
  content_type = "text"
}