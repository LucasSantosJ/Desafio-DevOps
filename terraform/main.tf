# Cria um recurso de chave SSH na DigitalOcean
resource "digitalocean_ssh_key" "deploy_key" {
  name       = "deploy-key-${var.droplet_name}"
  public_key = var.ssh_public_key
}

resource "digitalocean_droplet" "app_server" {
  name     = var.droplet_name
  region   = var.region
  size     = var.size
  image    = "ubuntu-22-04-x64"
  
  # Usa a chave SSH criada acima
  ssh_keys = [digitalocean_ssh_key.deploy_key.fingerprint]
  
  # Cloud-init para instalar Docker
  user_data = <<-EOF
    #cloud-config
    package_update: true
    package_upgrade: true
    
    packages:
      - docker.io
      - docker-compose
      - git
      - curl
    
    runcmd:
      - systemctl enable docker
      - systemctl start docker
      - usermod -aG docker ubuntu
      - mkdir -p /app
      - chmod 755 /app
      
    # Garante que o root tem a chave SSH
    users:
      - name: root
        ssh_authorized_keys:
          - ${var.ssh_public_key}
  EOF

  tags = ["terraform", "app-server"]
}

# Firewall para segurança
resource "digitalocean_firewall" "app_firewall" {
  name = "app-firewall-${var.droplet_name}"
  
  droplet_ids = [digitalocean_droplet.app_server.id]
  
  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }
  
  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }
  
  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }
  
  inbound_rule {
    protocol         = "tcp"
    port_range       = "8080"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }
  
  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
  
  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}