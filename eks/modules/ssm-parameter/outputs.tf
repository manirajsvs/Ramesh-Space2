
# output "ssm_parameter_outputvalue" {
#   description = "parameter store value"
#   value       = aws_ssm_parameter.myparameter[each.key]
# }

# output "ssm_parameter_outputname" {
#   description = "parameter store name"
#   value       = aws_ssm_parameter.myparameter.name
# }

# output "ssm_parameter_outputvalue" {
#   value       = aws_ssm_parameter.myparameter["name"]
# }

output "ssm_parameter_outputvalue" {
  description = "parameter store value"
  value       = aws_ssm_parameter.myparameter["myclusternamestore"]
 # sensitive   = true
}

# output "ssm_parameter_outputvalue" {
#   description = "parameter store value"
#   value       = aws_ssm_parameter.myparameter["myclusternamestore"]
#  # sensitive   = true
# }