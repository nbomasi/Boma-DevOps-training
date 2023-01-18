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
# Intoduced UNDER FOR_EACH
# locals {
#   deployment = {
#     nodered = {
#       cont_count = length(var.exp_port["nodered"][terraform.workspace]) # needed TO CREATE A NUMBER OF CONTAINERS
#       image = var.image["nodered"][terraform.workspace]
#       int = 1880
#       exp = var.exp_port["nodered"][terraform.workspace]
#       container_path = "/data"
#     }

#     influxdb = {
#       cont_count = length(var.exp_port["influxdb"][terraform.workspace])
#       image = var.image["influxdb"][terraform.workspace]
#       int = 1886
#       exp = var.exp_port["influxdb"][terraform.workspace]
#       container_path = "/var/lib/influxdb" # gotten from docs
#     }

#     grafana = {
#       cont_count = length(var.exp_port["grafana"][terraform.workspace])
#       image = var.image["grafana"][terraform.workspace]
#       int = 3000
#       exp = var.exp_port["grafana"][terraform.workspace]
#       container_path = "/var/lib/grafana" # gotten from docs
#     }
#     }
#   }
# LOCALS NOW MOVED TO local.tf to clean up this main file

#This is a block call module to help the system communicate with the module call image
module "image" {
  source   = "./image"
  for_each = local.deployment
  image_in = each.value.image # the "value" can also be called "key"
}
# Introduction for FOR_EACH, help to reduce duplicating modules, with this u can just create 1 module and use it to create another similar modules
# module "influxdb_image" {
#   source   = "./image"
#   image_in = var.image["influxdb"][terraform.workspace]
#}
# commented out because it has been copied to image module
# resource "docker_image" "nodered_image" {
#   name = (var.image[terraform.workspace])
# }
#"nodered/node-red:latest"
resource "random_string" "random" { #NOW MOVED TO CONTAINER MODULE main.docker.tf
  for_each = local.deployment
  # count   = cont_count
  length  = 4
  special = false
}
# We need to replace var.env terraform.workspace since we have succesfully created the 2 env environment (dev/prod). Also, we have created workspace.
#resource "docker_container" "nodered_container" {, we are no longer dealing with resources but module, this is why resources is now replaced with module
module "container" {
  source   = "./container"
  count_in = each.value.cont_count
  for_each = local.deployment
  #depends_on = [null_resource.dockervol] # explicit dependencies
  #count   = local.cont_count (commented out under container for eacg)
  name_in = each.key
  #name_in = join(".", [each.key, terraform.workspace, random_string.random[each.key].result])
  #name_in = join(".", ["boma-nodered", terraform.workspace, random_string.random[count.index].result])
  #name  = join(".", ["boma-nodered", terraform.workspace, null_resource.dockervol.id, random_string.random[count.index].result])
  image_in = module.image[each.key].image_out
  #image_in = module.image["nodered"].image_out
  # ports {          # null_resource.dockervol.id, for implicit dependencies
  #   internal = var.int_port
  #   #external = lookup(var.exp_port, terraform.workspace)[count.index] # to reference variable
  #   external = var.exp_port[terraform.workspace][count.index]
  # }

  int_port_in = each.value.int
  exp_port_in = each.value.exp
  # int_port_in = var.int_port
  # exp_port_in = var.exp_port[terraform.workspace][count.index]

  # Introduction of volumese
  #   volumes {
  #     container_path = "/data"
  #     host_path      = "${path.cwd}/noderedvol" # path.cwd represent the nodered directory path.

  #   }
  # }
  #container_path_in = each.value.container_path NOT NEEDED ANY MORE SINCE 
  # WE CREATED A VOLUME THAT HAVE REPLACED THE CONTAINER_PATH
  volumes_in = each.value.volumes

  # container_path_in = "/data"
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

