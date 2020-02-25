provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region     = "${var.aws_region}"
    token      = "${var.token}"
}

resource "aws_db_snapshot" "db_snapshot" {
    db_instance_identifier = "${var.db_instance_identifier}"
    db_snapshot_identifier = "${var.db_snapshot_identifier}"
}