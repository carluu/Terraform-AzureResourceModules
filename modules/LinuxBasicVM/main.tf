data "azurerm_resource_group" "rg-main" {
  name = var.mainrg
}

resource "azurerm_network_interface" "linuxvmnic" {
  name                = var.nic_name
  location            = data.azurerm_resource_group.rg-main.location
  resource_group_name = data.azurerm_resource_group.rg-main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "linuxvm" {
  name                = var.vm_name
  resource_group_name = data.azurerm_resource_group.rg-main.name
  location            = data.azurerm_resource_group.rg-main.location
  size                = var.sku
  admin_username      = "cuuadmin"
  network_interface_ids = [
    azurerm_network_interface.linuxvmnic.id,
  ]

  admin_ssh_key {
    username   = "cuuadmin"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}
