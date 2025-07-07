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