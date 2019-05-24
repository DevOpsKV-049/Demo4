###########################
### K8S Service - Redis ###
###########################
provider "kubernetes" {
  host                   = "${var.host}"
  username               = "${var.username}"
  password               = "${var.password}"
  client_certificate     = "${base64decode(var.client_certificate)}"
  client_key             = "${base64decode(var.client_key)}"
  cluster_ca_certificate = "${base64decode(var.cluster_ca_certificate)}"
  load_config_file = false
}

# resource "null_resource" "IPforredis" {
#   provisioner "local-exec" {
#     command = "gcloud compute addresses create ipredis --region $REGION --subnet default --addresses $IPREDIS"
    
#     environment = {
#       REGION =    "${var.region}"
#       IPREDIS = "${var.ipredis}"
#     }
#   }
# }

resource "kubernetes_service" "redis-master" {
  # depends_on = ["null_resource.IPforredis"]#redis service doesn't know is internal IP reserved or not, this helps
  metadata {
    name = "redis-master"
    namespace = "${kubernetes_namespace.redis_space.metadata.0.name}"
    annotations {
      "cloud.google.com/load-balancer-type" = "Internal"
    } 
    labels {
      app  = "redis"
      role = "master"
      tier = "backend"
    }
  }

  spec {
    selector {
      app  = "redis"
      role = "master"
      tier = "backend"
    }

    type = "LoadBalancer"
    # load_balancer_ip = "${var.ipredis}"
    load_balancer_ip = "${var.nipredis}"
    port {
      port        = 13666
      target_port = 6379
    }
  }
}

# output "ip_redis" {
#   value = "${kubernetes_service.redis-master.load_balancer_ingress.0.ip}"
# }