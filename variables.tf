variable "name" {
  type        = string
  description = "Enter name for resources"
  default     = "agharameez"
}

variable "tags" {
  type = map(any)
  default = {
    Created_by  = "agharameez"
    Enviornment = "dev"

  }
}


variable "cidr_block" {
  type        = string
  description = "cidr block for vpc"
  default     = "10.0.0.0/16"
}

#map of maps for create subnets
variable "publicprefix" {
  type    = list(any)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "privateprefix" {
  type    = list(any)
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "nat_gateway" {
  type    = number
  default = 1
}

variable "cluster_name" {
  type    = string
  default = "agharameez-Cluster"
}

variable "deploy_cluster" {
  type = bool
  default = true
}