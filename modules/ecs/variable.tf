# variable "alb" {

# }
### ECS ###
variable "cluster_name" { type = string }
variable "aws_iam_role" {  }
variable "security_group" { type = string }
variable "public_subnet_id" {  }
# variable "private_subnet_id" {type = string}
variable "vpc_id" { type = string }