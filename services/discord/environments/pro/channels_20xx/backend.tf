terraform {
  required_providers {
    discord = {
      source = "Lucky3028/discord"
      version = "~> 2.1"
    }
  }

  backend "http" {
  }
}

################################
# Server Remote State
################################

data "terraform_remote_state" "server" {
  backend = "http"
  
  config = {
    address = "${var.gitlab_remote_state_address}/devcamp-server"
    username = var.gitlab_username
    password = var.gitlab_access_token
  }
}
