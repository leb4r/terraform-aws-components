output "fqdn" {
  description = "Fully-qualified domain name of the Route 53 Zone"
  value       = module.regional_zone.fqdn
}

output "id" {
  description = "ID of the Route 53 Zone"
  value       = module.regional_zone.zone_id
}

output "name_servers" {
  description = "Name servers of the Route 53 Zone"
  value       = module.regional_zone.zone_name_servers
}
