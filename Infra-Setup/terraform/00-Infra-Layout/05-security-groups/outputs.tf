output "aws_security_group.app_sg.id" {
    value = "${aws_security_group.app_sg.id}"
}

output "aws_security_group.db_sg.id" {
    value = "${aws_security_group.db_sg.id}"
}

output "aws_security_group.vpn_sg.id" {
    value = "${aws_security_group.vpn_sg.id}"
}

output "aws_security_group.rds_migration_sg.id" {
    value = "${aws_security_group.rds_migration_sg.id}"
}

output "aws_security_group.app_lb_sg.id" {
    value = "${aws_security_group.app_lb_sg.id}"
}