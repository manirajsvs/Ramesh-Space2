# data "aws_ssm_parameter" "clustername" {
#   name = var.parameterstore_clustername
# }

#  data "aws_eks_cluster" "mycluster" {
#    name = var.cluster_name
#   #depends_on = [aws_eks_cluster.mycluster]
#  }

#   data "aws_eks_cluster_auth" "mycluster1" {
#    name = var.cluster_name
#    #depends_on = [aws_eks_cluster.mycluster]
#  } 

# data "aws_ssm_parameter" "clustername" {
#   name = var.myparameter_name
#   depends_on = [module.eks_cluster.cluster_name]
# }

# data "aws_eks_cluster" "mycluster" {
#   name = var.cluster_name
# }

#  data "aws_eks_cluster_auth" "mycluster1" {
#   name = data.aws_ssm_parameter.clustername.value
# } 

 data "aws_eks_cluster_auth" "mycluster1" {
  name = var.cluster_name
} 

resource "kubernetes_namespace" "argocd" {
  metadata {
    name = var.create_namespace
  }
  depends_on = [data.aws_eks_cluster_auth.mycluster1]
}


# provider "kubernetes" {
#   host                   = data.aws_eks_cluster.mycluster.endpoint
#   cluster_ca_certificate = base64decode(data.aws_eks_cluster.mycluster.certificate_authority[0].data)
#   token                  = data.aws_eks_cluster_auth.mycluster1.token
# }

provider "kubernetes" {
  host                   = data.aws_eks_cluster.mycluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.mycluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.mycluster1.token
}

provider "helm" {
  kubernetes {
  host                   = data.aws_eks_cluster.mycluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.mycluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.mycluster1.token
  }
}

data "aws_availability_zones" "available" {}

# resource "kubernetes_namespace" "argocd" {
#   metadata {
#     name = var.create_namespace
#   }
# }


resource "helm_release" "argocd" {
  depends_on = [
    kubernetes_namespace.argocd
  ]
 # myparameter_name = var.myparameter_name
  #cluster_name = var.cluster_name
  repository = var.repourl
  chart      = var.chart_name
  version    = var.chartversion
  name       = var.helm_release_name
  namespace  = var.chart_namespace
  values = [
    <<EOL
      server:
        replicas: 2
EOL
    ,
  ] 
}
