output "fqdn" {
  description = "Fully-qualified domain name"
  value       = module.regional_zone.fqdn
}

output "zone_id" {
  description = "Route 53 Zone ID"
  value       = module.regional_zone.zone_id
}

output "zone_name_servers" {
  description = "Route 53 DNS Name Servers of the Zone"
  value       = module.regional_zone.zone_name_servers
}
