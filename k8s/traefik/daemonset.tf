resource "kubernetes_daemonset" "traefik_controller" {
  metadata {
    name      = "traefik-controller"
    namespace = "${kubernetes_namespace.traefik.metadata.0.name}"

    labels {
      k8s-app = "traefik-ingress-lb"
    }
  }

  spec {
    #replicas = 1
    selector = {
      match_labels {
        k8s-app = "traefik-ingress-lb"
        name    = "traefik-ingress-lb"
      }
    }

    template {
      metadata {
        labels {
          k8s-app = "traefik-ingress-lb"
          name    = "traefik-ingress-lb"
        }
      }

      spec {
        service_account_name             = "${kubernetes_service_account.traefik_controller_admin.metadata.0.name}"
        termination_grace_period_seconds = 60

        volume {
          name = "${kubernetes_config_map.traefik_configmap.metadata.0.name}"
          config_map {
            name = "${kubernetes_config_map.traefik_configmap.metadata.0.name}"
          }
        }
        volume {
          name = "traefik-tls-cert"
          secret {
            secret_name = "traefik-tls-cert"
          }
        }

        container {
          image = "traefik:2.0"        # The official v2.0 Traefik docker image
          name  = "traefik-ingress-lb"

          port {
            name           = "http"
            host_port = 80
            container_port = 80
          }
          port {
            name           = "web-secure"
            host_port = 443
            container_port = 443
          }

          port {
            name           = "dashboard"
            host_port = 8080
            container_port = 8080
          }
          
          port {
            name           = "tf"
            host_port = 9000
            container_port = 80
          }

          volume_mount {
            mount_path = "/config"
            name = "${kubernetes_config_map.traefik_configmap.metadata.0.name}"
            read_only  = false
          }
          volume_mount {
            mount_path = "/ssl"
            name = "traefik-tls-cert"
            #read_only  = false
          }

          resources {
            requests {
              cpu    = "100m"
              memory = "100Mi"
            }
          }

          args = [
            "--api",
            "--configfile=/config/traefik.toml"
          ]
        }
      }
    }
  }
}
