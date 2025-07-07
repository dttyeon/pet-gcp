output "argo_admin_password" {
  value = try(base64decode(data.kubernetes_secret.admin_password.data["password"]), "Not Ready Yet")
}

output "argo_cd_server_external_ip" {
  value = try(data.kubernetes_service.argo_cd_server.status[0].load_balancer[0].ingress[0].ip,"Pending")
}