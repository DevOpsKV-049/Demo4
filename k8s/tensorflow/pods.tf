#######################
### K8S POD - Redis ###
#######################
resource "kubernetes_deployment" "tf" {
  metadata {
    name = "tf"

    labels {
      app  = "tf"
      role = "master"
      tier = "backend"
    }
  }

  spec {
    replicas = 1

    selector = {
      match_labels {
        app  = "tf"
        role = "master"
        tier = "backend"
      }
    }

    template {
      metadata {
        labels {
          app  = "tf"
          role = "master"
          tier = "backend"
        }
      }

      spec {
        container {
          image = "yuriy6735/flask"
          name  = "master"

          port {
            container_port = 80
            
          }

          resources {
            requests {
              cpu    = "100m"
              memory = "512Mi"
            }
          }
        }
      }
    }
  }
}
