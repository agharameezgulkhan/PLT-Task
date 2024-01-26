# variable "alb" {

# }
### ECS ###
variable "container_image" {
  type        = string
  description = "Define what docker image will be deployed to the ECS task"
  default     = "wordpress"
}
variable "cluster_name" {}
variable "aws_iam_role" {}
variable "security-group" {}
variable "public_subnet_id" {}
variable "private_subnet_id" {}
variable "vpc_id" {}