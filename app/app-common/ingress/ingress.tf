provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "helm_release" "nginx-controller" {
  name       = "nginx-controller"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
    depends_on = [
      ws_eks_node_group.node_group
  ]
}