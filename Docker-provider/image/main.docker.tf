# For image module
#resource "docker_image" "nodered_image" { , renamed to container-image since we are no longer dealing with just nodered_image
resource "docker_image" "container_image" {
  name = var.image_in
}