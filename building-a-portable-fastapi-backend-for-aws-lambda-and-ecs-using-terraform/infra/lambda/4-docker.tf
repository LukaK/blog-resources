module "docker_build_lambda" {
  source  = "terraform-aws-modules/lambda/aws//modules/docker-build"
  version = "7.20.2"

  create_ecr_repo = true
  ecr_repo        = "${random_pet.this.id}-lambda"

  use_image_tag = true
  image_tag     = "0.1"

  source_path      = var.docker_source_path
  docker_file_path = var.docker_file_path
}

resource "random_pet" "this" {
  length = 2
}
