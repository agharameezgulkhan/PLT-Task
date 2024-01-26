output "private_subnet_id" {
  value = aws_subnet.main-Private-subnet[*].id
}

output "public_subnet_id" {
  value = aws_subnet.main-Public-subnet[*].id
}

output "availability_zone" {
  value = data.aws_availability_zones.azs
}

output "security_group_id" {
  value = aws_security_group.agharameezSG.id
}
output "nat" {
  value = one(aws_nat_gateway.nat[*].id)
}

output "vpc_id" {
  value = aws_vpc.agharameezvpc.id
}
