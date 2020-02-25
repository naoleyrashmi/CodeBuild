output "aws_vpc.vpc.id" {
    value = "${aws_vpc.vpc.id}"
}

output "aws_subnet.public_subnet_az_1a.id" {
    value = "${aws_subnet.public_subnet_az_1a.id}"
}

output "aws_subnet.public_subnet_az_1b.id" {
    value = "${aws_subnet.public_subnet_az_1b.id}"
}

output "aws_subnet.private_subnet_az_1a.id" {
    value = "${aws_subnet.private_subnet_az_1a.id}"
}

output "aws_subnet.private_subnet_az_1b.id" {
    value = "${aws_subnet.private_subnet_az_1b.id}"
}