resource "kubernetes_namespace" "mongo_space" {
  metadata {
    name = "mspace"
  }
}