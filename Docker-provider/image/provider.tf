# image module
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.24.0"
    }
  }
}

#provider "docker" {}  # this is not needed inherited from parent module