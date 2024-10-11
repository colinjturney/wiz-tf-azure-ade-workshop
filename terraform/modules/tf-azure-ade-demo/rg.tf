resource "azurerm_resource_group" "ade_example" {
  name     = "${var.ade_owner}-ADE-Example"
  location = var.ade_location
}