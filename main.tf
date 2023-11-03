# Initialize the Azure provider
provider "azurerm" {
  features {}
}

# resource group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# subnet for the application tier
resource "azurerm_subnet" "app_subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_address_prefix]
}

# public IP address for the Load Balancer
resource "azurerm_public_ip" "lb_public_ip" {
  name                = var.public_ip_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}

# an Azure Load Balancer
resource "azurerm_lb" "lb" {
  name                = var.lb_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  frontend_ip_configuration {
    name                 = var.lb_frontend_ip_name
    public_ip_address_id = azurerm_public_ip.lb_public_ip.id
  }
}

# Load Balancer Backend Address Pool
resource "azurerm_lb_backend_address_pool" "lb_bk_end" {
  name            = var.lb_backend_pool_name
  loadbalancer_id = azurerm_lb.lb.id
}

# Load Balancer health probes
resource "azurerm_lb_probe" "lb_probe" {
  name            = var.lb_probe_name
  loadbalancer_id = azurerm_lb.lb.id
  port            = 80
}

# Load Balancer Rule
resource "azurerm_lb_rule" "lb_rule" {
  name                           = var.lb_rule_name
  loadbalancer_id                = azurerm_lb.lb.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = var.lb_frontend_ip_name

  backend_address_pool_ids = [azurerm_lb_backend_address_pool.lb_bk_end.id]
  probe_id                = azurerm_lb_probe.lb_probe.id
}

# Virtual Machine Scale Set
resource "azurerm_linux_virtual_machine_scale_set" "scale_set" {
  name                = var.vmss_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = var.vmss_sku
  instances           = var.vmss_instance_count
  admin_username      = var.vm_admin_username
  admin_password      = var.vm_admin_password
  disable_password_authentication = false

  admin_ssh_key {
    username   = var.vm_admin_username
    public_key = file(var.ssh_public_key_path)
  }

  source_image_reference {
    publisher = var.vm_image_publisher
    offer     = var.vm_image_offer
    sku       = var.vm_image_sku
    version   = var.vm_image_version
  }

  os_disk {
    storage_account_type = var.os_disk_type
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "my-terraform-vm-ss-nic"
    primary = true

    ip_configuration {
      name                                   = "my-terraform-vm-ss-nic-ip"
      primary                                = true
      subnet_id                              = azurerm_subnet.app_subnet.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.lb_bk_end.id]
    }
  }

  extension {
    name                 = "hostname"
    publisher            = "Microsoft.Azure.Extensions"
    type                 = "CustomScript"
    type_handler_version = "2.1"

    settings = <<SETTINGS
      {
        "commandToExecute": "echo 'Azure Terraform 2 tier app Project' > index.html ; nohup busybox httpd -f -p ${80} &"
      }
    SETTINGS
  }

  tags = var.vm_tags
}

# DNS Zone 
resource "azurerm_dns_zone" "zone" {
  name                = var.dns_zone_name
  resource_group_name = azurerm_resource_group.rg.name
}

# DNS Record Set
resource "azurerm_dns_a_record" "record" {
  name                = var.dns_record_name
  zone_name           = azurerm_dns_zone.zone.name
  resource_group_name = azurerm_resource_group.rg.name
  target_resource_id  = azurerm_public_ip.lb_public_ip.id
  ttl                 = 300
}

resource "azurerm_postgresql_server" "db_server" {
  name                = "psqlserver-metroc-2023"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  administrator_login          = var.postgresql_admin_login
  administrator_login_password = var.postgresql_admin_password

  sku_name   = var.postgresql_sku_name
  version    = var.postgresql_version
  storage_mb = var.postgresql_storage_mb

  backup_retention_days        = var.postgresql_backup_retention_days
  geo_redundant_backup_enabled = var.geo_redundant_backup_enabled
  auto_grow_enabled            = var.enable_auto_grow

  public_network_access_enabled    = var.enable_public_network_access
  ssl_enforcement_enabled          = var.postgresql_ssl_enforcement_enabled
  ssl_minimal_tls_version_enforced = var.postgresql_ssl_minimal_tls_version_enforced
}

resource "azurerm_postgresql_database" "db" {
  name                = var.database_name
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_postgresql_server.db_server.name
  charset             = "UTF8"
  collation           = "en_US.utf8"
}

# Output the public IP of the Load Balancer for DNS configuration
output "load_balancer_public_ip" {
  value = azurerm_public_ip.lb_public_ip.ip_address
}

#Added File system

resource "random_string" "storage_account_name" {
  length = 10
  special = false
  upper = false
  number = true
}

resource "azurerm_storage_account" "stg1" {
  name                     = "azurestorage${random_string.storage_account_name.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_share" "share1" {
  name                 = "sharename"
  storage_account_name = azurerm_storage_account.stg1.name
  quota                = 50
}

resource "azurerm_storage_share_file" "example" {
  name             = "my-awesome-content.zip"
  storage_share_id = azurerm_storage_share.share1.id
  source           = "some-local-file.zip"
}
