terraform {
  backend "s3" {}
}

provider "aws" {
  version    = "1.28.0"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
  token     = "${var.token}"
}

resource "aws_vpc" "vpc" {
  cidr_block                       = "${var.vpc_cidr}"
  assign_generated_ipv6_cidr_block = false
  enable_dns_hostnames             = true

  tags {
    Name               = "${var.env_name}"
    project_id         = "${var.project_id}"
    assets_expity_date = "${var.assets_expity_date}"
    build_user         = "${var.build_user}"
    build_user_email   = "${var.build_user_email}"
  }
}

resource "aws_internet_gateway" "igway" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name               = "${var.env_name}-igw"
    project_id         = "${var.project_id}"
    assets_expity_date = "${var.assets_expity_date}"
    build_user         = "${var.build_user}"
    build_user_email   = "${var.build_user_email}"
  }
}

resource "aws_vpn_gateway" "vpn_gw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name               = "${var.env_name}-vgw"
    project_id         = "${var.project_id}"
    assets_expity_date = "${var.assets_expity_date}"
    build_user         = "${var.build_user}"
    build_user_email   = "${var.build_user_email}"
  }
}

resource "aws_subnet" "public_subnet_az_1a" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.public_subnet_cidr_az_a}"
  availability_zone       = "${var.az_zone_1a}"
  map_public_ip_on_launch = true

  tags {
    Name               = "${var.env_name}-public-${var.az_zone_1a}"
    project_id         = "${var.project_id}"
    assets_expity_date = "${var.assets_expity_date}"
    build_user         = "${var.build_user}"
    build_user_email   = "${var.build_user_email}"
  }
}

resource "aws_subnet" "public_subnet_az_1b" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.public_subnet_cidr_az_b}"
  availability_zone       = "${var.az_zone_1b}"
  map_public_ip_on_launch = true

  tags {
    Name               = "${var.env_name}-public-${var.az_zone_1b}"
    project_id         = "${var.project_id}"
    assets_expity_date = "${var.assets_expity_date}"
    build_user         = "${var.build_user}"
    build_user_email   = "${var.build_user_email}"
  }
}

resource "aws_subnet" "private_subnet_az_1a" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${var.private_subnet_cidr_az_a}"
  availability_zone = "${var.az_zone_1a}"

  tags {
    Name               = "${var.env_name}-private-${var.az_zone_1a}"
    project_id         = "${var.project_id}"
    assets_expity_date = "${var.assets_expity_date}"
    build_user         = "${var.build_user}"
    build_user_email   = "${var.build_user_email}"
  }
}

resource "aws_subnet" "private_subnet_az_1b" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${var.private_subnet_cidr_az_b}"
  availability_zone = "${var.az_zone_1b}"

  tags {
    Name               = "${var.env_name}-private-${var.az_zone_1b}"
    project_id         = "${var.project_id}"
    assets_expity_date = "${var.assets_expity_date}"
    build_user         = "${var.build_user}"
    build_user_email   = "${var.build_user_email}"
  }
}

resource "aws_eip" "for_nat_a" {
  tags {
    Name               = "${var.env_name}-eip-nat-a"
    project_id         = "${var.project_id}"
    assets_expity_date = "${var.assets_expity_date}"
    build_user         = "${var.build_user}"
    build_user_email   = "${var.build_user_email}"
  }
}

resource "aws_eip" "for_nat_b" {
  tags {
    Name               = "${var.env_name}-eip-nat-b"
    project_id         = "${var.project_id}"
    assets_expity_date = "${var.assets_expity_date}"
    build_user         = "${var.build_user}"
    build_user_email   = "${var.build_user_email}"
  }
}

resource "aws_nat_gateway" "nat_a" {
  allocation_id = "${aws_eip.for_nat_a.id}"
  subnet_id     = "${aws_subnet.public_subnet_az_1a.id}"
  depends_on    = ["aws_internet_gateway.igway"]

  tags {
    Name               = "${var.env_name}-nat-a"
    project_id         = "${var.project_id}"
    assets_expity_date = "${var.assets_expity_date}"
    build_user         = "${var.build_user}"
    build_user_email   = "${var.build_user_email}"
  }
}

