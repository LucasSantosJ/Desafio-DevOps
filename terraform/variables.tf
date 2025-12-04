variable "do_token" {
  description = "Token de API da DigitalOcean"
  type        = string
  sensitive   = true
}

variable "ssh_key_path" {
  description = "Caminho para sua chave pública SSH local"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}