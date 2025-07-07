variable "region" {}

variable "snet_ip_cidr" {
  default = "10.10.0.0/24"
}

variable "iap_ip_range" {
  default = "35.235.240.0/20"
}

variable "db" {}

variable "gke_pod_cidr" {
  default = "10.20.0.0/16"
}

variable "gke_svc_cidr" {
  default = "10.30.0.0/20"
}

variable "vpc_conn_cidr" {
  default = "10.8.0.0/28"
}

variable "db_ip_cidr" {
  default = "192.168.0.0"
}

variable "pods_range_nm" {}
variable "svc_range_nm" {}
variable "vpc_nm" {}
variable "snet_nm" {}
variable "nat_nm" {}
variable "router_nm" {}
variable "vpc_ip_range_nm" {}
variable "vpc_connector_nm" {}
