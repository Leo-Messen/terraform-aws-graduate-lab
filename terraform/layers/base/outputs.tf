output "available_azs" {
  value = data.aws_availability_zones.available_azs.names
}
