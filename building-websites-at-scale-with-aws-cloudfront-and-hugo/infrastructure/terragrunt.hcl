locals {
  # Automatically load account-level variables
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))

  # Extract the variables we need for easy access
  account_name = local.account_vars.locals.account_name
  account_id   = local.account_vars.locals.account_id
  assume_role  = local.account_vars.locals.assume_role
  aws_region   = local.region_vars.locals.aws_region
  environment  = local.environment_vars.locals.environment

  # Default tags
  tags = {
    Environment = local.environment
    Region      = local.aws_region
  }
}

# Generate default AWS provider block
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.aws_region}"

  # Only these AWS Account IDs may be operated on by this template
  allowed_account_ids = ["${local.account_id}"]
  assume_role {
    role_arn = "${local.assume_role}"
  }
}
EOF
}

# Configure Terragrunt to automatically store tfstate files in an S3 bucket
remote_state {
  backend = "s3"
  config = {
    encrypt               = true
    bucket                = "BUCKET NAME"
    key                   = "${path_relative_to_include()}/${local.environment}/tf.tfstate"
    region                = "eu-west-1"
    dynamodb_table        = "tf-state-table"
    disable_bucket_update = true
  }
  generate = {
    path      = "backend.tf"
    if_exists = "skip"
  }
}

# Configure root level variables that all resources can inherit.
# This is especially helpful with multi-account configs where terraform_remote_state data sources are placed directly into the modules.
# These variables apply to all configurations in this subfolder and are automatically merged into the child `terragrunt.hcl` config via the include block
inputs = merge(
  local.account_vars.locals,
  local.region_vars.locals,
  local.environment_vars.locals,
  { tags = local.tags },
)
