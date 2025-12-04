terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }

  backend "s3" {
    endpoint = "https://sfo3.digitaloceanspaces.com"
    bucket   = "terraform-state-lucas-itens"
    key      = "terraform.tfstate"

    region                      = "us-east-1"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
  }
}

provider "digitalocean" {
  token = var.do_token
}

# ============================================================
# SSH KEY
# ============================================================
resource "digitalocean_ssh_key" "default" {
  name       = "terraform-key-lucas"
  public_key = file(var.ssh_key_path)
}

# ============================================================
# DROPLET
# ============================================================
resource "digitalocean_droplet" "web_server" {
  image    = "ubuntu-24-04-x64"
  name     = "app-itens-prod"
  region   = "sfo3"
  size     = "s-1vcpu-2gb"

  ssh_keys = [
    digitalocean_ssh_key.default.fingerprint
  ]

  user_data = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y docker.io docker-compose-plugin git docker-compose
    mkdir -p /root/app-itens
    echo "Ambiente preparado pelo Terraform com sucesso!" >> /var/log/terraform-setup.log
  EOF
}

# ============================================================
# OUTPUT: IP DO DROPLET
# ============================================================
output "droplet_ip" {
  value = digitalocean_droplet.web_server.ipv4_address
}
