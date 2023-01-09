terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.24.0"
    }
  }
}

provider "docker" {}
# to include local script
resource "null_resource" "dockervol" {
  provisioner "local-exec" {
    command = "mkdir noderedvol/ || true && sudo chown -R 1000:1000 noderedvol/"
  }
}
resource "docker_image" "nodered_image" {
  name = (var.image[terraform.workspace])
}
#"nodered/node-red:latest"
resource "random_string" "random" {
  count   = local.cont_count
  length  = 4
  special = false
}
# We need to replace var.env terraform.workspace since we have succesfully created the 2 env environment (dev/prod). Also, we have created workspace.
resource "docker_container" "nodered_container" {
  count = local.cont_count
  name  = join(".", ["boma-nodered", terraform.workspace, random_string.random[count.index].result])
  image = docker_image.nodered_image.image_id
  ports {
    internal = var.int_port
    #external = lookup(var.exp_port, terraform.workspace)[count.index] # to reference variable
    external = var.exp_port[terraform.workspace][count.index]
  }

# Introduction of volumes
  volumes {
    container_path = "/data"
    host_path      = "${path.cwd}/noderedvol" # path.cwd represent the nodered directory path.
    
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

