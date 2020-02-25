provider "aws" {
  version    = "1.28.0"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
  token     = "${var.token}"
}

resource "aws_key_pair" "cpm_key" {
  key_name   = "${var.aws_key_name}"
  public_key = "${file(var.aws_public_key_path)}"
}
