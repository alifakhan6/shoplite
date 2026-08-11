terraform {
  required_version = ">= 1.6.0"

  required_providers {
    kind = {
      source  = "tehcyx/kind"
      version = "~> 0.8"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.17"
    }
  }
}

provider "kind" {}

provider "helm" {
  kubernetes {
    config_path = module.kind_cluster.kubeconfig_path
  }
}

module "kind_cluster" {
  source = "./modules/kind-cluster"

  cluster_name = "shoplite"
}

module "ingress_controller" {
  source = "./modules/ingress-controller"

  depends_on = [
    module.kind_cluster
  ]
}
