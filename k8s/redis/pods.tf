#######################
### K8S POD - Redis ###
#######################
resource "kubernetes_deployment" "redis-master" {
  metadata {
    name = "redis-master"
    namespace = "${kubernetes_namespace.redis_space.metadata.0.name}"

    labels {
      app  = "redis"
      role = "master"
      tier = "backend"
    }
  }

  spec {
    replicas = 1

    selector = {
      match_labels {
        app  = "redis"
        role = "master"
        tier = "backend"
      }
    }

    template {
      metadata {
        labels {
          app  = "redis"
          role = "master"
          tier = "backend"
        }
      }

      spec {
        container {
          image = "bitnami/redis:latest"
          name  = "master"

          port {
            container_port = 6379
          }
          env {
            name  = "REDIS_PASSWORD"
            value = "${var.REDIS_PASSWORD}"
          }
          resources {
            requests {
              cpu    = "100m"
              memory = "100Mi"
            }
          }
        }
      }
    }
  }
}
