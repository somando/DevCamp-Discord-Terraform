variable "common" { }
variable "year_common" { }
variable "server" { }
variable "year" { }
variable "teams" { }

locals {
  all_participants = toset(flatten(values(var.teams)))
}
