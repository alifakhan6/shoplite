terraform {
  required_version = ">= 1.6.0"

  required_providers {
    kind = {
      source  = "tehcyx/kind"
      version = "~> 0.8"
    }
  }
}

provider "kind" {}

module "kind_cluster" {
  source = "./modules/kind-cluster"

  cluster_name = "shoplite"
}
