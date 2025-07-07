variable "region" {}
variable "name_prefix" {}
variable "vpc_connection" {}
variable "ay_vpc" {}
variable "ay_snet" {}

variable "nodepool_vm_type" {
  default = "e2-standard-2"
}

variable "master_ipv4_cidr" {
  default = "10.50.0.0/28"
}

variable "nodepool_suffix" {
  default = "node-pl"
}

variable "cluster_nm" {}
variable "cluster_secondary_range_nm" {}
variable "svc_secondary_range_nm" {}