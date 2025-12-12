output "droplet_ip" {
  description = "IP público do droplet"
  value       = digitalocean_droplet.app_server.ipv4_address
  sensitive   = false
}

output "droplet_status" {
  description = "Status do droplet"
  value       = digitalocean_droplet.app_server.status
}

output "ssh_key_name" {
  description = "Nome da chave SSH criada"
  value       = digitalocean_ssh_key.deploy_key.name
}