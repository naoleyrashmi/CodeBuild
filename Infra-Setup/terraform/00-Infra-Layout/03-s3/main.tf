terraform {
  backend "s3" {}
}

data "aws_caller_identity" "current" {}

provider "aws" {
  version    = "1.28.0"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
  token      = "${var.token}"
}

resource "random_id" "s3_postfix" {
  byte_length = 5
}
