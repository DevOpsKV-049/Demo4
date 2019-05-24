resource "kubernetes_service_account" "traefik_controller_admin" {
  metadata {
    name = "traefik-controller-admin"
    namespace = "${kubernetes_namespace.traefik.metadata.0.name}"
  }
}
output "sa" {
  value = "${kubernetes_service_account.traefik_controller_admin.metadata.0.name}"
}

resource "kubernetes_role_binding" "traefik_cluster_role_binding" {
  metadata {
        name = "traefik-cluster-role-binding"
        namespace = "${kubernetes_namespace.traefik.metadata.0.name}"
    }
    role_ref {
        api_group = "rbac.authorization.k8s.io"
        kind = "ClusterRole"
        name = "cluster-admin"
    }
    subject {
        kind = "ServiceAccount"
        name = "traefik-controller-admin"
        namespace = "${kubernetes_namespace.traefik.metadata.0.name}"
        /*api_group = "rbac.authorization.k8s.io"*/
    }
}