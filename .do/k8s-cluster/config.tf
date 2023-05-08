terraform {
  required_version = ">= 0.13"
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "codacy"

     workspaces {
       prefix = "codacy-doks-cluster-"
    }
  }
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.28.1"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~> 2.20.0"
    }
  }
}
# note: make sure you set and export the DIGITALOCEAN_TOKEN environment variable,
# which holds your user token
provider "digitalocean" {
  token = var.digital_ocean_token
}

provider "kubernetes" {
  config_path = var.k8s_kubeconfig
}
