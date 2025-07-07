variable "run_job_sa_nm" {}
variable "dump_job_nm" {}
variable "region" {}
variable "container_image" {
  default = "asia-northeast3-docker.pkg.dev/kdt1-finalproject/ay-repo/mysql-dumper"
}

variable "db_name" {
  default = "petclinic"
}

variable "db_user" {
  default = "root"  
}

variable "db_password" {
  default = "petclinic"
}

variable "instance_connection_name" {}