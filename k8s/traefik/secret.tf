resource "kubernetes_secret" "tls_secrets" {
  metadata {
    name = "traefik-tls-cert"
    namespace = "${kubernetes_namespace.traefik.metadata.0.name}"
  
    labels {
        k8s-app = "traefik-ingress-lb"
    }
  }
  type = "kubernetes.io/tls"

  data {
    "tls.crt" = "${file("./tls.crt")}"
    "tls.key" = "${file("./tls.key")}"
   }
}