data "aws_caller_identity" "current" {}

# data "aws_ssm_parameter" "clustername" {
#   name = var.parameterstore_clustername
# }

# data "aws_ssm_parameter" "clustername" {
#   name = var.myparameter_name
#   depends_on = [module.eks_cluster.cluster_name]
# }

# data "aws_eks_cluster" "mycluster" {
#   name = data.aws_ssm_parameter.clustername.value
# }

provider "aws" {
  region = "us-east-1"
} 

module "eks_cluster" {
   source                               = "./../"
   cluster_name                         = var.cluster_name
   kms_key_description                  = var.kms_key_description
   kms_key_name                         = var.kms_key_name
  #cluster_role_arn                     = module.cluster_iam.role_arn
   cluster_version                      = var.cluster_version
  cluster_security_group_id            = var.cluster_security_group_id
  eks_iam_name                         = var.eks_iam_name
   sg_name                  = var.sg_name
  sg_description           = var.sg_description
  vpc_id                   = var.vpc_id
 # ingress_with_cidr_blocks = var.ingress_with_cidr_blocks
  ingress_rules            = var.ingress_rules
  ingress_cidr_blocks      = var.ingress_cidr_blocks
  egress_with_cidr_blocks  = var.egress_with_cidr_blocks
  
  cluster_subnets                      = var.cluster_subnets
   cluster_encryptionkey_arn            = var.cluster_encryptionkey_arn
   cluster_endpoint_private_access      = var.cluster_endpoint_private_access
   cluster_endpoint_public_access       = var.cluster_endpoint_public_access
   cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]
   wait_for_fargate_profile_deletion = true
   kms_policies_list  = [
     {
       type       = "AWS"
       identifier = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
       sid        = "Enable IAM User Permissions"
       actions = [
         "kms:*"
       ]
       resources = ["*"]
       query     = "StringEquals"
       var       = "aws:RequestedRegion"
       reg       = ["us-east-1"]
     },
     {
       type       = "AWS"
       identifier = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
       sid        = "Allow access for all principals in the account that are authorized"
       actions = [
         "kms:*"
       ]
       resources = ["*"]
       query     = "StringEquals"
       var       = "eks.us-east-1.amazonaws.com"
       reg       = ["${data.aws_caller_identity.current.account_id}"]
     },

   ]  
     
    
    #my-fargate-execution-role           = var.-fargate-execution-role1
    fargate_profilename                  = var.fargate_profilename 
    fargate_profile_subnets              = var.fargate_profile_subnets
    fargate_profile_iam                  = var.fargate_profile_iam
   selectors = [
    #   {
    #     namespace = "github-runner"
    #  },
    #   {
    #     namespace = "argocd"
    #   },
    #   {
    #     namespace = "${var.application}"
    #   },
      {
        namespace = "kube-system"
      } #,
      # {
      #   namespace = "default"
      # }
    ]

  #     cluster_addons = {
  #     kube-proxy = {
  #     most_recent = true
  #     preserve    = true
  #     },
  #      vpc-cni = {
  #     most_recent = true
  #     } #, 
  #     coredns = {
  #       configuration_values = jsonencode({
  #         computeType = "Fargate"
  #       # Ensure that the we fully utilize the minimum amount of resources that are supplied by
  #       # Fargate https://docs.aws.amazon.com/eks/latest/userguide/fargate-pod-configuration.html
  #       # Fargate adds 256 MB to each pod's memory reservation for the required Kubernetes
  #       # components (kubelet, kube-proxy, and containerd). Fargate rounds up to the following
  #       # compute configuration that most closely matches the sum of vCPU and memory requests in
  #       # order to ensure pods always have the resources that they need to run.
  #         resources = {
  #          limits = {
  #             cpu = "0.25"
  #           # We are targetting the smallest Task size of 512Mb, so we subtract 256Mb from the
  #           # request/limit to ensure we can fit within that task
  #            memory = "256M"
  #          }
  #           requests = {
  #             cpu = "0.25"
  #           # We are targetting the smallest Task size of 512Mb, so we subtract 256Mb from the
  #           # request/limit to ensure we can fit within that task
  #             memory = "256M"
  #            }
  #           }
  #       })  
  #     most_recent = true
  #     } 
  # } 
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

# Deploy Nexus Artifactory to the EKS cluster
# resource "kubernetes_namespace" "nexus" {
#   metadata {
#     name = "nexus"
#   }
# }


# resource "kubernetes_deployment" "nexus" {
#   metadata {
#     name = "nexus"
#     #namespace = kube-system
#     labels = {
#       app = "nexus"
#     }
#   }

#   spec {
#     selector {
#       match_labels = {
#         app = "nexus"
#       }
#     }

#     template {
#       metadata {
#         labels = {
#           app = "nexus"
#         }
#       }

#       spec {
#         container {
#           name = "nexus"
#           image = "sonatype/nexus3:latest"
#           port {
#             container_port = 8081
#           }
#           volume_mount {
#             name       = "nexus-data"
#             mount_path = "/nexus-data"
#           }
#           env {
#             name  = "NEXUS_SECURITY_RANDOMPASSWORD"
#             value = "false"
#           }
#           env {
#             name  = "NEXUS_CONTEXT"
#             value = "/nexus"
#           }
#           env {
#             name  = "NEXUS_SECURITY_REALM"
#             value = "NexusAuthenticatingRealm"
#           }
#           env {
#             name  = "NEXUS_SECURITY_PROVIDER"
#             value = "FileAuthenticationProvider"
#           }
#         }

#         volume {
#           name = "nexus-data"
#           empty_dir {}
#         }
#       }
#     }
#   }
# }

# # Expose the Nexus service to the internet
# resource "kubernetes_service" "nexus" {
#   metadata {
#     name = "nexus"
#     #namespace = kube-system
#   }

