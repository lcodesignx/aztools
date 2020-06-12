provider "azurerm" {
    features {}
}

resource "azurerm_public_ip" "demopublicip" {
    name                = "demo-public-ip"
    location            = "East US"
    resource_group_name = "demo-rg"
    allocation_method   = "Dynamic"

    tags = {
        environment = "terraform demo"
    }
}

resource "azurerm_network_security_group" "demonsg" {
    name                = "demo-nsg"
    location            = "East US"
    resource_group_name = "demo-rg"

    security_rule {
        name                        = "SSH"
        priority                    = 1001
        direction                   = "Inbound"
        access                      = "Allow"
        protocol                    = "TCP"
        source_port_range           = "*"
        destination_port_range      = "22"
        source_address_prefix       = "*"
        destination_address_prefix   = "*"
    }

    tags = {
        environment = "terraform demo"
    }
}

resource "azurerm_network_interface" "demonic" {
    name                = "demo-nic"
    location            = "East US"
    resource_group_name = "demo-rg"

    ip_configuration {
        name                            = "demo-nic-config"
        subnet_id                       = "/subscriptions/00ecb86a-d6bb-4c2f-a512-3ae47c70b8c2/resourceGroups/demo-rg/providers/Microsoft.Network/virtualNetworks/demo-vnet/subnets/db-subnet"
        private_ip_address_allocation   = "Dynamic"
        public_ip_address_id            = azurerm_public_ip.demopublicip.id
    }

    tags = {
        environment = "terraform demo"
    }

}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "demonsgnic" {
    network_interface_id        = azurerm_network_interface.demonic.id
    network_security_group_id   = azurerm_network_security_group.demonsg.id
}

resource "azurerm_linux_virtual_machine" "demolinuxvm" {
    name                = "demo-linux-vm"
    resource_group_name = "demo-rg"
    location            = "East US"
    admin_username      = "azadmin"
    size                = "Standard_DS1_v2"

    network_interface_ids    = [
        azurerm_network_interface.demonic.id,
    ]

    admin_ssh_key {
        username    = "azadmin"
        public_key  = file("~/.ssh/id_rsa.pub")
    }

    os_disk {
        name              = "demo-osdisk"
        caching           = "ReadWrite"
        storage_account_type = "Premium_LRS"
    }

    source_image_reference {
        publisher   = "OpenLogic"
        offer       = "CentOS"
        sku         = "7.5"
        version     = "latest"
    }
}