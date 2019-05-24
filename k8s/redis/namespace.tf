resource "kubernetes_namespace" "redis_space" {
  metadata {
    name = "rspace"
  }
}