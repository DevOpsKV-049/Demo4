resource "kubernetes_config_map" "jupyter_configmap" {
  metadata {
    name = "jupyter-configmap"
  }
  data {
    default-notebook.ipynb = "${file("./k8s/jypiter/default-notebook.ipynb")}"
    tensorflow.ipynb = "${file("./k8s/jypiter/tensorflow.ipynb")}"
  }
}
