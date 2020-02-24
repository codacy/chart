resource "kubernetes_secret" "docker_credentials_codacy" {
  depends_on = [kubernetes_namespace.codacy]
  metadata {
    name = "docker-credentials"
    namespace = kubernetes_namespace.codacy.name
  }
  data = {
    ".dockerconfigjson" = "{\"auths\": {\"https://index.docker.io/v1/\": {\"auth\": \"${base64encode("${var.docker_username}:${var.docker_password}")}\"}}}"
  }

  type = "kubernetes.io/dockerconfigjson"
}

resource "kubernetes_secret" "docker_credentials_codacy_hourly" {
  depends_on = [kubernetes_namespace.codacy-hourly]
  metadata {
    name = "docker-credentials"
    namespace = kubernetes_namespace.codacy-hourly.name
  }
  data = {
    ".dockerconfigjson" = "{\"auths\": {\"https://index.docker.io/v1/\": {\"auth\": \"${base64encode("${var.docker_username}:${var.docker_password}")}\"}}}"
  }

  type = "kubernetes.io/dockerconfigjson"
}
resource "kubernetes_secret" "docker_credentials_codacy_production" {
  depends_on = [kubernetes_namespace.codacy-release]
  metadata {
    name = "docker-credentials"
    namespace = kubernetes_namespace.codacy-release.name
  }
  data = {
    ".dockerconfigjson" = "{\"auths\": {\"https://index.docker.io/v1/\": {\"auth\": \"${base64encode("${var.docker_username}:${var.docker_password}")}\"}}}"
  }

  type = "kubernetes.io/dockerconfigjson"
}
