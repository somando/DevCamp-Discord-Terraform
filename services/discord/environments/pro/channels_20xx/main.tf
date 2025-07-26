################################
# Whole Channels
################################

module "whole_channels" {
  source = "../../../modules/whole_channels/channels"

  common = var.common
  year_common = var.year_common
  server = data.terraform_remote_state.server.outputs.server
  year = var.year
  whole_channels = var.whole_channels
}


################################
# Teams Channels
################################

module "teams_channels" {
  source = "../../../modules/teams_channels/channels"

  common = var.common
  year_common = var.year_common
  server = data.terraform_remote_state.server.outputs.server
  year = var.year
  teams = var.teams
}
