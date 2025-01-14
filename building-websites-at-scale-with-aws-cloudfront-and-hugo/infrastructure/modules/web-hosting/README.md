<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.70 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_site"></a> [site](#module\_site) | ./single-site/ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_primary_zone_ns_record_type"></a> [primary\_zone\_ns\_record\_type](#input\_primary\_zone\_ns\_record\_type) | Primary zone record type for name servers | `string` | `"NS"` | no |
| <a name="input_primary_zone_record_ttl"></a> [primary\_zone\_record\_ttl](#input\_primary\_zone\_record\_ttl) | Time to live for the dns record | `number` | `172800` | no |
| <a name="input_sites"></a> [sites](#input\_sites) | Sites configuration | <pre>list(object(<br/>    {<br/>      site_name                = string<br/>      domain_name              = string<br/>      primary_zone_id          = string<br/>      primary_zone_record_name = string<br/>    }<br/>  ))</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_content_buckets"></a> [content\_buckets](#output\_content\_buckets) | Lookup map of sites with content bucket names |
<!-- END_TF_DOCS -->
