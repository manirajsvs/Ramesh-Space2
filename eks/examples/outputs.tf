data "aws_eks_cluster_auth" "mycluster" {
  name = module.eks_cluster.cluster_name
}

data "template_file" "kubeconfig" {
  template = "${data.aws_eks_cluster_auth.mycluster.token}"
}

output "cluster_name" {
  value = module.eks_cluster.cluster_name
}

output "kubeconfig" {
  value = data.template_file.kubeconfig.rendered
}

# output "kubeconfig" {
#   value = data.aws_eks_cluster_auth.mycluster.kubeconfig
# }

output "endpoint" {
  value = module.eks_cluster.endpoint
}

# output "ssm_parameter_outputvalue" {
#   description = "parameter store name"
#   value       = module.ssm.ssm_parameter_outputvalue
# }