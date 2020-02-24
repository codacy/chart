resource "kubernetes_namespace" "codacy" {
  metadata {
    name = "codacy"
    labels = {
      name = "codacy"
    }
  }
}

resource "kubernetes_namespace" "codacy-hourly" {
  metadata {
    name = "codacy-hourly"
    labels = {
      name = "codacy-hourly"
    }
  }
}

resource "kubernetes_namespace" "codacy-release" {
  metadata {
    name = "codacy-release"
    labels = {
      name = "codacy-release"
    }
  }
}