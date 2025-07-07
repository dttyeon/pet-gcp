variable "region" {}

variable "zone" {
  default = "asia-northeast3-a"
}

variable "vpc_id" {}
variable "snet_id" {}

variable "ssl-route" {
  default = "https://www.googleapis.com/compute/v1/projects/kdt1-finalproject/global/sslCertificates/ay-ssl"
}

variable "was_mig" {}
variable "web_mig" {}
variable "nlb_nm" {}
variable "nlb_ip_nm" {}
variable "nlb_rule_nm" {}
variable "alb_nm" {}
variable "alb_ip_nm" {}
