# ## Cluster IAM  ##
# variable "cluster_iam_name" {
#   type = string
# }
# variable "cluster_trusted_entities_list" {
#   type    = list(any)
#   default = []
# }
# variable "cluster_managed_policy_arns" {
#   type    = list(any)
#   default = []
# }
# variable "cluster_inline_policy_name" {
#   default = "inline_policy_default"
# }
# variable "cluster_inline_policies_list" {
#   type    = list(any)
#   default = []
# }
# ##  Pod IAM  ##
# variable "pod_iam_name" {
#   type = string
# }

# variable "pod_trusted_entities_list" {
#   type    = list(any)
#   default = []
# }

# variable "pod_managed_policy_arns" {
#   type    = list(any)
#   default = []
# }
# variable "pod_inline_policy_name" {
#   default = "inline_policy_default"
# }
# variable "pod_inline_policies_list" {
#   type    = list(any)
#   default = []
# }


#######  SG  ########

variable "sg_name" {
  type = string
}

variable "sg_description" {
  type = string
}
variable "vpc_id" {
  type = string
}

variable "egress_with_cidr_blocks" {
  type = list(object({
    cidr_blocks = string,
    description = string,
    from_port = number,
    to_port = number,
    protocol = string
  }))
  default = [  ]
}



variable "ingress_cidr_blocks" {
  description = "List of ingress rules to create where 'cidr_blocks' is used"
  type        = list(string)
  default     = []
}

variable "egress_cidr_blocks" {
  description = "List of ingress rules to create where 'cidr_blocks' is used"
  type        = list(string)
  default     = []
}

variable "ingress_with_cidr_blocks" {
  type = list(object({
    cidr_blocks = string,
    description = string,
    from_port = number,
    to_port = number,
    protocol = string
  }))
  default = [
  ]
}

variable "ingress_rules" {
  description = "List of computed ingress rules to create by name"
  type        = list(string)
  default     = []
}

# variable "ingress_with_cidr_blocks" {
#   description = "List of ingress rules to create where 'cidr_blocks' is used"
#   type        = list(map(string))
#   default     = []
# }

# variable "egress_with_cidr_blocks" {
#   description = "List of egress rules to create where 'cidr_blocks' is used"
#   type        = list(map(string))
#   default     = []
# }

# variable "egress_with_cidr_blocks" {
#   type = list(object({
#     rule        = string
#     cidr_blocks = string
#     description = string
#     from_port   = number
#     to_port     = number
#     protocol    = string
#   }))
#   default = [
#     {
#       rule        = "allow_all"
#       cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]
#       description = "Allow all egress traffic"
#       from_port   = null
#       to_port     = null
#       protocol    = null
#     },
#     {
#       rule        = "allow_https"
#       cidr_blocks = ["0.0.0.0/0"]
#       description = "Allow HTTPS traffic"
#       from_port   = 443
#       to_port     = 443
#       protocol    = "tcp"
#     }
#   ]
# }

 variable "kms_key_description" {
 }

 variable "kms_key_name" {

 }

 variable "kms_policies_list" {
   type    = list(any)
   default = []
 }

## EKS Cluster ##
variable "cluster_name" {
  type = string
}

variable "cluster_version" {

}

variable "eks_iam_name" {
  
}


variable "cluster_subnets" {
  type = list(any)
}
variable "fargate_profile_subnets" {
  type = list(any)
}

variable "fargate_profilename" {

}

variable "fargate_profile_iam" {
  
}

variable "cluster_addons" {
  description = "Map of cluster addon configurations to enable for the cluster. Addon name can be the map keys or set with `name`"
  type        = any
  default     = {}
}
# variable "cluster_user_name" {
#   type = string
# }

variable "create" {
  type        = bool
  default     = true 
}

variable "create_outposts_local_cluster" {
  type        = bool
  default     = false
}


variable "cluster_encryptionkey_arn" {

}

# variable "addons" {
#   type = map(object({
#     addon_name = string
#     addon_version = string
#   }))
# }

variable "cluster_endpoint_private_access" {
  
}

variable "cluster_endpoint_public_access" {
  
}
# ## Helm release resource variables
variable "chartversion" {
  
}

variable "chart_name" {
  
}

variable "repourl" {
  
}

variable "create_namespace" {
  
}
variable "chart_namespace" {
  
}

variable "helm_release_name" {
  
}

# variable "cluster_name" {
#     type = string
#    # default = "cicd-k8s-portal-dev-cluster"

# }

# variable "parameterstore_clustername" {
  
# }

# variable "nodegroup_subnets" {
#   type        = list(string)
# }

# variable "desired_size" {
# }

# variable "max_size" {
# }

# variable "min_size" {
# }

 variable "application" {
   type    = string
 }

# variable "environment" {
#   type    = string
# }

/* variable "security_group_id" {
   type  = list(any)  
   
} */

variable "wait_for_fargate_profile_deletion" {
  type    = bool
  default = false
}

variable "cluster_security_group_id" {
  type = list
  default = []
}


#################### SSM  ####################
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

variable "clustername_store" {
   default = "myclusternamestore"
}

variable "clustercert_store" {
   default = "myclustercertstore"
}

variable "clusterendpoint_store" {
  default = "myclusterendpointstore"
}

# variable "parameterstore_clustername" {
  
# }

variable "myparameter_name" {
  description = "Name of the SSM parameter"
  type        = string
  default = "myclusternamestore"
}

