
resource "docker_container" "nodered_container" {
  #depends_on = [null_resource.dockervol] 
  # implicit dependencies
  #count = local.cont_count (no needed here since we have it in the root file
  name  = var.name_in
  #name  = join(".", ["boma-nodered", terraform.workspace, null_resource.dockervol.id, random_string.random[count.index].result])
  image = var.image_in

  ports {  
    internal = var.int_port_in
    external = var.exp_port_in
    }
 
  volumes {
    container_path = var.container_path_in
    #host_path      = var.host_path_in # path.cwd represent the nodered directory path.
    volume_name = docker_volume.container_volume.name
    
  }
  }
  # You will observer that after destruction, volumes still remain and when u apply
  #volume keeps piling up, to avoid this we need the following resources
  
resource "docker_volume" "container_volume" {
  name = "${var.name_in}.volume"
  lifecycle {
    prevent_destroy = false # this line prevents destruction of volume even when resources are destroyed
    
  }
}

# to delete the entire volumes: 
# docker volume rm -f $(docker volume ls -q)
