# to declare variable
# variable "env" {
#   type = string
#   description = "Env to deploy to"
#   default = "dev"
# }

variable "image" {
  type = map
  description = "image for container"
  default = {
    dev = "nodered/node-red:latest"
    prod = "nodered/node-red:latest-minimal"
  }
}
variable "exp_port" {
  #type = list
  type = map

#default = 1880
#sensitive = true # statement to hide sensitive info fron CLI
# Using validation rule
  validation {
    condition     = max(var.exp_port["dev"]...) <= 65535 && min(var.exp_port["dev"]...) >= 1980
    error_message = "The port is expected to be from 1980 to 65535."
  
  }
  
  
    validation {
    condition     = max(var.exp_port["prod"]...) < 1980 && min(var.exp_port["prod"]...) >= 1880
    error_message = "The port is expected to be from 1880 to 1979."
  
  }
  }
# to declare variable
variable "int_port" {
  type    = number
  default = 1880
  # Using validation rule
  validation {
    condition     = var.int_port == 1880
    error_message = "The internal port must be 1880."
  }
}
# variable "cont_count" {
#   type    = number
#   default = 3
# }
locals {
    cont_count = length(var.exp_port[terraform.workspace])
}
    


