variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  default     = "my-resource-group"
}

variable "location" {
  description = "Azure region for resources"
  default     = "East US"
}

variable "virtual_network_name" {
  description = "Name of the Azure Virtual Network"
  default     = "my-vnet"
}

variable "subnet_name" {
  description = "Name of the subnet for the application tier"
  default     = "app-subnet"
}

variable "subnet_address_prefix" {
  description = "Address prefix for the subnet"
  default     = "10.0.1.0/24"
}

variable "public_ip_name" {
  description = "Name of the Azure Public IP"
  default     = "lb-public-ip"
}

variable "lb_name" {
  description = "Name of the Azure Load Balancer"
  default     = "my-lb"
}

variable "lb_frontend_ip_name" {
  description = "Name of the Load Balancer frontend IP configuration"
  default     = "PublicIPAddress"
}

variable "lb_backend_pool_name" {
  description = "Name of the Load Balancer backend address pool"
  default     = "my-terraform-lb-backend-pool"
}

variable "lb_probe_name" {
  description = "Name of the Load Balancer probe"
  default     = "my-terraform-lb-probe"
}

variable "lb_rule_name" {
  description = "Name of the Load Balancer rule"
  default     = "my-terraform-lb-rule"
}

variable "vmss_name" {
  description = "Name of the Virtual Machine Scale Set"
  default     = "my-terraform-vm-scale-set"
}

variable "vmss_sku" {
  description = "SKU for the Virtual Machine Scale Set"
  default     = "Standard_DS1_v2"
}

variable "vmss_instance_count" {
  description = "Number of instances in the Virtual Machine Scale Set"
  default     = 1
}

variable "vm_admin_username" {
  description = "Admin username for VM instances"
  default     = "azureuser"
}

variable "vm_admin_password" {
  description = "Admin password for VM instances"
  default     = "Password1234!"
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key file"
  default     = "~/.ssh/id_rsa.pub"
}

variable "vm_image_publisher" {
  description = "Publisher of the VM image"
  default     = "Canonical"
}

variable "vm_image_offer" {
  description = "Offer of the VM image"
  default     = "UbuntuServer"
}

variable "vm_image_sku" {
  description = "SKU of the VM image"
  default     = "18.04-LTS"
}

variable "vm_image_version" {
  description = "Version of the VM image"
  default     = "latest"
}

variable "os_disk_type" {
  description = "Storage account type for the OS disk"
  default     = "Standard_LRS"
}

variable "vm_tags" {
  description = "Tags for the VM instances"
  type        = map(string)
  default = {
    environment = "my-terraform-env"
  }
}

variable "dns_zone_name" {
  description = "Name of the DNS Zone"
  default     = "exampledomain.com"
}

variable "dns_record_name" {
  description = "Name of the DNS A Record"
  default     = "my-A-record"
}

variable "postgresql_admin_login" {
  description = "Administrator login for PostgreSQL"
  default     = "psqladmin"
}

variable "postgresql_admin_password" {
  description = "Administrator password for PostgreSQL"
  default     = "H@Sh1CoR3!"
}

variable "postgresql_sku_name" {
  description = "SKU name for PostgreSQL server"
  default     = "GP_Gen5_4"
}

variable "postgresql_version" {
  description = "Version of PostgreSQL server"
  default     = "11"
}

variable "postgresql_storage_mb" {
  description = "Storage size in MB for PostgreSQL server"
  default     = 640000
}

variable "postgresql_backup_retention_days" {
  description = "Backup retention days for PostgreSQL server"
  default     = 7
}

variable "postgresql_ssl_enforcement_enabled" {
  description = "Enable SSL enforcement for PostgreSQL server"
  default     = true
}

variable "postgresql_ssl_minimal_tls_version_enforced" {
  description = "Minimal TLS version enforced for PostgreSQL server"
  default     = "TLS1_2"
}

variable "enable_public_network_access" {
  description = "Enable public network access for PostgreSQL server"
  default     = true
}

variable "enable_auto_grow" {
  description = "Enable auto grow for PostgreSQL server"
  default     = false
}

variable "geo_redundant_backup_enabled" {
  description = "Enable geo-redundant backup for PostgreSQL server"
  default     = false
}

variable "database_name" {
  description = "Name of the PostgreSQL database"
  default     = "metrc_db"
}
