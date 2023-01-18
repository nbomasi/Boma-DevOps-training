# output "container-name" {
#   value = module.container[*].container-name
#   #value       = docker_container.nodered_container[*].name
#   description = "The name of the container"
# }

# output "Ip-Address" {
#   value = flatten(module.container[*].ip-address)
#   # value       = [for i in docker_container.nodered_container[*] : join(" : ", [i.ip_address], i.ports[*]["external"])]
#   description = "ip addres of my container"
#sensitive = true
#}

# output "container-name2" {
#   value       = docker_container.nodered_container[1].name
#   description = "The name of the container"
# }

# output "Ip-Address2" {
#   value       = join(" : ", [docker_container.nodered_container[1].ip_address, docker_container.nodered_container[1].ports[0].internal])
#   description = "ip addres of my container"
# }
output "application_access" {
  value       = [for x in module.container[*] : x]
  description = "The name and socket for each application."
}

