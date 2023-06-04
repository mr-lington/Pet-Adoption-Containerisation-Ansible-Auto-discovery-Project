terraform {
  backend "s3" {
    bucket  = "lington-project-bucket"
    key     = "lington/production/terraform.tfstate"
    region  = "eu-west-2"
    profile = "lington"
  }
}