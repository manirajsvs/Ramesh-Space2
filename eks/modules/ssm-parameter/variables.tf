/*variable "ssm_parameter_name" {
  
}

variable "ssm_parameter_description" {
  
}

variable "ssm_parameter_value" {
  type = any
}

variable "ssm_parameter_valuetype" {
  
}

variable "ssm_parameter_tags" {
    type = map
}
*/

variable "parameter_write" {
  type        = list(map(string))
  description = "List of maps with the parameter values to write to SSM Parameter Store"
  default     = []
}

variable "parameter_write_defaults" {
  type        = map(any)
  description = "Parameter write default settings"
  default = {
    description     = null
    type            = "SecureString"
    tier            = "Standard"
    overwrite       = null
    value    = null
    allowed_pattern = null
    data_type       = "text"
  }
}

variable "enabled" {
  type        = bool
  default     = true
}

variable "ignore_value_changes" {
  type        = bool
  description = "Whether to ignore future external changes in paramater values"
  default     = false
}