variable "year_common" {
  type = object({
    category_position_start = number
  })

  default = {
    category_position_start = 3
  }
}

variable "year" {
  type = string

  default = "20xx"
}

variable "whole_channels" {
  type = object({
    talk_room_names = list(string)
  })

  default = {
    # Talk room names must be unique.
    talk_room_names = [
      "談話ルームA",
      "談話ルームB"
    ]
  }
}

variable "teams" {
  type = map(list(string))

  # Team names must be unique.
  default = {
    "チームA" = ["xxxxxxxxxxxxxxxxxx"]
    "チームB" = ["xxxxxxxxxxxxxxxxxx"]
  }
}


################################
# Please do not edit below this line.
# These settings are for GitLab Terraform State.
# If you use S3 as the backend, please delete the following variables.
################################

variable "gitlab_remote_state_address" {
  type = string
  sensitive = true
}

variable "gitlab_username" {
  type = string
  sensitive = true
}

variable "gitlab_access_token" {
  type = string
  sensitive = true
}
