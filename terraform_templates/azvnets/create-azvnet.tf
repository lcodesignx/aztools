provider "azurerm" {
    version = "~>2.0"
    features {}
}

resource "azurerm_resource_group" "demorg" {
    name        = "demo-rg"
    location    = "East US"
}

resource "azurerm_virtual_network" "demovnet" {
    name                = "demo-vnet"
    address_space       = ["10.1.0.0/16"]
    resource_group_name = azurerm_resource_group.demorg.name
    location            = azurerm_resource_group.demorg.location
}

resource "azurerm_subnet" "dbsubnet" {
    name                    = "db-subnet"
    address_prefixes        = ["10.1.10.0/24"]
    resource_group_name     = azurerm_resource_group.demorg.name
    virtual_network_name    = azurerm_virtual_network.demovnet.name
}

resource "azurerm_subnet" "svcsubnet" {
    name                    = "svc-subnet"
    address_prefixes        = ["10.1.20.0/24"]
    resource_group_name     = azurerm_resource_group.demorg.name
    virtual_network_name    = azurerm_virtual_network.demovnet.name
}