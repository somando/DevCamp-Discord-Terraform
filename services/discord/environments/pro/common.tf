################################
# Common Variables
################################

variable "common" {
  default = {
  }
}

variable "discord_token" {
  type = string
  sensitive = true
}
