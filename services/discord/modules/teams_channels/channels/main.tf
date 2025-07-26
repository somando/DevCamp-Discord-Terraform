module "teams" {
  for_each = var.teams

  source = "./modules"

  common = var.common
  year_common = var.year_common
  server = var.server
  year = var.year
  team = each.key
  team_number = index(keys(var.teams), each.key) + 1
  everyone_role_id = data.discord_role.everyone.id
  participants = each.value
}

resource "discord_role" "participants" {
  server_id = var.server.id
  name = "${var.year} Participants"
  mentionable = true

  lifecycle {
    ignore_changes = [
      position
    ]
  }
}

resource "discord_member_roles" "participants" {
  for_each = local.all_participants

  server_id = var.server.id
  user_id = each.value

  role {
    role_id = discord_role.participants.id
  }
}

data "discord_role" "everyone" {
  server_id = var.server.id
  name = "@everyone"
}
