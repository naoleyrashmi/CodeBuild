terraform {
  backend "s3" {}
}

provider "aws" {
  version    = "1.28.0"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
  token      = "${var.token}"
}

data "terraform_remote_state" "hosted_zone" {
  backend = "s3"

  defaults {
    "aws_route53_zone.thz.zone_id"         = "dummy12345"
    "aws_route53_zone.thz_private.zone_id" = "dummy12345"
  }

  config {
    bucket = "${var.hosted_zone_backend_bucket}"
    key    = "${var.hosted_zone_backend_key}"
    region = "${var.hosted_zone_backend_region}"
  }
}

resource "aws_route53_record" "record_set" {
  zone_id = "${var.hosted_zone_type == "public" ? data.terraform_remote_state.hosted_zone.aws_route53_zone.thz.zone_id : data.terraform_remote_state.hosted_zone.aws_route53_zone.thz_private.zone_id}"
  name    = "${var.record_set_name}"
  type    = "CNAME"
  ttl     = "${var.record_set_ttl}"
  records = ["${var.record_set_record}"]
}
