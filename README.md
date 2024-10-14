# wiz-tf-azure-ade-workshop
A deployment of an ADE-encrypted VM that would cause System Health Issues when first detected by Wiz

## Prerequisites
You will need: 

* An Azure subscription connected to Wiz either at the root management group level (preferred) or the subscription level. SaaS connection is fine, Outpost is not required.
* To note down your public IPv4 address.
* To install Terraform (demo was tested against Terraform v1.9.7)

## Deployment Instructions

1. Clone or download this repository locally
2. Create a `terraform.tfvars` file in the location `terraform/tf-control` with contents similar to as follows:

```
ade_location            = "UK South" # You can choose another location if you prefer. 
ade_owner               = "FirstName-Surname" # Substitute this for your own name separated by a dash.
ade_ingress_prefix      = "0.0.0.0/0" # Enter your own public IPv4 address ending in /32.
```

3. Create a `providers_azurerm.tf` file in the location `terraform/tf-control` with contents similar to as follows:

```
provider "azurerm" {
  subscription_id = "93e2fb4e-e46a-4ee5-8be0-1a4f555eb1ff" # Substitute for the Azure subscription ID that you wish to deploy the infrastructure to.

  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}
```

4. Download Azure CLI and log in to azure using the `az login` command. Terraform should authenticate to your Azure account using the same credentials.