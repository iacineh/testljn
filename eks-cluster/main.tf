provider "aws" {
  region     = "us-east-1"
  # access_key = "ljn"
  # secret_key = "ljn"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}
