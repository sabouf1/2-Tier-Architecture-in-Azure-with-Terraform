Here's a README file for your Git repository that explains the project and provides information about the variables used in your Terraform configuration:

```markdown
# Azure 2-Tier Architecture with Terraform

This Terraform project deploys a 2-Tier architecture in Azure, consisting of an application tier with a Virtual Machine Scale Set and a database tier with Azure Database for PostgreSQL. The infrastructure includes networking components such as Virtual Network, Subnet, Load Balancer, and DNS Zone.

## Prerequisites

Before you begin, make sure you have the following:

- [Terraform](https://www.terraform.io/downloads.html) installed on your local machine.
- An [Azure subscription](https://azure.com) and authentication set up (Azure CLI, Service Principal, or Managed Identity).
- An SSH public key for VM authentication (if using SSH).

## Configuration

### `variables.tf`

This file defines the variables used in the Terraform configuration. You can customize the values of these variables to suit your requirements.

Here are some of the important variables:

- `resource_group_name`: Name of the Azure Resource Group.
- `location`: Azure region for resources.
- `virtual_network_name`: Name of the Azure Virtual Network.
- `subnet_name`: Name of the subnet for the application tier.
- `public_ip_name`: Name of the Azure Public IP.
- `lb_name`: Name of the Azure Load Balancer.
- `vmss_name`: Name of the Virtual Machine Scale Set.
- `vmss_sku`: SKU for the Virtual Machine Scale Set.
- `vmss_instance_count`: Number of instances in the Virtual Machine Scale Set.
- `vm_admin_username`: Admin username for VM instances.
- `vm_admin_password`: Admin password for VM instances (you can use SSH key instead).
- `ssh_public_key_path`: Path to the SSH public key file.
- `vm_image_publisher`: Publisher of the VM image.
- `vm_image_offer`: Offer of the VM image.
- `vm_image_sku`: SKU of the VM image.
- `vm_image_version`: Version of the VM image.
- Other PostgreSQL related variables for the database tier.

### `main.tf`

This file contains the Terraform configuration for provisioning the Azure infrastructure. It uses the variables defined in `variables.tf` to create Azure resources.

### Running Terraform

1. Initialize Terraform:

   ```bash
   terraform init
   ```

2. Review the plan:

   ```bash
   terraform plan
   ```

3. Apply the configuration:

   ```bash
   terraform apply
   ```

## Outputs

- `load_balancer_public_ip`: The public IP address of the Load Balancer for DNS configuration.

## Cleanup

To destroy the Azure resources created by Terraform, run:

```bash
terraform destroy
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
```

You can include this README file in your Git repository to provide documentation and instructions to users who want to deploy or understand your Azure 2-Tier Architecture using Terraform. Make sure to customize it further if needed and add any additional information that might be relevant to your project.
