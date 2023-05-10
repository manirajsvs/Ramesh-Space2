# eks cluster vairables
#variable "cluster_name" {
#}

# variable "cluster_role_arn" {

  
# }

variable "cluster_addons" {
  description = "Map of cluster addon configurations to enable for the cluster. Addon name can be the map keys or set with `name`"
  type        = any
  default     = {}
}

variable "cluster_addons_timeouts" {
  description = "Create, update, and delete timeout configurations for the cluster addons"
  type        = map(string)
  default     = {}
}


variable "cluster_version" {
  default = "1.25"
}

variable "cluster_subnets" {
    type = list
  
}

variable "eks_iam_name" {
  
}

variable "kms_key_description" {
}

variable "kms_key_name" {
  
}

variable "kms_policies_list" {
    type = list
    default = []
}

# variable "cluster_endpoint_private_access" {
  
# }

# variable "cluster_endpoint_public_access" {
  
# }

# variable "cluster_endpoint_public_access_cidrs" {
#     type = list
  
# }

variable "cluster_encryptionkey_arn" {
  
}

variable "cluster_endpoint_private_access" {
}

variable "cluster_endpoint_public_access" {
}


variable "eks_tags" {
    type = map
    default = {}
}

variable "cluster_endpoint_public_access_cidrs" {
  type    = list(string)
  
}
variable "wait_for_fargate_profile_deletion" {
  type    = bool
  default = false
}

# fargate variables defined
variable "cluster_name" {
  default = "ramesh-test"
}

variable "fargate_profile_tags" {
    type = map
    default = {}
  
}

variable "fargate_profile_iam" {
  
}
variable "fargate_profile_subnets" {
    type = list
    default = ["subnet-0c692fa6f06622f44"]
}

#"subnet-0a2986bceba85aa6c",
variable "fargate_profilename" {
  default = "fargate-profile"  
}

# variable "pod_execution_role" {
  
# }

variable "selectors" {
  description = "Configuration block(s) for selecting Kubernetes Pods to execute with this Fargate Profile"
  type        = any
  default     = [
    {
      namespace = "github-runner"
    },
    {
      namespace = "argocd"
    },
    {
      namespace = "databricks"
    },
    {
      namespace = "kube-system"
    },
    {
      namespace = "default"
    }
  ]
}

variable "timeouts" {
  description = "Create and delete timeout configurations for the Fargate Profile"
  type        = map(string)
  default     = {}
}

variable "addon_steady_state_timeout" {
  default = 2400
}

# variable "addons" {
#   type = map(object({
#     addon_name = string
#     addon_version = string
#   }))
# }

variable "map_accounts" {
  description = "Additional AWS account numbers to add to the aws-auth ConfigMap"
  type        = list(string)
  default     = []
}

variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth ConfigMap"
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))
  default = []
}

variable "map_users" {
  description = "Additional IAM users to add to the aws-auth ConfigMap"
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))
  default = []
}

# variable "cluster_encryptionkey_arn" {
  
# }


# variable "eks_readiness_timeout" {
#   description = "The maximum time (in seconds) to wait for EKS API server endpoint to become healthy"
#   type        = number
#   default     = "600"
# }


variable "create" {
  type        = bool
  default     = true 
}

variable "create_outposts_local_cluster" {
  type        = bool
  default     = false
}

#variable "wait_for_fargate_profile_deletion" {
#  type    = bool
#  default = false
#}

# security group variables

variable "sg_name" {
  
}
variable "sg_tags" {
    type = map
    default = {}
}

variable "sg_description" {
  
}

variable "vpc_id" { 
}

variable "ingress_rules" {
  description = "List of computed ingress rules to create by name"
  type        = list(string)
  default     = []
}

variable "ingress_cidr_blocks" {
  description = "List of IPv4 CIDR ranges to use on all ingress rules"
  type        = list(string)
  default     = []
}

variable "ingress_with_cidr_blocks" {
  description = "List of ingress rules to create where 'cidr_blocks' is used"
  type        = list(map(string))
  default     = []
}

variable "egress_with_cidr_blocks" {
  type = list(object({
    cidr_blocks = string,
    description = string,
    from_port = number,
    to_port = number,
    protocol = string
  }))
  default = [
    # {
    #   rule        = "allow_all"
    #   cidr_blocks = "10.0.0.0/16",
    #   description = "Allow all egress traffic"
    #   from_port   = null
    #   to_port     = null
    #   protocol    = null
    # },
    {
      rule        = "allow_https"
      cidr_blocks = "0.0.0.0/0"
      description = "Allow HTTPS traffic"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
    }
  ]
}


variable "egress_cidr_blocks" {
  description = "List of IPv4 CIDR ranges to use on all egress rules"
  type        = list(string)
  default     = []
}
/*
variable "cluster_security_group_id" {
  default = output.security_group_id
} */

variable "cluster_security_group_id" {
  type = list
  
}


##################### SSM  ####################

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