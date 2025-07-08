variable project_id {}
variable "region" {}
variable "sql_exp_sa_nm" {}
variable "sql_exp_nm" {}
variable "export_bucket" {}
variable "source_archive" {
  default = "sql-run.zip"
}

variable "instance_id" {}