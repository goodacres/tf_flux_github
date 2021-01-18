provider "kubernetes" {
  config_path      = "~/.kube/config"
  load_config_file = true
}

provider "helm" {
  version         = "1.3.2"  # We have to use Helm provider version 1.0.0 onwards for Helm 3 compatibility

  kubernetes {
    config_path      = "~/.kube/config"
    load_config_file = true
  }
}

provider "github" {
  token = var.github_patoken
  owner = var.github_user
}