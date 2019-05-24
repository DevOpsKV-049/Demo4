##########################
### K8S PODs - Jypiter ###
##########################
resource "kubernetes_persistent_volume_claim" "custom-files" {
  metadata {
    name = "custom-files"
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests {
        storage = "2Gi"
      }
    }

    storage_class_name = "standard"
  }
}

resource "kubernetes_deployment" "jupyter-notebook" {
  metadata {
    name = "jupyter-notebook"

    labels {
      app  = "jupyter-notebook"
      role = "master"
      tier = "backend"
    }
  }

  spec {
    replicas = 1

    selector = {
      match_labels {
        app  = "jupyter-notebook"
        role = "master"
        tier = "backend"
      }
    }

    template {
      metadata {
        labels {
          app  = "jupyter-notebook"
          role = "master"
          tier = "backend"
        }
      }

      spec {
        init_container {
          name = "init-jupyter"
          image =  "jupyter/all-spark-notebook"
          command = ["bash", "-c", "sed -e \"s;%REGION%;${var.region};g\" -e \"s;%PROJECT%;${var.project};g\" /media/default-notebook.ipynb > /home/jovyan/work/default-notebook.ipynb && chmod a+w /home/jovyan/work/default-notebook.ipynb && sed -e \"s;%REGION%;${var.region};g\" -e \"s;%PROJECT%;${var.project};g\" /media/tensorflow.ipynb > /home/jovyan/work/tensorflow.ipynb && chmod a+w /home/jovyan/work/tensorflow.ipynb"]

          volume_mount {
            mount_path = "/media"
            name = "${kubernetes_config_map.jupyter_configmap.metadata.0.name}"
            read_only  = false
          }

          volume_mount {
            mount_path = "/home/jovyan/work"
            name       = "myfiles"
            read_only = false
          }
        }
        # init_container {
        #   name = "init-jupyter"
        #   image =  "jupyter/all-spark-notebook"
        #   command = ["bash", "-c", ""]
        # }
        security_context {
          fs_group = 100
        }
        volume {
          name = "${kubernetes_config_map.jupyter_configmap.metadata.0.name}"
          config_map {
            name = "${kubernetes_config_map.jupyter_configmap.metadata.0.name}"
          }
        }
        volume {
          name      = "myfiles"
        }
        container {
          image = "jupyter/all-spark-notebook"
          name  = "minimal-notebook"
          command = [ "start-notebook.sh" ]
            args = [
              "--NotebookApp.base_url='/jupyterx'", 
              "--NotebookApp.token='${var.j_token}'"
            ]
        
          # volume_mount {
          #   mount_path = "/media"
          #   name = "${kubernetes_config_map.jupyter_configmap.metadata.0.name}"
          #   read_only  = false
          # }

          volume_mount {
            mount_path = "/home/jovyan/work"
            name       = "myfiles"
            read_only = false
          }

          port {
            container_port = 8888
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