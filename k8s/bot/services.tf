##################################
### K8S Service - Telegram Bot ###
##################################
provider "kubernetes" {
  host                   = "${var.host}"
  username               = "${var.username}"
  password               = "${var.password}"
  client_certificate     = "${base64decode(var.client_certificate)}"
  client_key             = "${base64decode(var.client_key)}"
  cluster_ca_certificate = "${base64decode(var.cluster_ca_certificate)}"
  load_config_file = false
}
resource "kubernetes_service" "telebot" {
  metadata {
    name = "telebot"

    labels {
      app  = "telebot"
      role = "master"
      tier = "backend"
    }
  }

  spec {
    selector {
      app  = "telebot"
      role = "master"
      tier = "backend"
    }
    port {
      port        = 80
    }
    type = "ClusterIP"
  }
}