variable "tags" {
  type = map(any)
}
variable "cidr_block" {
  type = string
}

variable "publicprefix" {
  type = list(any)
}
variable "privateprefix" {
  type = list(any)
}
variable "nat_gateway" {
  type = string
}
