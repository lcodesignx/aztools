provider "azurerm" {
    version = "~>2.0"
    features {}
}

resource "azurerm_resource_group" "linux-dev-rg" {
    name        = "linux-dev-rg"
    location    = "East US"
    tags        = {
        Department = "linux-rd"
    }
}

resource "azurerm_resource_group" "windows-dev-rg" {
    name        = "windows-dev-rg"
    location    = "East US"
    tags        = {
        Department = "windows-rd"
    }
}