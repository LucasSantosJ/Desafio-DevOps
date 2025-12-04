output "droplet_ip" {
  description = "O endereço IP público do novo servidor"
  value       = digitalocean_droplet.web_server.ipv4_address
}