terraform {
  backend "s3" {}
}

# TODO: modify all the rules which have all protocol open to -1 refer "rdsself"
# Else it gives issue in updation of rule
provider "aws" {
  version    = "1.28.0"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
  token      = "${var.token}"
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

#VPN Security Group

resource "aws_security_group" "vpn_sg" {
  name        = "VPN"
  vpc_id      = "${data.terraform_remote_state.vpc.aws_vpc.vpc.id}"
  description = "vpn sg"

  tags {
    Name = "${var.env_name}-vpn"
  }
}

resource "aws_security_group_rule" "vpntcp" {
  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  description = "Open VPN TCP"

  security_group_id = "${aws_security_group.vpn_sg.id}"
}

resource "aws_security_group_rule" "vpnssh" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  description = "Open VPN SSH"

  security_group_id = "${aws_security_group.vpn_sg.id}"
}

resource "aws_security_group_rule" "vpnudp" {
  type        = "ingress"
  from_port   = 1194
  to_port     = 1194
  protocol    = "udp"
  cidr_blocks = ["0.0.0.0/0"]
  description = "Open VPN UDP"

  security_group_id = "${aws_security_group.vpn_sg.id}"
}

resource "aws_security_group_rule" "vpnhttp" {
  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  description = "HTTP"

  security_group_id = "${aws_security_group.vpn_sg.id}"
}

resource "aws_security_group_rule" "vpnegress" {
  type        = "egress"
  from_port   = 0
  to_port     = 65535
  protocol    = "all"
  cidr_blocks = ["0.0.0.0/0"]
  description = "All Egress ports"

  security_group_id = "${aws_security_group.vpn_sg.id}"
}

#APP
resource "aws_security_group" "app_sg" {
  name        = "APP"
  vpc_id      = "${data.terraform_remote_state.vpc.aws_vpc.vpc.id}"
  description = "app sg"

  tags {
    Name = "${var.env_name}-app"
  }
}

resource "aws_security_group_rule" "openvpcudp" {
  type                     = "ingress"
  from_port                = 445
  to_port                  = 445
  protocol                 = "udp"
  source_security_group_id = "${aws_security_group.vpn_sg.id}"
  description              = "File Explorer Access"

  security_group_id = "${aws_security_group.app_sg.id}"
}

resource "aws_security_group_rule" "apphttp" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.vpn_sg.id}"
  description              = "WildFly Access"

  security_group_id = "${aws_security_group.app_sg.id}"
}

resource "aws_security_group_rule" "applb" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.vpn_sg.id}"
  description              = "Load Balancer"

  security_group_id = "${aws_security_group.app_sg.id}"
}

resource "aws_security_group_rule" "appsmptcp" {
  type                     = "ingress"
  from_port                = 135
  to_port                  = 139
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.vpn_sg.id}"
  description              = "SMP File Explorer"

  security_group_id = "${aws_security_group.app_sg.id}"
}

resource "aws_security_group_rule" "appsmpudp" {
  type                     = "ingress"
  from_port                = 135
  to_port                  = 139
  protocol                 = "udp"
  source_security_group_id = "${aws_security_group.vpn_sg.id}"
  description              = "SMP File Explorer"

  security_group_id = "${aws_security_group.app_sg.id}"
}

resource "aws_security_group_rule" "appwildflyconsole" {
  type                     = "ingress"
  from_port                = 9990
  to_port                  = 9990
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.vpn_sg.id}"
  description              = "WildFly Admin Console"

  security_group_id = "${aws_security_group.app_sg.id}"
}

resource "aws_security_group_rule" "apprdp" {
  type                     = "ingress"
  from_port                = 3389
  to_port                  = 3389
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.vpn_sg.id}"
  description              = "RDP Access"

  security_group_id = "${aws_security_group.app_sg.id}"
}

resource "aws_security_group_rule" "appself" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "all"
  source_security_group_id = "${aws_security_group.app_sg.id}"
  description              = "Self App"

  security_group_id = "${aws_security_group.app_sg.id}"
}

resource "aws_security_group_rule" "appegress" {
  type        = "egress"
  from_port   = 0
  to_port     = 65535
  protocol    = "all"
  cidr_blocks = ["0.0.0.0/0"]
  description = "All Egress ports"

  security_group_id = "${aws_security_group.app_sg.id}"
}

# RDS BRIDGE INSTANCE
resource "aws_security_group" "rds_migration_sg" {
  name        = "RDS MIGRATION"
  vpc_id      = "${data.terraform_remote_state.vpc.aws_vpc.vpc.id}"
  description = "rds migration sg"

  tags {
    Name = "${var.env_name}-rds-migration"
  }
}

resource "aws_security_group_rule" "open22" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  cidr_blocks              = ["0.0.0.0/0"]
  description              = "OPEN 22"

  security_group_id = "${aws_security_group.rds_migration_sg.id}"
}

resource "aws_security_group_rule" "rds_migrationegress" {
  type        = "egress"
  from_port   = 0
  to_port     = 65535
  protocol    = "all"
  cidr_blocks = ["0.0.0.0/0"]
  description = "All Egress ports"

  security_group_id = "${aws_security_group.rds_migration_sg.id}"
}

# DB
resource "aws_security_group" "db_sg" {
  name        = "DB"
  vpc_id      = "${data.terraform_remote_state.vpc.aws_vpc.vpc.id}"
  description = "db sg"

  tags {
    Name = "${var.env_name}-db"
  }
}

resource "aws_security_group_rule" "rdsport" {
  type                     = "ingress"
  from_port                = 1521
  to_port                  = 1521
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.vpn_sg.id}"
  description              = "Open VPN UDP"

  security_group_id = "${aws_security_group.db_sg.id}"
}

resource "aws_security_group_rule" "rdsself" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  self                     = true
  protocol                 = -1
  description              = "All Ingress ports for Self"
  security_group_id = "${aws_security_group.db_sg.id}"
}

resource "aws_security_group_rule" "rdsbridge" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "all"
  source_security_group_id = "${aws_security_group.rds_migration_sg.id}"
  description              = "All Ingress from RDS BRIDGE INSTANCE"

  security_group_id = "${aws_security_group.db_sg.id}"
}

resource "aws_security_group_rule" "dbegress" {
  type        = "egress"
  from_port   = 0
  to_port     = 65535
  protocol    = "all"
  cidr_blocks = ["0.0.0.0/0"]
  description = "All Egress ports"

  security_group_id = "${aws_security_group.db_sg.id}"
}

# Jenkins
resource "aws_security_group" "jenkins_sg" {
  name        = "JENKINS"
  vpc_id      = "${data.terraform_remote_state.vpc.aws_vpc.vpc.id}"
  description = "jenkins sg"

  tags {
    Name = "${var.env_name}-jenkins"
  }
}

resource "aws_security_group_rule" "jenkinsport" {
  type        = "ingress"
  from_port   = 8080
  to_port     = 8080
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  description = "Jenkins Port"

  security_group_id = "${aws_security_group.jenkins_sg.id}"
}

resource "aws_security_group_rule" "jnlpport" {
  type        = "ingress"
  from_port   = 1521
  to_port     = 1521
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  description = "JNLP Port"

  security_group_id = "${aws_security_group.jenkins_sg.id}"
}

resource "aws_security_group_rule" "jenkinsegress" {
  type        = "egress"
  from_port   = 0
  to_port     = 65535
  protocol    = "all"
  cidr_blocks = ["0.0.0.0/0"]
  description = "All Egress ports"

  security_group_id = "${aws_security_group.jenkins_sg.id}"
}
