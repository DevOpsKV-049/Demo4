#############################
### K8S Service - Jypiter ###
#############################
provider "kubernetes" {
  host                   = "${var.host}"
  username               = "${var.username}"
  password               = "${var.password}"
  client_certificate     = "${base64decode(var.client_certificate)}"
  client_key             = "${base64decode(var.client_key)}"
  cluster_ca_certificate = "${base64decode(var.cluster_ca_certificate)}"
  load_config_file = false
}
resource "kubernetes_service" "jupyter-service" {
  metadata {
    name = "jupyter-service"

    labels {
      app  = "jupyter-notebook"
      role = "master"
      tier = "backend"
    }
  }

  spec {
    selector {
      app  = "jupyter-notebook"
      role = "master"
      tier = "backend"
    }

    type = "ClusterIP"

    port {
      port        = 80
      target_port = 8888
    }
  }
}