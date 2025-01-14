# include root configuration, holds components and configurations shared across all modules
include "root" {
  path   = find_in_parent_folders()
  expose = true
}


# include common configurations and expose the values to be able to reference them in this configuration
include "accounts" {
  path   = "${dirname(find_in_parent_folders())}/_envcommon/accounts.hcl"
  expose = true
}

include "websites" {
  path   = "${dirname(find_in_parent_folders())}/_envcommon/websites.hcl"
  expose = true
}


# source the terraform module
terraform {
  source = "../../../../modules/web-hosting"
}

# construct local variables
locals {
  tags = merge(include.root.inputs.tags, { Project = "Website Hosting" })
}


# override providers to include aliased provider for network resource deployment
generate "provider_override" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${include.root.locals.aws_region}"

  # Only these AWS Account IDs may be operated on by this template
  allowed_account_ids = ["${include.root.locals.account_id}"]
  assume_role {
    role_arn = "${include.root.locals.assume_role}"
  }
}


provider "aws" {
  region = "${include.root.locals.aws_region}"
  alias = "network"

  # Only these AWS Account IDs may be operated on by this template
  allowed_account_ids = ["${include.accounts.locals.network_account.account_id}"]
  assume_role {
    role_arn = "${include.accounts.locals.network_account.assume_role}"
  }
}
EOF
}

# override inputs from the root and add additional inputs to the module
inputs = {
  sites = include.websites.locals.sites
  tags  = local.tags
}
