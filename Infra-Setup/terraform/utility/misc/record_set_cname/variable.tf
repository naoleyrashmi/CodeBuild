variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_region" {}
variable "token" {}
variable "hosted_zone_backend_bucket" {}
variable "hosted_zone_backend_key" {}
variable "hosted_zone_backend_region" {}
variable "hosted_zone_type" {}
variable "record_set_name" {}
variable "record_set_record" {}
variable "record_set_ttl" {
    default     = "300"
}