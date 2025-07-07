variable "db_ip" {}

variable "region" {}

variable "zone" {
  default = "asia-northeast3-a"
}

variable "vpc_id" {}

variable "snet_id" {}

variable "ssl-route" {
  default = "https://www.googleapis.com/compute/v1/projects/kdt1-finalproject/global/sslCertificates/ay-ssl"
}

variable "vm_type" {
  default = "e2-medium"
}

variable "img_path" {
  default = "projects/kdt1-finalproject/global/images/"  
  type = string
}

variable "nlb_ip" {}