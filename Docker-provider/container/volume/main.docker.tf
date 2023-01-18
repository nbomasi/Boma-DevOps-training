resource "docker_volume" "container_volume" {
  #count = var.count_in
  count = var.volume_count
  name  = "${var.volume_name}-${count.index}"
  #name = "${var.name_in}-${random_string.random[count.index].result}-volume"
  lifecycle {
    prevent_destroy = false # this line prevents destruction of volume even when resources are destroyed
  }

  # THE FOLLOWING LINES OF CODE CREATE  A DIRECTORY CALLED BACKUP AND CONVERTS
  # THE VOLUME INTO GZ FILE
  provisioner "local-exec" {
    when       = destroy
    command    = "mkdir ${path.cwd}/../backup/"
    on_failure = continue

  }

  provisioner "local-exec" {
    when       = destroy
    command    = "sudo tar -czvf ${path.cwd}/../backup/${self.name}.tar.gz ${self.mountpoint}/"
    on_failure = fail
  }


}
