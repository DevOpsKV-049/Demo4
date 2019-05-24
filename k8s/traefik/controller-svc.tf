#############################
### K8S Service - Traefik Controller ###
#############################
provider "kubernetes" {
  host                   = "${var.host}"
  username               = "${var.username}"
  password               = "${var.password}"
  client_certificate     = "${base64decode(var.client_certificate)}"
  client_key             = "${base64decode(var.client_key)}"
  cluster_ca_certificate = "${base64decode(var.cluster_ca_certificate)}"
  load_config_file       = false
}

resource "kubernetes_service" "traefik_service" {
  metadata {
    name      = "traefik-service"
    namespace = "${kubernetes_namespace.traefik.metadata.0.name}"
  }

  spec {
    selector {
      k8s-app = "traefik-ingress-lb"
    }

    type             = "LoadBalancer"
    load_balancer_ip = "${var.lb_ext_ip}"

    port {
      protocol = "TCP"
      port     = 80
      name     = "web"
    }
    port {
      protocol = "TCP"
      port     = 443
      name     = "web-secure"
    }

    port {
      protocol = "TCP"
      port     = 8080
      name     = "dashboard"
    }

    port {
      protocol = "TCP"
      port     = 9000
      name     = "tf"
    }
  }
}

# resource "kubernetes_service" "traefik-dashboard" {
#   metadata {
#     name      = "traefik-dashboard"
#     namespace = "traefik"


#     spec {
#       selector {
#         k8s-app = "traefik-ingress-lb"
#       }


#       port {
#         port       = 80
#         targetPort = 8080
#         name       = "dashboard"
#       }
#     }
#   }
# }

