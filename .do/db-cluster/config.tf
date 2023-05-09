terraform {
  required_version = ">= 0.13"
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "codacy"

     workspaces {
       prefix = "codacy-do-"
    }
  }
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.28.1"
    }
  }
}
# note: make sure you set and export the DIGITALOCEAN_TOKEN environment variable,
# which holds your user token
provider "digitalocean" {
  token = var.digital_ocean_token
}
