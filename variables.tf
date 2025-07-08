variable "region" {}
variable "project" {}
variable "environment" {}
variable "service" {}
variable "db_pw" {
  type      = string
  sensitive = true
}

variable "db_version" {}
variable "pods_range_nm" {}
variable "svc_range_nm" {}
variable "project_id" {}

variable "project_num" {}

variable "aws_access_key_id" {}
variable "aws_secret_access_key" {}
variable "aws_region" {}
variable "s3_bucket" {}