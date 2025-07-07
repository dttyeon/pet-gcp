variable "project_id" {}
variable "roles" {}
variable "namespace" {}
variable "gsa_account_id" {}
variable "ksa_name" {}
variable "bind_wl_role" {
  default = "roles/iam.workloadIdentityUser"
}
variable "gsa_display_nm" {
  default = "Workload Identity GSA"
}