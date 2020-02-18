terraform {
  required_version = "~> 0.12"
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "codacy"

     workspaces {
       prefix = "codacy-doks-cluster-"
    }
  }
}

# note: make sure you set and export the DIGITALOCEAN_TOKEN environment variable,
# which holds your user token
provider "digitalocean" {
  version = "~> 1.4"
  token = var.digital_ocean_token
}

# setup helm
provider "helm" {
  version = "~> 0.9"
  # tiller is only installed if you actually do something with this provider, such as installing a chart
  install_tiller  = "true"
  service_account = "tiller"
  tiller_image    = "gcr.io/kubernetes-helm/tiller:v2.16.3"

  kubernetes {
    host = digitalocean_kubernetes_cluster.codacy_k8s.endpoint
    # load_config_file = false
    client_certificate     = base64decode(digitalocean_kubernetes_cluster.codacy_k8s.kube_config[0].client_certificate)
    client_key             = base64decode(digitalocean_kubernetes_cluster.codacy_k8s.kube_config[0].client_key)
    cluster_ca_certificate = base64decode(digitalocean_kubernetes_cluster.codacy_k8s.kube_config[0].cluster_ca_certificate)
  }

}

# setup the k8s provider using the do cluster data
provider "kubernetes" {
  version = "~> 1.7"
  host = digitalocean_kubernetes_cluster.codacy_k8s.endpoint
  # load_config_file = false
  client_certificate     = base64decode(digitalocean_kubernetes_cluster.codacy_k8s.kube_config[0].client_certificate)
  client_key             = base64decode(digitalocean_kubernetes_cluster.codacy_k8s.kube_config[0].client_key)
  cluster_ca_certificate = base64decode(digitalocean_kubernetes_cluster.codacy_k8s.kube_config[0].cluster_ca_certificate)

}

