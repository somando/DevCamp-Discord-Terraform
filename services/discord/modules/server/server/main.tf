################################
# Discord Server
################################

data "discord_server" "main" {
  server_id = var.discord_server_id
}
