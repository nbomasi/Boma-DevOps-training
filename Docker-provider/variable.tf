# to declare variable
variable "exp_port" {
  type    = number
  default = 1880
  # Using validation rule
  validation {
    condition     = var.exp_port <= 65535 && var.exp_port > 0
    error_message = "The port is expected to be from 1 to 65535."
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
variable "cont_count" {
  type    = number
  default = 1
}
