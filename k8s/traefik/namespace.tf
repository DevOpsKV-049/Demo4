resource "kubernetes_namespace" "traefik" {
  metadata {
    name = "traefik"
  }
}
# output "traefik_namespace" {
#   value = "${kubernetes_namespace.traefik.name}"
# }