resource "aws_nat_gateway" "nat_b" {
  allocation_id = "${aws_eip.for_nat_b.id}"
  subnet_id     = "${aws_subnet.public_subnet_az_1b.id}"
  depends_on    = ["aws_internet_gateway.igway"]

  tags {
    Name               = "${var.env_name}-nat-b"
    project_id         = "${var.project_id}"
    assets_expity_date = "${var.assets_expity_date}"
    build_user         = "${var.build_user}"
    build_user_email   = "${var.build_user_email}"
  }
}

#Route Tables

#Public

resource "aws_route_table" "route_public_subnet_1a" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igway.id}"
  }

  tags {
    Name               = "${var.env_name}-public-1a"
    project_id         = "${var.project_id}"
    assets_expity_date = "${var.assets_expity_date}"
    build_user         = "${var.build_user}"
    build_user_email   = "${var.build_user_email}"
  }
}

resource "aws_route_table_association" "rta_public_1a" {
  subnet_id      = "${aws_subnet.public_subnet_az_1a.id}"
  route_table_id = "${aws_route_table.route_public_subnet_1a.id}"
}

resource "aws_route_table" "route_public_subnet_1b" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igway.id}"
  }

  tags {
    Name               = "${var.env_name}-public-1b"
    project_id         = "${var.project_id}"
    assets_expity_date = "${var.assets_expity_date}"
    build_user         = "${var.build_user}"
    build_user_email   = "${var.build_user_email}"
  }
}

resource "aws_route_table_association" "rta_public_1b" {
  subnet_id      = "${aws_subnet.public_subnet_az_1b.id}"
  route_table_id = "${aws_route_table.route_public_subnet_1b.id}"
}

#Private

resource "aws_route_table" "route_private_subnet_1a" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat_a.id}"
  }

  tags {
    Name               = "${var.env_name}-private-1a"
    project_id         = "${var.project_id}"
    assets_expity_date = "${var.assets_expity_date}"
    build_user         = "${var.build_user}"
    build_user_email   = "${var.build_user_email}"
  }
}

resource "aws_route_table_association" "rta_private_1a" {
  subnet_id      = "${aws_subnet.private_subnet_az_1a.id}"
  route_table_id = "${aws_route_table.route_private_subnet_1a.id}"
}

resource "aws_route_table" "route_private_subnet_1b" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat_b.id}"
  }

  tags {
    Name               = "${var.env_name}-private-1b"
    project_id         = "${var.project_id}"
    assets_expity_date = "${var.assets_expity_date}"
    build_user         = "${var.build_user}"
    build_user_email   = "${var.build_user_email}"
  }
}

resource "aws_route_table_association" "rta_private_1b" {
  subnet_id      = "${aws_subnet.private_subnet_az_1b.id}"
  route_table_id = "${aws_route_table.route_private_subnet_1b.id}"
}

resource "aws_vpn_gateway_route_propagation" "rp_1b" {
  vpn_gateway_id = "${aws_vpn_gateway.vpn_gw.id}"
  route_table_id = "${aws_route_table.route_private_subnet_1b.id}"
}

resource "aws_vpn_gateway_route_propagation" "rp_1a" {
  vpn_gateway_id = "${aws_vpn_gateway.vpn_gw.id}"
  route_table_id = "${aws_route_table.route_private_subnet_1a.id}"
}

# Declare the data source
data "aws_vpc_endpoint_service" "s3" {
  service = "s3"
}
# Create a VPC endpoint
resource "aws_vpc_endpoint" "s3endpoint" {
  vpc_id = "${aws_vpc.vpc.id}"
  service_name = "${data.aws_vpc_endpoint_service.s3.service_name}"
  route_table_ids = ["${aws_route_table.route_public_subnet_1a.id}",
                    "${aws_route_table.route_public_subnet_1b.id}",
                    "${aws_route_table.route_private_subnet_1a.id}",
                    "${aws_route_table.route_private_subnet_1b.id}"]
}