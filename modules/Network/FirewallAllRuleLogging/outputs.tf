output "firewall_private_ip" {
  value       = azurerm_firewall.azurefirewall.ip_configuration[0].private_ip_address
  description = "The private IP address of the firewall"
}