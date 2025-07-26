################################
# Category
################################

resource "discord_category_channel" "main" {
  server_id = var.server.id
  name = "${var.year} ${var.team}"
  position = var.year_common.category_position_start + var.team_number
}


################################
# Channels
################################

resource "discord_text_channel" "public" {
  server_id = var.server.id
  name = "public"
  category = discord_category_channel.main.id
  position = 1
}

resource "discord_text_channel" "private" {
  server_id = var.server.id
  name = "private"
  category = discord_category_channel.main.id
  sync_perms_with_category = false
  position = 2
}

resource "discord_voice_channel" "talk" {
  server_id = var.server.id
  name = "talk"
  category = discord_category_channel.main.id
  sync_perms_with_category = false
  position = 3
}


################################
# Roles
################################

resource "discord_role" "team" {
  server_id = var.server.id
  name = "${var.year} ${var.team}"
  mentionable = true

  lifecycle {
    ignore_changes = [
      position
    ]
  }
}

resource "discord_member_roles" "main" {
  for_each = toset(var.participants)

  server_id = var.server.id
  user_id = each.value

  role {
    role_id = discord_role.team.id
  }

  depends_on = [
    discord_role.team
  ]
}


################################
# Permissions
################################

resource "discord_channel_permission" "private_allow" {
  channel_id = discord_text_channel.private.id
  type = "role"
  overwrite_id = discord_role.team.id
  allow = data.discord_permission.allow_view_channel.allow_bits
}

resource "discord_channel_permission" "private_deny" {
  channel_id = discord_text_channel.private.id
  type = "role"
  overwrite_id = var.everyone_role_id
  deny = data.discord_permission.deny_view_channel.deny_bits
}

resource "discord_channel_permission" "talk_allow" {
  channel_id = discord_voice_channel.talk.id
  type = "role"
  overwrite_id = discord_role.team.id
  allow = data.discord_permission.allow_view_channel.allow_bits
}

resource "discord_channel_permission" "talk_deny" {
  channel_id = discord_voice_channel.talk.id
  type = "role"
  overwrite_id = var.everyone_role_id
  deny = data.discord_permission.deny_view_channel.deny_bits
}


################################
# Permission Data
################################

data "discord_permission" "allow_view_channel" {
  view_channel = "allow"
}

data "discord_permission" "deny_view_channel" {
  view_channel = "deny"
}
