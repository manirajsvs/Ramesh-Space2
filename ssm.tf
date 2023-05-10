/*resource "aws_ssm_parameter" "myparameter" {
  name        = var.ssm_parameter_name
  description = var.ssm_parameter_description
  tier        = "Standard"
  type        = var.ssm_parameter_valuetype
  value       = var.ssm_parameter_value
  data_type = "text"
  tags = var.ssm_parameter_tags
}*/
locals {
  #enabled                       = module.this.enabled
  parameter_write               = var.enabled && ! var.ignore_value_changes ? { for e in var.parameter_write : e.name => merge(var.parameter_write_defaults, e) } : {}
  #parameter_write                = module.eks_cluster.enabled && ! module.eks_cluster.ignore_value_changes ? { for e in module.eks_cluster.parameter_write : e.name => merge(module.eks_cluster.parameter_write_defaults, e) } : {}
  #parameter_write_ignore_values = var.enabled && var.ignore_value_changes ? { for e in var.parameter_write : e.name => merge(var.parameter_write_defaults, e) } : {}
  #parameter_read                = local.enabled ? var.parameter_read : []
}


resource "aws_ssm_parameter" "myparameter" {
  for_each = local.parameter_write
  name     = each.key

  description     = each.value.description
  type            = each.value.type
  tier            = each.value.tier
  #key_id          = each.value.type == "SecureString" && length(var.kms_arn) > 0 ? var.kms_arn : ""
  value           = each.value.value
  #overwrite       = each.value.overwrite
  #allowed_pattern = each.value.allowed_pattern
  data_type       = each.value.data_type

  #tags = module.this.tags
}