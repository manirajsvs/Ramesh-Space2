data "aws_eks_cluster_auth" "mycluster" {
  name = aws_eks_cluster.mycluster.name
}

data "template_file" "kubeconfig" {
  template = "${data.aws_eks_cluster_auth.mycluster.token}"
}

output "cluster_name" {
  value = aws_eks_cluster.mycluster.name
}

output "kubeconfig_token" {
  value = data.template_file.kubeconfig.rendered
}

output "endpoint" {
  value = aws_eks_cluster.mycluster.endpoint
}

output "clustercert" {
  value = aws_eks_cluster.mycluster.certificate_authority[0].data
}

