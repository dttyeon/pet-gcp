data "kubernetes_secret" "admin_password" {
  metadata {
    name      = "argocd-initial-admin-secret"
    namespace = "argocd"
  }
}

data "kubernetes_service" "argo_cd_server" {
  metadata {
    name      = "argocd-server"
    namespace = "argocd"
  }
}

resource "helm_release" "argo_cd" {
  name             = var.argo_nm
  namespace        = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "8.1.2"
  create_namespace = true

  set = [
    {
      name  = "server.service.type"
      value = "LoadBalancer"
    }
  ]

}