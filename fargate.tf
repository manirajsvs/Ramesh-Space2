
# provider "aws" {
#   region = "us-east-1"
# } 

resource "aws_eks_fargate_profile" "fargate-profile" {
  cluster_name           = aws_eks_cluster.mycluster.name
  fargate_profile_name   = var.fargate_profilename
  pod_execution_role_arn = aws_iam_role.fargate_execution.arn
  subnet_ids             = var.fargate_profile_subnets
  depends_on = [ aws_eks_cluster.mycluster, null_resource.wait_for_cluster]

  dynamic "selector" {
    for_each = var.selectors

    content {
      namespace = selector.value.namespace
      labels    = lookup(selector.value, "labels", {})
    }
 
 }

  dynamic "timeouts" {
    for_each = [var.timeouts]
    content {
      create = lookup(var.timeouts, "create", null)
      delete = lookup(var.timeouts, "delete", null)
    }
  }
}
/*
depends_on = [
    aws_eks_cluster.output.cluster_status,
  ] 
 #tags = var.fargate_profile_tags
# Conditional depends_on for Fargate profile deletion
# Only add dependency if wait_for_fargate_profile_deletion is true

  depends_on = [
    var.wait_for_fargate_profile_deletion ? null_resource.fargate_profile_deletion_wait : null,
  ]

}
# Conditional null_resource for Fargate profile deletion
# Only create null_resource if wait_for_fargate_profile_deletion is true
resource "null_resource" "fargate_profile_deletion_wait" {
  count = var.wait_for_fargate_profile_deletion ? 1 : 0
  # ...
}

*/

###### For Linux ########
# resource "null_resource" "wait_for_cluster" {
#   triggers = {
#     cluster_id = aws_eks_cluster.mycluster.id
#   }

#   provisioner "local-exec" {
#     command = "sleep 60"
#   }
# }

######## For Windows ############
resource "null_resource" "wait_for_cluster" {
  triggers = {
    cluster_id = aws_eks_cluster.mycluster.id
  }

  provisioner "local-exec" {
   # command = "timeout /t 60"
    command = "ping 127.0.0.1 -n 61"
  }
}

/* 
# Wait for 60 seconds after the cluster is created
resource "null_resource" "wait_for_cluster" {
  provisioner "local-exec" {
    #depends_on = [aws_eks_cluster.mycluster]
    command = "sleep 60"
  }

  # This resource does not have any dependencies
  # and will run immediately after it is created
  triggers = {
    # Force this resource to run every time
    always_run = timestamp()
  }
}
*/

provider "kubernetes" {
  host                   = aws_eks_cluster.mycluster.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.mycluster.certificate_authority[0].data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", aws_eks_cluster.mycluster.id]
  }
}

data "aws_eks_cluster_auth" "cluster_auth" {
  name = var.cluster_name
}

data "aws_caller_identity" "current" {}
data "aws_availability_zones" "available" {}


# resource "null_resource" "k8s_patcher" {
#   depends_on = [aws_eks_fargate_profile.fargate-profile]

#   triggers = {
#     endpoint = aws_eks_cluster.mycluster.endpoint
#     ca_crt   = base64decode(aws_eks_cluster.mycluster.certificate_authority[0].data)
#     token    = data.aws_eks_cluster_auth.cluster_auth.token
#   }

#   provisioner "local-exec" {
#     command = <<EOH
# cat >/tmp/ca.crt <<EOF
# ${base64decode(aws_eks_cluster.mycluster.certificate_authority[0].data)}
# EOF
# kubectl --server="${aws_eks_cluster.mycluster.endpoint}" --certificate_authority=/tmp/ca.crt  --token="${data.aws_eks_cluster_auth.cluster_auth.token}" patch deployment coredns -n kube-system --type json -p='[{"op": "remove", "path": "/spec/template/metadata/annotations/eks.amazonaws.com~1compute-type"}]'
# EOH
#   }

#   lifecycle {
#     ignore_changes = [triggers]
#   }
# }
