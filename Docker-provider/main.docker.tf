terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.24.0"
    }
  }
}

provider "docker" {}


resource "docker_image" "nodered_image" {
  name = "nodered/node-red:latest"
}

resource "random_string" "random" {
  count   = var.cont_count
  length  = 4
  special = false
}

resource "docker_container" "nodered_container" {
  count = var.cont_count
  name  = join(".", ["boma-nodered", random_string.random[count.index].result])
  image = docker_image.nodered_image.image_id
  ports {
    internal = var.int_port
    external = var.exp_port # to reference variable
  }
}

# resource "docker_container" "nodered_container2" {
#   name  = "boma-nodered2"
#   image = docker_image.nodered_image.image_id
#   ports {
#     internal = 1880
#     external = 1800
#   }
# }

