data "aws_caller_identity" "current" {}

provider "aws" {
  region = "us-east-1"
} 

module "eks_cluster" {
   source                               = "./../modules/eksmodule"
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
      {
        namespace = "argocd"
      },
    #   {
    #     namespace = "${var.application}"
    #   },
      {
        namespace = "kube-system"
      } ,
      {
        namespace = "default"
      }
    ]
}
