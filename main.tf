

provider "aws" {
  region = var.main_region
}
variable "github_token"{
type=string
description="github token"
}

module "pipeline" {
  source = "./modules/pipeline"
 github_token=var.github_token
}

