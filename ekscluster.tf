# provider "aws" {
#   region = "us-east-1"
# }
/*
provider "kubernetes" {
   host                   = aws_eks_cluster.mycluster.endpoint
  # region = "us-east-1"
   cluster_ca_certificate = base64decode(aws_eks_cluster.mycluster.certificate_authority[0].data)
   exec {
     api_version = "client.authentication.k8s.io/v1beta1"
     command     = "aws"
     # This requires the awscli to be installed locally where Terraform is executed
     args = ["eks", "get-token", "--cluster-name", aws_eks_cluster.mycluster.id]
   }
 } */

# data "aws_eks_cluster" "mycluster" {
#   name = aws_eks_cluster.mycluster.name
# }

# data "aws_eks_cluster_auth" "mycluster" {
#   name = aws_eks_cluster.mycluster.name
# }

# locals {
#   kubeconfig_file = "kubeconfig_${aws_eks_cluster.mycluster.name}.yaml"
# }

# resource "null_resource" "generate_kubeconfig" {
#   provisioner "local-exec" {
#     command = "aws eks update-kubeconfig --name ${data.aws_eks_cluster.mycluster.name} --kubeconfig ${local.kubeconfig_file}"
#   }
#   depends_on = [aws_eks_cluster.mycluster]
# }

# # output "kubeconfig" {
# #   value = file(local.kubeconfig_file)
# # }

# output "kubeconfig" {
#   value = file("${path.module}/${local.kubeconfig_file}")
# }

resource "aws_eks_cluster" "mycluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster.arn
  version                   = var.cluster_version
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler" ]
  depends_on = [aws_security_group.create_sg]

  vpc_config {
    #cluster_security_group_id      = aws_security_group.create_sg.id
       #cluster_security_group_id            = var.cluster_security_group_id
       #security_group_ids      = var.cluster_security_group_id
       security_group_ids = var.cluster_security_group_id == null ? [data.aws_security_group.mysg.id] : var.cluster_security_group_id 
       #security_group_ids      = var.cluster_security_group_id == null ? data.aws_security_group.mysg.id : var.cluster_security_group_id
#subnet_ids = var.subnet_ids == null ? data.aws_subnets.private.ids : var.cluster_subnets   #The value is determined by a conditional expression that checks if the var.subnet_ids variable is null. If it is null, the value of subnets_ids is set to the list of IDs of private subnets retrieved using the data.aws_subnets.private.ids data source. Otherwise, the value of subnets_ids is set to the value of var.subnet_ids
    subnet_ids              = var.cluster_subnets
    endpoint_private_access = var.cluster_endpoint_private_access
    endpoint_public_access  = var.cluster_endpoint_public_access
    public_access_cidrs     = var.cluster_endpoint_public_access_cidrs
  }


  kubernetes_network_config {

   # ip_family = "ipv4"
  }

  encryption_config {
    provider {
      key_arn = aws_kms_key.eks.arn
    }
    resources = ["secrets"]
  }
/*
  cluster_encryption_config {
    resources {
      secrets {
        key_arn = aws_kms_key.eks.arn
      }
    }
  } */

  #cluster_encryptionkey_arn = 

  tags = var.eks_tags

}

############  Nexus #################################
# Configure the AWS provider
# provider "aws" {
#   region = "us-east-1"
# }

# Configure the Kubernetes provider
# provider "kubernetes" {
#   host                   = module.eks_cluster.cluster_endpoint
#   cluster_ca_certificate = base64decode(module.eks_cluster.cluster_ca_certificate)
#   token                  = module.eks_cluster.cluster_token
# }

 #####  Deploy Nexus Artifactory to the EKS cluster
# resource "kubernetes_namespace" "nexus" {
#   metadata {
#     name = "nexus"
#   }
# }



# Provision an EC2 instance
resource "aws_instance" "example" {
  ami           = "ami-007855ac798b5175e"
  instance_type = "t2.micro"
  #key_name      = "my-key-pair"
  vpc_security_group_ids = [aws_security_group.example.id]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    #private_key = file("~/.ssh/my-key-pair.pem")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      # Install Java and other dependencies
      "sudo apt-get update",
      "sudo apt-get install -y openjdk-8-jdk wget",

      # Download and install Nexus Artifactory
      "cd /tmp",
      "wget https://download.sonatype.com/nexus/3/latest-unix.tar.gz",
      "tar -xvf latest-unix.tar.gz",
      "sudo mv nexus-* /opt/nexus",
      "sudo adduser nexus",
      "sudo chown -R nexus:nexus /opt/nexus",
      "sudo sed -i 's/#run_as_user/run_as_user/g' /opt/nexus/bin/nexus.vmoptions",
      "sudo ln -s /opt/nexus/bin/nexus /etc/init.d/nexus",
      "sudo update-rc.d nexus defaults",

      # Start Nexus Artifactory
      "sudo service nexus start"
    ]
  }
}

