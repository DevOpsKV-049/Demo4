###############################
### K8S PODs - Telegram Bot ###
###############################
resource "kubernetes_deployment" "telebot" {
  metadata {
    name = "telebot"

    labels {
      app  = "telebot"
      role = "master"
      tier = "backend"
    }
  }

  spec {
    replicas = 1

    selector = {
      match_labels {
        app  = "telebot"
        role = "master"
        tier = "backend"
      }
    }

    template {
      metadata {
        labels {
          app  = "telebot"
          role = "master"
          tier = "backend"
        }
      }

      spec {
        container {
          image = "denizka/telebot:v1.17"
          name  = "master"

          env {
            name  = "api_telegram"
            value = "${var.api_telegram}"
          }

          env {
            name  = "ip_redis"
            value = "${var.ip_redis}"
          }
          env {
            name  = "r_pass"
            value = "${var.r_pass}"
          }

          resources {
            requests {
              cpu    = "300m"
              memory = "1024Mi"
            }
          }
        }
      }
    }
  }
}
