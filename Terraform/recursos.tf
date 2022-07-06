resource "azurerm_resource_group" "rgCM" {
  name     = var.resource_group_name
  location = var.location_name
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.network_name
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rgCM.location
  resource_group_name = azurerm_resource_group.rgCM.name
}

resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.rgCM.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "IPpub" {
  name                = "acceptanceTestPublicIp1"
  resource_group_name = azurerm_resource_group.rgCM.name
  location            = azurerm_resource_group.rgCM.location
  allocation_method   = "Static"

  tags = {
    environment = "Production"
  }
}

resource "azurerm_public_ip" "IPpub2" {
  name                = "acceptanceTestPublicIp2"
  resource_group_name = azurerm_resource_group.rgCM.name
  location            = azurerm_resource_group.rgCM.location
  allocation_method   = "Static"

  tags = {
    environment = "Production"
  }
}

resource "azurerm_public_ip" "IPpub3" {
  name                = "acceptanceTestPublicIp3"
  resource_group_name = azurerm_resource_group.rgCM.name
  location            = azurerm_resource_group.rgCM.location
  allocation_method   = "Static"

  tags = {
    environment = "Production"
  }
}



resource "azurerm_network_interface" "nic" {
  name                = "vnic"
  location            = azurerm_resource_group.rgCM.location
  resource_group_name = azurerm_resource_group.rgCM.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Static"
	private_ip_address            ="10.0.2.8"
	public_ip_address_id          = azurerm_public_ip.IPpub.id
  }
}

resource "azurerm_network_interface" "nic2" {
  name                = "vnic2"
  location            = azurerm_resource_group.rgCM.location
  resource_group_name = azurerm_resource_group.rgCM.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Static"
	private_ip_address            ="10.0.2.9"
	public_ip_address_id          = azurerm_public_ip.IPpub2.id
  }
}

resource "azurerm_network_interface" "nic3" {
  name                = "vnic3"
  location            = azurerm_resource_group.rgCM.location
  resource_group_name = azurerm_resource_group.rgCM.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Static"
	private_ip_address            ="10.0.2.10"
	public_ip_address_id          = azurerm_public_ip.IPpub3.id
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = "vm1-NFS"
  resource_group_name = azurerm_resource_group.rgCM.name
  location            = azurerm_resource_group.rgCM.location
  size                = "Standard_B1ms"
  admin_username      = "azureuser"
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

 admin_ssh_key {
    username   = "azureuser"
    public_key = file("C:/Users/cmartin/desktop/ssh/testazure.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  plan {
    name      = "centos-8-stream-free"
    product   = "centos-8-stream-free"
    publisher = "cognosys"
  }


  source_image_reference {
    publisher = "cognosys"
    offer     = "centos-8-stream-free"
    sku       = "centos-8-stream-free"
    version   = "22.03.28"
  }
}


resource "azurerm_linux_virtual_machine" "vm2" {
  name                = "vm2-WORKER"
  resource_group_name = azurerm_resource_group.rgCM.name
  location            = azurerm_resource_group.rgCM.location
  size                = "Standard_B1ms"
  admin_username      = "azureuser"
  network_interface_ids = [
    azurerm_network_interface.nic2.id,
  ]

 admin_ssh_key {
    username   = "azureuser"
    public_key = file("C:/Users/cmartin/desktop/ssh/testazure.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  plan {
    name      = "centos-8-stream-free"
    product   = "centos-8-stream-free"
    publisher = "cognosys"
  }


  source_image_reference {
    publisher = "cognosys"
    offer     = "centos-8-stream-free"
    sku       = "centos-8-stream-free"
    version   = "22.03.28"
  }
}


resource "azurerm_linux_virtual_machine" "vm3" {
  name                = "vm3-MASTER"
  resource_group_name = azurerm_resource_group.rgCM.name
  location            = azurerm_resource_group.rgCM.location
  size                = "Standard_b2ms"
  admin_username      = "azureuser"
  network_interface_ids = [
    azurerm_network_interface.nic3.id,
  ]

 admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  plan {
    name      = "centos-8-stream-free"
    product   = "centos-8-stream-free"
    publisher = "cognosys"
  }


  source_image_reference {
    publisher = "cognosys"
    offer     = "centos-8-stream-free"
    sku       = "centos-8-stream-free"
    version   = "22.03.28"
  }
}