# Define a security group to allow SSH and HTTP traffic
resource "aws_security_group" "example" {
  name_prefix = "example-sg-"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# provider "artifactory" {
#   url         = "https://artifactory.example.com"
#   username    = "admin"
#   password    = "s3cr3t"
#   ssl_cert    = "/path/to/certificate.pem"
#   ssl_key     = "/path/to/private_key.pem"
#   ssl_ca_cert = "/path/to/ca_certificate.pem"
# }

/*
resource "kubernetes_deployment" "tfnexus" {
  metadata {
    name = "terraformnexus"
    namespace = "kube-system"
    labels = {
      app = "nexus"
    }
  }

  spec {
    replicas = 2
    
    selector {
      match_labels = {
        app = "nexus"
      }
    }

    template {
      metadata {
        labels = {
          app = "nexus"
        }
      }

      spec {
        container {
          name = "nexus"
          image = "sonatype/nexus3:latest"
          port {
            container_port = 8081
          }
          volume_mount {
            name       = "nexus-data"
            mount_path = "/nexus-data"
          }
          env {
            name  = "NEXUS_SECURITY_RANDOMPASSWORD"
            value = "false"
          }
          env {
            name  = "NEXUS_CONTEXT"
            value = "/nexus"
          }
          env {
            name  = "NEXUS_SECURITY_REALM"
            value = "NexusAuthenticatingRealm"
          }
          env {
            name  = "NEXUS_SECURITY_PROVIDER"
            value = "FileAuthenticationProvider"
          }
        }

        volume {
          name = "nexus-data"
          empty_dir {}
        }
      }
    }
  }
}

*/

/*
resource "kubernetes_deployment" "nexus" {
  metadata {
    name = "tfenexus"
    namespace = "kube-system"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "nexus-server"
      }
    }

    template {
      metadata {
        labels = {
          app = "nexus-server"
        }
      }

      spec {
        container {
          name  = "nexus"
          image = "sonatype/nexus3:latest"

          resources {
            limits = {
              memory = "4Gi"
              cpu    = "1000m"
            }
            requests = {
              memory = "2Gi"
              cpu    = "500m"
            }
          }

          port {
            container_port = 8081
          }

          volume_mount {
            name       = "nexus-data"
            mount_path = "/nexus-data"
          }
        }

        volume {
          name = "nexus-data"
          empty_dir {}
        }
      }
    }
  }
}

# Expose the Nexus service to the internet
resource "kubernetes_service" "nexus" {
  metadata {
    name = "nexus"
    namespace = "kube-system"
  }

  spec {
    selector = {
      app = "nexus"
    }

    port {
      name = "http"
      port = 8081
      target_port = 8081
    }

    type = "LoadBalancer"
  }
}
*/
# Create a Helm repository in Nexus
# provider "artifactory" {
#   url  = "https://nexus.example.com"
#   user = "admin"
#   password = "mypassword"
# }

# resource "artifactory_local_repository" "helm" {
#   key = "helm"
#   package_type = "helm"
#   repository_layout = "simple-default"
#   description = "Local Helm repository"
#   notes = "This repository is managed by Terraform"
# }

resource "kubernetes_cluster_role" "cluster_role" {
  metadata {
    name = "eks-console-dashboard-full-access-clusterrole"
    annotations      = {}
    labels           = {}
  }
  rule {
    api_groups = [""]
    resources = [""]
    verbs = ["get", "list", "watch", "create", "update", "patch", "delete"]
    non_resource_urls = []
    resource_names    = []
  }
  depends_on = [aws_eks_cluster.mycluster]
}
resource "kubernetes_cluster_role_binding" "cluster_role_binding" {
  metadata {
    name = "eks-console-dashboard-full-access-binding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.cluster_role.metadata[0].name
  }
  subject {
    kind      = "Group"
    name      = "eks-console-dashboard-full-access-group"
    api_group = "rbac.authorization.k8s.io"
  }
  depends_on = [aws_eks_cluster.mycluster]
}

resource "kubernetes_config_map" "aws_auth" {

  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }
  depends_on = [aws_eks_cluster.mycluster]
    lifecycle {
    # We are ignoring the data here since we will manage it with the resource below
    # This is only intended to be used in scenarios where the configmap does not exist
    ignore_changes = [data]
  }
}

