################################
# Category
################################

resource "discord_category_channel" "whole" {
  server_id = var.server.id
  name = "${var.year} 全体"
  position = var.year_common.category_position_start
}


################################
# News Channels
################################

resource "discord_news_channel" "announcement" {
  server_id = var.server.id
  name = "連絡"
  category = discord_category_channel.whole.id
  position = 1

  # Due to a bug in Terraform provider v2.1.0, an error occurs when referencing position, so ignore_changes is set.
  lifecycle {
    ignore_changes = [
      position
    ]    
  }
}


################################
# Forum Channels
################################

resource "discord_forum_channel" "question" {
  server_id = var.server.id
  name = "質問"
  category = discord_category_channel.whole.id
  position = 2
}


################################
# Text Channels
################################

resource "discord_text_channel" "introduction" {
  server_id = var.server.id
  name = "自己紹介"
  category = discord_category_channel.whole.id
  position = 3
}

resource "discord_text_channel" "chat" {
  server_id = var.server.id
  name = "雑談"
  category = discord_category_channel.whole.id
  position = 4
}


################################
# Voice Channels
################################

resource "discord_voice_channel" "talk_room" {
  for_each = toset(var.whole_channels.talk_room_names)

  server_id = var.server.id
  name = each.value
  category = discord_category_channel.whole.id
  position = index(var.whole_channels.talk_room_names, each.value) + 5
}