#   spec {
#     selector = {
#       app = "nexus"
#     }

#     port {
#       name = "http"
#       port = 8081
#       target_port = 8081
#     }

#     type = "LoadBalancer"
#   }
# }

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




/*
# Configure the AWS provider
provider "aws" {
  region = "us-west-2"
}

# Provision an EC2 instance
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  key_name      = "my-key-pair"
  vpc_security_group_ids = [aws_security_group.example.id]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/my-key-pair.pem")
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

provider "artifactory" {
  url         = "https://artifactory.example.com"
  username    = "admin"
  password    = "s3cr3t"
  ssl_cert    = "/path/to/certificate.pem"
  ssl_key     = "/path/to/private_key.pem"
  ssl_ca_cert = "/path/to/ca_certificate.pem"
}


module "nexus_antifactory" {
  source = "terraform-aws-modules/helm/aws"

  release_name      = "nexus-antifactory"
  chart_name        = "nexus-antifactory"
  chart_version     = "1.0.0"
  namespace         = "default"
  repository_url    = "https://nexus.example.com/repository/helm"
  repository_auth   = {
    username = "admin"
    password = "password"
  }
  values = [
    {
      name  = "nexusUrl"
      value = "https://nexus.example.com"
    },
    {
      name  = "nexusUsername"
      value = "admin"
    },
    {
      name  = "nexusPassword"
      value = "password"
    },
  ]
}


# Configure the AWS provider
provider "aws" {
  region = "us-west-2"
}

# Provision the EKS cluster
module "eks" {
  source = "terraform-aws-modules/eks/aws"
  
  cluster_name = "example-eks"
  subnets      = ["subnet-0123456789abcdef", "subnet-0123456789abcdef"]
  
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

# Configure the Kubernetes provider
provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_ca_certificate)
  token                  = module.eks.cluster_token
}

# Deploy Nexus Artifactory to the EKS cluster
resource "kubernetes_namespace" "nexus" {
  metadata {
    name = "nexus"
  }
}

resource "helm_release" "nexus" {
  name       = "nexus"
  repository = "https://nexus.example.com/repository/helm"
  chart      = "nexus"
  namespace  = kubernetes_namespace.nexus.metadata[0].name

  set {
    name  = "nexus.securityContext.enabled"
    value = "false"
  }
}

# Create a Helm repository in Nexus
provider "artifactory" {
  url  = "https://nexus.example.com"
  user = "admin"
  password = "mypassword"
}

resource "artifactory_local_repository" "helm" {
  key = "helm"
  package_type = "helm"
  repository_layout = "simple-default"
  description = "Local Helm repository"
  notes = "This repository is managed by Terraform"
}

*/
   #depends_on = [null_resource.wait_for_eks_cluster,]
  # enabled                  = true
  # ignore_value_changes     = false
  # parameter_write          = [ 
  # #   {
  # #   parameter1 = {
  # #     description = "This is parameter 1"
  # #     type        = "String"
  # #     tier        = "Standard"
  # #     value       = "myvalue1"
  # #     data_type   = "text"
  # #   },
  # #   parameter2 = {
  # #     description = "This is parameter 2"
  # #     type        = "String"
  # #     tier        = "Advanced"
  # #     value       = "myvalue2"
  # #     data_type   = "text"
  # #   }
  # # }
  # ]
  # parameter_write_defaults = {
  #   type            = "SecureString"
  #   tier            = "Standard"
  #   overwrite       = null
  #   value           = null
  #   allowed_pattern = null
  #   data_type       = "text"
  # }     
#   parameter_write = [
#   {
#     name      = var.clusterendpoint_store
#     value     = module.eks_cluster.endpoint
#     tier      = "Standard"
#     description = "cicd eks cluster endpoint"
#     data_type   = "text"
#   },
#   {
#     name      = var.clustername_store
#     value     = module.eks_cluster.clustername
#     tier      = "Standard"
#     description = "cicd eks cluster name"
#     data_type   = "text"
#   },
#     {
#     name      = var.clustercert_store
#     value     = module.eks_cluster.clustercert
#     tier      = "Standard"
#     description = "cicd eks cluster cert store"
#     data_type   = "text"
#   } 
# ]
#}

# module "ssm" {
#   source = "./../modules/ssm-parameter"
#  # depends_on = [module.eks_cluster]
#   #requires  = [module.eks_cluster]
#  # ssm_parameter_outputname = output.ssm_parameter_outputvalue
#   parameter_write = [
#   {
#     name      = var.clusterendpoint_store
#     value     = module.eks_cluster.endpoint
#     tier      = "Standard"
#     description = "cicd eks cluster endpoint"
#     data_type   = "text"
#   },
#   {
#     name      = var.clustername_store
#     value     = module.eks_cluster.cluster_name
#     tier      = "Standard"
#     description = "cicd eks cluster name"
#     data_type   = "text"
#   },
#     {
#     name      = var.clustercert_store
#     value     = module.eks_cluster.clustercert
#     tier      = "Standard"
#     description = "cicd eks cluster cert store"
#     data_type   = "text"
#   } 
# ]
# }


#  module "helm_release" {
#    source   = "./../modules/argocd"
#   # depends_on = [module.ssm]
#  # parameterstore_clustername = var.parameterstore_clustername
#   #myparameter_name = var.myparameter_name
#  # myparameter_name = module.ssm.ssm_parameter_outputvalue
#   cluster_name = tostring(module.ssm.ssm_parameter_outputvalue.value)
#   chartversion = var.chartversion
#   chart_name = var.chart_name
#   repourl = var.repourl
#   create_namespace = var.create_namespace
#   chart_namespace = var.chart_namespace
#   helm_release_name = var.helm_release_name
#  }
