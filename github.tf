data "github_repository" "flux" {
  full_name = var.flux_github_repo_name
}

resource "tls_private_key" "flux" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "github_repository_deploy_key" "flux" {
  repository = var.flux_github_repo_name
  title    = "${var.host_name}-flux"
  key      = tls_private_key.flux.public_key_openssh
  read_only = false
}