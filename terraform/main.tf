terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }

  # --- CONFIGURAÇÃO DO STATE REMOTO (NOVO) ---
  backend "s3" {
    # 1. Endpoint do Space (se criou em sfo3, fica sfo3.digitaloceanspaces.com)
    endpoint = "https://sfo3.digitaloceanspaces.com"


    bucket = "terraform-state-lucas-itens"

    key                         = "terraform.tfstate"
    region                      = "us-east-1" # Mantenha us-east-1 (padrão técnico)
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true 
  }
  # -------------------------------------------
}

# Configura o Provider (quem vai criar a infra)
provider "digitalocean" {
  token = var.do_token
}

# Recurso 1: Adiciona sua chave SSH atual na DigitalOcean
resource "digitalocean_ssh_key" "default" {
  name       = "terraform-key-lucas"
  public_key = file(var.ssh_key_path)
}

# Recurso 2: O Servidor (Droplet)
resource "digitalocean_droplet" "web_server" {
  image    = "ubuntu-24-04-x64"
  name     = "app-itens-prod"
  region   = "sfo3" 
  size     = "s-1vcpu-2gb"
  ssh_keys = [digitalocean_ssh_key.default.fingerprint]

  # Cloud-Init: Script que roda na primeira vez que a máquina liga
  user_data = <<-EOF
    #!/bin/bash
    # Atualiza pacotes
    apt-get update
    
    # Instala Docker, Git e Docker Compose
    apt-get install -y docker.io docker-compose-plugin git docker-compose

    # Cria a pasta do projeto (para adiantar o deploy)
    mkdir -p /root/app-itens
    
    # (Opcional) Print para verificar nos logs depois
    echo "Ambiente preparado pelo Terraform com sucesso!" >> /var/log/terraform-setup.log
  EOF
}