resource "kubernetes_config_map_v1_data" "aws_auth" {  
  force = true                                         
  metadata {                                           
    name      = "aws-auth"                             
    namespace = "kube-system"                          
  }                                                    
                                                       
  data = {                                             
    mapRoles = yamlencode(var.map_roles)               
    mapUsers    = yamlencode(var.map_users)            
    mapAccounts = yamlencode(var.map_accounts)         
  }   
  depends_on = [aws_eks_cluster.mycluster, kubernetes_config_map.aws_auth]                                                 
}

/*
resource "null_resource" "wait_for_fargate_profile_deletion" {
  provisioner "local-exec" {
    command = "until [[ \"$(aws eks describe-fargate-profile --cluster-name ${var.cluster_name} --fargate-profile-name ${var.fargate_profilename} --query 'fargateProfile.status' --output text)\" == 'INACTIVE' ]]; do sleep 10; done"
  }

  depends_on = [
    aws_eks_cluster.mycluster,
    aws_eks_fargate_profile.fargate-profile,
  ]

  count = var.wait_for_fargate_profile_deletion ? 1 : 0
}
*/

# # Attach the necessary policies to the instance profile
# resource "aws_iam_instance_profile_policy_attachment" "eks_worker_nodes" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
#   role       = aws_iam_instance_profile.eks_worker_nodes.name
# }

# # Get the latest EKS worker node AMI ID
# data "aws_ami" "eks_worker" {
#   filter {
#     name   = "name"
#     values = ["amazon-eks-node-*"]
#   }

#   most_recent = true
#   owners      = ["853697862182"]
# }

data "aws_security_group" "mysg" {
  id = aws_security_group.create_sg.id
}

output "cluster_status" {
  value = aws_eks_cluster.mycluster.status
}

######### Deleting default coredns ###########
/*
resource "null_resource" "kubectl" {
  provisioner "local-exec" {
    command = "aws eks --region us-east-1 update-kubeconfig --name ${aws_eks_cluster.mycluster.id}"

}
depends_on = [aws_eks_cluster.mycluster]#, kubernetes_config_map.aws_auth, aws_eks_fargate_profile.fargate-profile, kubernetes_config_map_v1_data.aws_auth  ]
}

resource "null_resource" "kubectl1" {
  provisioner "local-exec" {
    command = "kubectl delete deployment coredns -n kube-system"
}
depends_on = [aws_eks_cluster.mycluster, null_resource.kubectl]
}
*/
#########Installing Kubernetes addons

resource "aws_eks_addon" "this" {
  # Not supported on outposts
  for_each = { for k, v in var.cluster_addons : k => v if var.create && !var.create_outposts_local_cluster }

  cluster_name = var.cluster_name
  addon_name   = try(each.value.name, each.key)
  addon_version            = try(each.value.addon_version, null)
  configuration_values     = try(each.value.configuration_values, null)
  preserve                 = try(each.value.preserve, null)
  resolve_conflicts        = try(each.value.resolve_conflicts, "OVERWRITE")
  service_account_role_arn = try(each.value.service_account_role_arn, null)
  #create_timeout = "30m"

  # timeouts {
  #   create = try(each.value.timeouts.create, var.cluster_addons_timeouts.create, null)
  #   update = try(each.value.timeouts.update, var.cluster_addons_timeouts.update, null)
  #   delete = try(each.value.timeouts.delete, var.cluster_addons_timeouts.delete, null)
  # }

  depends_on = [ aws_eks_cluster.mycluster, aws_eks_fargate_profile.fargate-profile /*, null_resource.kubectl, null_resource.kubectl1*/ ]
  
  timeouts {
  create = "5m"
}
}

  # timeouts {
  #   for_each = [var.timeouts]
  #   content {
  #     create = lookup(var.timeouts, "create", null)
  #     delete = lookup(var.timeouts, "delete", null)
  #   }
  # }

# resource "null_resource" "wait_for_addon_steady_state" {
#   for_each = var.addons
  
#   command = "aws eks wait addon-stable --cluster-name ${var.cluster_name} --addon-name --addon-name ${aws_eks_addon.this[each.key].addon_name} --region us-east-1 --timeout ${var.addon_steady_state_timeout}"

#   depends_on = [
#     aws_eks_addon.this,
#   ]
# }
#aws_eks_fargate_profile.this,