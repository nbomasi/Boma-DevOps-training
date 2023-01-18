
resource "random_string" "random" {
  count = var.count_in
  #for_each = local.deployment
  length  = 4
  special = false
  }

resource "docker_container" "app_container" { # to make the name more generic sin will be dealing with more containers
  #depends_on = [null_resource.dockervol] 
  # implicit dependencies
  #count = local.cont_count (no needed here since we have it in the root file
  count = var.count_in
  name  = join(".", [var.name_in, terraform.workspace, random_string.random[count.index].result])
  
  #name  = join(".", ["boma-nodered", terraform.workspace, null_resource.dockervol.id, random_string.random[count.index].result])
  image = var.image_in

  ports {  
    internal = var.int_port_in
    external = var.exp_port_in[count.index]
    }
 
  dynamic "volumes" {
    for_each = var.volumes_in
    content {
      container_path = volumes.value["container_path_each"]
    #host_path      = var.host_path_in # path.cwd represent the nodered directory path.
      volume_name = module.volume[count.index].volume_output[volumes.key]
  }
  }
  provisioner "local-exec" {
    command = "echo ${self.name}: ${self.ip_address}:${join(".",[for x in self.ports[*]["external"]: x])} >> containers.txt"
    }
  provisioner "local-exec" {
    when = destroy
    command = "rm -f container.txt"
  }   
  }

module "volume" {
  source = "./volume"
  count = var.count_in
  volume_count = length(var.volumes_in)
  volume_name = "${var.name_in}-${terraform.workspace}-${random_string.random[count.index].result}-volume"
}
  
  # You will observer that after destruction, volumes still remain and when u apply
  #volume keeps piling up, to avoid this we need the following resources
  
# resource "docker_volume" "container_volume" {
#   #count = var.count_in
#   count = length(var.volume_in)
#   name = "${var.name_in}-${count.index}-volume"
#   #name = "${var.name_in}-${random_string.random[count.index].result}-volume"
#   lifecycle {
#     prevent_destroy = false # this line prevents destruction of volume even when resources are destroyed
#   }
  
# # THE FOLLOWING LINES OF CODE CREATE  A DIRECTORY CALLED BACKUP AND CONVERTS
# # THE VOLUME INTO GZ FILE
#   provisioner "local-exec" {
#     when = destroy
#     command = "mkdir ${path.cwd}/../backup/"
#     on_failure = continue
    
#   }

#   provisioner "local-exec" {
#     when = destroy
#     command = "sudo tar -czvf ${path.cwd}/../backup/${self.name}.tar.gz ${self.mountpoint}/"
#     on_failure = fail
#   }

 
# }

# THE VOLUME SECTION IS COMMENTED OUT BECAUSE WE CREATED A VOLUME MODULE AND THEN SEND IT TO THE MODULE

# to delete the entire volumes: 
# docker volume rm -f $(docker volume ls -q)
