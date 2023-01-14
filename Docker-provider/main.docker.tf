# Commented out so that I can create provider.tf file to stand on its own
# terraform {
#   required_providers {
#     docker = {
#       source  = "kreuzwerker/docker"
#       version = "2.24.0"
#     }
#   }
# }

# provider "docker" {}
# to include local script
# resource "null_resource" "dockervol" {
#   provisioner "local-exec" {
#     command = "sleep 60 && mkdir noderedvol/ || true && sudo chown -R 1000:1000 noderedvol/"
#   }
#}
#This is a block call module to help the system communicate with the module call image
module "nodered_image" {
  source = "./image"
  image_in = var.image["nodered"][terraform.workspace]
}

module "influxdb_image" {
  source = "./image"
  image_in = var.image["influxdb"][terraform.workspace]
}
# commented out because it has been copied to image module
# resource "docker_image" "nodered_image" {
#   name = (var.image[terraform.workspace])
# }
#"nodered/node-red:latest"
resource "random_string" "random" {
  count   = local.cont_count
  length  = 4
  special = false
}
# We need to replace var.env terraform.workspace since we have succesfully created the 2 env environment (dev/prod). Also, we have created workspace.
#resource "docker_container" "nodered_container" {, we are no longer dealing with resources but module, this is why resources is now replaced with module
module "container" {
  source = "./container"

  #depends_on = [null_resource.dockervol] # explicit dependencies
  count = local.cont_count
  name_in  = join(".", ["boma-nodered", terraform.workspace, random_string.random[count.index].result])
  #name  = join(".", ["boma-nodered", terraform.workspace, null_resource.dockervol.id, random_string.random[count.index].result])
  image_in = module.nodered_image.image_out
  # ports {          # null_resource.dockervol.id, for implicit dependencies
  #   internal = var.int_port
  #   #external = lookup(var.exp_port, terraform.workspace)[count.index] # to reference variable
  #   external = var.exp_port[terraform.workspace][count.index]
  # }
  int_port_in = var.int_port
  exp_port_in = var.exp_port[terraform.workspace][count.index]

# Introduction of volumes
#   volumes {
#     container_path = "/data"
#     host_path      = "${path.cwd}/noderedvol" # path.cwd represent the nodered directory path.
    
#   }
# }
  container_path_in = "/data"
 # host_path_in      = "${path.cwd}/noderedvol" # path.cwd represent the nodered directory path.
  }

# resource "docker_container" "nodered_container2" {
#   name  = "boma-nodered2"
#   image = docker_image.nodered_image.image_id
#   ports {
#     internal = 1880
#     external = 1800
#   }
# }

