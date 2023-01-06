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
  length  = 4
  special = false
}

resource "docker_container" "nodered_container" {
  name  = "boma-nodered"
  image = docker_image.nodered_image.image_id
  ports {
    internal = 1880
    external = 1880
  }
}

# resource "docker_container" "nodered_container2" {
#   name  = "boma-nodered2"
#   image = docker_image.nodered_image.image_id
#   ports {
#     internal = 1880
#     # external = 1880
#   }
# }

output "Ip-Address" {
  value       = join(" : ", [docker_container.nodered_container.ip_address, docker_container.nodered_container.ports[0].internal])
  description = "ip addres of my container"
}

