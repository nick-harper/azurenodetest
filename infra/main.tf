provider "azurerm" {
  features {}

  subscription_id = "4f6a6eb9-27d0-4ed6-a31c-2bde135e2db6" 
  resource_provider_registrations = "none"
}



resource "azurerm_virtual_network" "vnet" {
  name                = "devops-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = "rg_sb_eastus_125088_1_174758410343"
}

resource "azurerm_subnet" "subnet" {
  name                 = "devops-subnet"
  resource_group_name = "rg_sb_eastus_125088_1_174758410343"
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "nsg" {
  name                = "devops-nsg"
  location            = var.location
  resource_group_name = "rg_sb_eastus_125088_1_174758410343"

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-HTTP-3000"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3000"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "nic" {
  name                = "devops-nic"
  location            = var.location
  resource_group_name = "rg_sb_eastus_125088_1_174758410343"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_ip.id
  }
}

resource "azurerm_public_ip" "vm_ip" {
  name                = "devops-vm-ip"
  location            = var.location
  resource_group_name = "rg_sb_eastus_125088_1_174758410343"
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface_security_group_association" "nsg_assoc" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                  = "devops-vm"
  resource_group_name   = "rg_sb_eastus_125088_1_174758410343"
  location              = var.location
  size                  = "Standard_B2s"
  admin_username        = "azureuser"
  network_interface_ids = [azurerm_network_interface.nic.id]
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = file(var.ssh_public_key)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "devops-os-disk"
  }

  source_image_reference {
  publisher = "Canonical"
  offer     = "0001-com-ubuntu-server-jammy"
  sku       = "22_04-lts"
  version   = "latest"
}
}
# comment
# test change
