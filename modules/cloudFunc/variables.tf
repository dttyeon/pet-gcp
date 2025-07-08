variable project_id {}
variable "region" {}
variable "sql_exp_sa_nm" {}
variable "sql_exp_nm" {}
variable "export_bucket" {}
variable "dump_source_archive" {
  default = "sql-run.zip"
}
variable "tran_source_archive" {
  default = "tran.zip"
}
variable "instance_id" {}
variable "aws_access_key_id" {}
variable "aws_secret_access_key" {}
variable "aws_region" {}
variable "s3_bucket" {}