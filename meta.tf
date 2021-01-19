terraform {
  required_providers {
    helm = "~> 1.3.2"   # 1.0.0 and beyond for Helm 3 support
  }
}

provider "kubernetes" {
  config_path      = "~/.kube/config"
  load_config_file = true
}

provider "helm" {
  kubernetes {
    config_path      = "~/.kube/config"
    load_config_file = true
  }
}

provider "github" {
  token = var.github_patoken
  owner = var.github_user
}