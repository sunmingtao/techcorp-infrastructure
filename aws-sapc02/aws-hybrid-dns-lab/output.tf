# ============================================================================
# OUTPUTS
# ============================================================================

output "private_hosted_zone_id" {
  description = "ID of the private hosted zone"
  value       = aws_route53_zone.private.zone_id
}

output "inbound_resolver_ips" {
  description = "IP addresses of the inbound resolver endpoints"
  value = [
    tolist(aws_route53_resolver_endpoint.inbound.ip_address)[0].ip,
    tolist(aws_route53_resolver_endpoint.inbound.ip_address)[1].ip
  ]
}

output "test_instances" {
  description = "Information about test instances"
  value = {
    app_a_private_ip    = aws_instance.test_app_a.private_ip
    app_b_private_ip    = aws_instance.test_app_b.private_ip
    onprem_public_ip    = aws_instance.onprem_simulator.public_ip
    onprem_private_ip   = aws_instance.onprem_simulator.private_ip
  }
}

output "transit_gateway_id" {
  description = "ID of the Transit Gateway"
  value       = aws_ec2_transit_gateway.main.id
}

output "vpcs" {
  description = "VPC information"
  value = {
    shared_services_vpc_id = aws_vpc.shared_services.id
    app_a_vpc_id          = aws_vpc.app_a.id
    app_b_vpc_id          = aws_vpc.app_b.id
  }
}

output "dns_test_commands" {
  description = "Commands to test DNS resolution"
  value = {
    from_app_instances = "nslookup api.${var.domain_name}"
    from_onprem       = "nslookup api.${var.domain_name} localhost"
    direct_query      = "nslookup api.${var.domain_name} ${tolist(aws_route53_resolver_endpoint.inbound.ip_address)[0].ip}"
  }
}

output "ssh_commands" {
  description = "SSH commands to connect to instances"
  value = var.key_pair_name != "" ? {
    onprem_simulator = "ssh -i ~/.ssh/${var.key_pair_name}.pem ec2-user@${aws_instance.onprem_simulator.public_ip}"
    note            = "For private instances, use AWS Systems Manager Session Manager"
  } : {
    note = "SSH access not configured. Use Systems Manager Session Manager."
  }
}
