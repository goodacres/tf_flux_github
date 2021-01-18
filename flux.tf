resource "kubernetes_namespace" "flux" {
  metadata {
    name = "flux"
  }
}

resource "kubernetes_secret" "flux_deploy_key" {
  metadata {
    namespace = kubernetes_namespace.flux.id
    name      = "flux-deploy-key"
  }

  data = {
    identity = tls_private_key.flux.private_key_pem
  }

  type = "Opaque"
}

resource "helm_release" "flux" {
  name       = "flux"
  namespace  = kubernetes_namespace.flux.id
  repository = "https://charts.fluxcd.io"
  chart      = "flux"
  version    = var.flux_version

#  values    = [file("${path.module}/files/flux-values.yml")]

#  set {
#    name  = "ssh.known_hosts"
#    value = module.ssh_keyscan.ssh_host_keys
#  }

  set {
    name  = "git.pollInterval"
    value = "1m"
  }

  set {
    name  = "git.url"
    value = data.github_repository.flux.git_clone_url
  }

#  set {
#    name  = "git.branch"
#    value = var.flux_git_branch
#  }

  set {
    name  = "git.path"
    value = var.flux_git_path
  }

#  set {
#    name  = "git.label"
#    value = var.cluster_name
#  }

  set {
    name  = "git.secretName"
    value = kubernetes_secret.flux_deploy_key.metadata.0.name
  }

#  set {
#    name  = "rbac.create"
#    value = "true"
#  }

#  set {
#    name  = "syncGarbageCollection.enabled"
#    value = "true"
#  }

  set {
    name  = "manifestGeneration"
    value = "true"
  }
}

resource "kubernetes_secret" "flux_helm_repositories" {
  metadata {
    name      = "flux-helm-repositories"
    namespace = kubernetes_namespace.flux.id
  }

  data = {
    "repositories.yaml" = file("${path.module}/files/flux-helm-repositories.yml")
  }

  type = "Opaque"
}


resource "helm_release" "flux_helm_operator" {
  name       = "flux-helm-operator"
  namespace  = kubernetes_namespace.flux.id
  repository = "https://charts.fluxcd.io"
  chart      = "helm-operator"
  version    = var.flux_helm_operator_version

  set {
    name  = "helm.versions"
    value = "v3"
  }

  set {
    name  = "configureRepositories.enable"
    value = "true"
  }

  set {
    name  = "configureRepositories.secretName"
    value = kubernetes_secret.flux_helm_repositories.metadata.0.name
  }
}