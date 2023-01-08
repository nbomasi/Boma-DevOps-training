terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.24.0"
    }
  }
}

provider "docker" {}

variable "exp_port" {
  type = number
  default = 1880
} # to declare variable

variable "int_port" {
  type = number 
  default = 1880
}

variable "cont_count" {
  type = number
  default = 1
}

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

output "container-name" {
  value       = docker_container.nodered_container[*].name
  description = "The name of the container"
}

output "Ip-Address" {
  value       = [for i in docker_container.nodered_container[*] : join(" : ", [i.ip_address], i.ports[*]["external"])]
  description = "ip addres of my container"
}

# output "container-name2" {
#   value       = docker_container.nodered_container[1].name
#   description = "The name of the container"
# }

# output "Ip-Address2" {
#   value       = join(" : ", [docker_container.nodered_container[1].ip_address, docker_container.nodered_container[1].ports[0].internal])
#   description = "ip addres of my container"
# }

