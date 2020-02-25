terraform {
  backend "s3" {}
}

data "terraform_remote_state" "vpc" {
  backend = "s3"

  defaults {
    "aws_vpc.vpc.id" = "vpc-dummy12345"
  }

  config {
    bucket = "${var.vpc_backend_bucket}"
    key    = "${var.vpc_backend_key}"
    region = "${var.vpc_backend_region}"
  }
}

provider "aws" {
  version    = "1.28.0"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
  token      = "${var.token}"
}

resource "aws_route53_zone" "thz_private" {
  name   = "private.${var.hosted_zone}"
  vpc_id = "${data.terraform_remote_state.vpc.aws_vpc.vpc.id}"

  tags {
    Name               = "${var.hosted_zone}"
    project_id         = "${var.project_id}"
    assets_expity_date = "${var.assets_expity_date}"
    build_user         = "${var.build_user}"
    build_user_email   = "${var.build_user_email}"
  }
}

resource "aws_route53_zone" "thz" {
  name = "${var.hosted_zone}"

  tags {
    Name               = "${var.hosted_zone}"
    project_id         = "${var.project_id}"
    assets_expity_date = "${var.assets_expity_date}"
    build_user         = "${var.build_user}"
    build_user_email   = "${var.build_user_email}"
  }
}
