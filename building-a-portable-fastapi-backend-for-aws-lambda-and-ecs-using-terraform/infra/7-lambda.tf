module "lambda_api" {
  source = "./lambda"

  docker_file_path   = "test-api/dockerfiles/lambda.Dockerfile"
  docker_source_path = ".."
}
