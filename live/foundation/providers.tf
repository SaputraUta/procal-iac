provider "aws" {
  region = "ap-southeast-1"

  default_tags {
    tags = {
      Project   = "procal-iac"
      ManagedBy = "OpenTofu"
      Owner     = "uta"
    }
  }
}