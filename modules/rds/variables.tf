variable "vpc" {}
variable "vpc_conn" {}
variable "name_prefix" {}

variable "db_type" {
  default = "db-f1-micro"
}

variable "db_version" {}

variable "region" {}

variable "db_user_nm" {
  default = "root"
}

variable "db_pw" {}

variable "add_db_nm" {
  default = "petclinic"
}

variable "rds_suffix" {
  default = "mysql"
}