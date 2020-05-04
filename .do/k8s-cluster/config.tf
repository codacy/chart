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