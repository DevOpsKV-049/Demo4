###########################
### K8S Service - Mongo ###
###########################
provider "kubernetes" {
  host                   = "${var.host}"
  username               = "${var.username}"
  password               = "${var.password}"
  client_certificate     = "${base64decode(var.client_certificate)}"
  client_key             = "${base64decode(var.client_key)}"
  cluster_ca_certificate = "${base64decode(var.cluster_ca_certificate)}"
  load_config_file       = false
}

# resource "null_resource" "IPformongo" {
#   provisioner "local-exec" {
#     command = "gcloud compute addresses create ipmongo --region $REGION --subnet default --addresses $IPMONGO"
    
#     environment = {
#       REGION =    "${var.region}"
#       IPMONGO = "${var.ipmongo}"
#     }
#   }
# }
resource "kubernetes_service" "mongo_master" {
  # depends_on = ["null_resource.IPformongo"]#mongo service doesn't know is internal IP reserved or not, this helps
  # depends_on = ["${module.gke.null_resource.IPformongo}"]
  metadata {
    name = "mongo-master"
    namespace = "${kubernetes_namespace.mongo_space.metadata.0.name}"
    annotations {
      "cloud.google.com/load-balancer-type" = "Internal"
    } 
    labels {
      app  = "mongo"
      role = "master"
      tier = "backend"
    }
  }

  spec {
    selector {
      app  = "mongo"
      role = "master"
      tier = "backend"
    }

    type = "LoadBalancer"
    # load_balancer_ip = "${var.ipmongo}"
    load_balancer_ip = "${var.nipmongo}"

    port {
      port        = 27017
      target_port = 27017
    }
  }
}


# output "ip" {
#   value = "${kubernetes_service.mongo-master.load_balancer_ingress.0.ip}"
# }
