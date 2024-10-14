resource "azurerm_virtual_network" "vnet" {
    name                = "${var.ade_owner}-ADE-Example-VNET"
    location            = var.ade_location
    resource_group_name = azurerm_resource_group.ade_example.name

    address_space   = ["10.0.0.0/16"]
    dns_servers     = ["10.0.0.4", "10.0.0.5"]

    subnet {
        name                = "${var.ade_owner}-ADE-Example-Subnet-1"
        address_prefixes    = ["10.0.1.0/24"]
        security_group      =  azurerm_network_security_group.sg-1.id
        service_endpoints   = ["Microsoft.KeyVault"]
    }

    subnet {
        name                = "${var.ade_owner}-ADE-Example-Subnet-2"
        address_prefixes    = ["10.0.2.0/24"] 
        security_group      =  azurerm_network_security_group.sg-2.id
        service_endpoints   = ["Microsoft.KeyVault"] 
    }
}

resource "azurerm_network_security_group" "sg-1" {
    name                    = "${var.ade_owner}-ADE-Example-SecurityGroup-1"
    location                = var.ade_location
    resource_group_name     = azurerm_resource_group.ade_example.name

    security_rule {
        name        = "AllowRDPIngress"
        priority    = 100
        direction   = "Inbound"
        access      = "Allow"
        protocol    = "Tcp"
        source_port_range = "*"
        destination_port_range = "3389"
        source_address_prefix = var.ade_ingress_prefix
        destination_address_prefix = "*"
    }
}

resource "azurerm_network_security_group" "sg-2" {
    name                    = "${var.ade_owner}-ADE-Example-SecurityGroup-2"
    location                = var.ade_location
    resource_group_name     = azurerm_resource_group.ade_example.name 
}