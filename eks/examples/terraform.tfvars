  application = "portal"
  #environment = "dev"
  cluster_name = "cicd-k8s-portal-dev-cluster"
  kms_key_description                  = "eks kms key for portal dev"
  kms_key_name                         = "alias/eks-k8s-portal-dev-key"
  eks_iam_name                         = "eks-cluster_iam"
  cluster_version                      = 1.24
  #cluster_security_group_id            = ["sg-05da0d244115f75a7","sg-031be73e56a0b187b"]
  cluster_subnets                      = ["subnet-0c692fa6f06622f44", "subnet-07e55a41778893fae"]
  cluster_endpoint_private_access      = false
  cluster_endpoint_public_access       = true
  cluster_encryptionkey_arn             = "arn:aws:kms:us-east-1:807526805131:key/2ccd2e3d-5e30-40ae-a9ce-191a1b727f7e"
  #security_group_id                     = ["sg-03e7ea2af3e3bc976"]
  fargate_profilename  = "portal-dev-eks-fargate-profile"
  fargate_profile_subnets =    ["subnet-0c692fa6f06622f44", "subnet-07e55a41778893fae"] //["subnet-0a2986bceba85aa6c"]
  fargate_profile_iam      =  "my-fargate-execution-role2"
  sg_name                  = "eks-portal-securitygroup"
  sg_description           = "security group for eks"
  vpc_id                   = "vpc-0082290a201c78b7b"
  cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]

  ingress_rules = ["https-443-tcp"]

  ingress_cidr_blocks = ["10.162.48.0/21"]

/*
  ingress_with_cidr_blocks = [
    {
      cidr_blocks = "10.162.48.0/21",
      description = "Allow SSH access",
      from_port = 22,
      to_port = 22,
      protocol = "tcp"
    },
    {
      cidr_blocks = "10.162.48.0/21",
      description = "Allow HTTP access",
      from_port = 80,
      to_port = 80,
      protocol = "tcp"
    }
  ]
*/
  egress_cidr_blocks  = ["0.0.0.0/0"]

  egress_with_cidr_blocks =  [
    {
      rule        = "allow_https"
      cidr_blocks = "0.0.0.0/0"
      description = "Allow HTTPS traffic"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
    }
  ]


  # egress_with_cidr_blocks = [
  #   {
  #    # rule        = "allow all"
  #     cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]
  #     # description = "Allow all egress traffic"
  #     from_port   = null
  #     to_port     = null
  #     protocol    = null
  #   },
  #   {
  #    # rule        = "allow htt"
  #     cidr_blocks = ["0.0.0.0/0"]
  #    # description = "Allow HTTPS traffic"
  #     from_port   = 443
  #     to_port     = 443
  #     protocol    = "tcp"
  #   }
  # ]


#############  HELM ###########

  # myparameter_name = "myclusternamestore"
  # cluster_name = "cicd-k8s-portal-dev-cluster"
   chartversion = "5.19.14"
   chart_name = "argo-cd"
   repourl = "https://argoproj.github.io/argo-helm"
   create_namespace = "argocd"
   chart_namespace = "argocd"
   helm_release_name = "argocd" 