resource "azurerm_storage_account" "bosh_root_storage_account" {
  name                     = "${var.env_short_name}director"
  resource_group_name      = "${azurerm_resource_group.pcf_resource_group.name}"
  location                 = "${var.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "bosh_storage_container" {
  name                  = "bosh"
  depends_on            = ["azurerm_storage_account.bosh_root_storage_account"]
  resource_group_name   = "${azurerm_resource_group.pcf_resource_group.name}"
  storage_account_name  = "${azurerm_storage_account.bosh_root_storage_account.name}"
  container_access_type = "private"
}

resource "azurerm_storage_container" "stemcell_storage_container" {
  name                  = "stemcell"
  depends_on            = ["azurerm_storage_account.bosh_root_storage_account"]
  resource_group_name   = "${azurerm_resource_group.pcf_resource_group.name}"
  storage_account_name  = "${azurerm_storage_account.bosh_root_storage_account.name}"
  container_access_type = "blob"
}

resource "azurerm_storage_table" "stemcells_storage_table" {
  name                 = "stemcells"
  resource_group_name  = "${azurerm_resource_group.pcf_resource_group.name}"
  storage_account_name = "${azurerm_storage_account.bosh_root_storage_account.name}"
}

resource "azurerm_storage_account" "bosh_vms_storage_account" {
  name                     = "${var.env_short_name}${data.template_file.base_storage_account_wildcard.rendered}${count.index}"
  resource_group_name      = "${azurerm_resource_group.pcf_resource_group.name}"
  location                 = "${var.location}"
  account_tier             = "Premium"
  account_replication_type = "LRS"

  count = 5
}

resource "azurerm_storage_container" "bosh_vms_storage_container" {
  name                  = "bosh"
  depends_on            = ["azurerm_storage_account.bosh_vms_storage_account"]
  resource_group_name   = "${azurerm_resource_group.pcf_resource_group.name}"
  storage_account_name  = "${element(azurerm_storage_account.bosh_vms_storage_account.*.name, count.index)}"
  container_access_type = "private"

  count = 5
}

resource "azurerm_storage_container" "bosh_vms_stemcell_storage_container" {
  name                  = "stemcell"
  depends_on            = ["azurerm_storage_account.bosh_vms_storage_account"]
  resource_group_name   = "${azurerm_resource_group.pcf_resource_group.name}"
  storage_account_name  = "${element(azurerm_storage_account.bosh_vms_storage_account.*.name, count.index)}"
  container_access_type = "private"

  count = 5
}

output "bosh_root_storage_account" {
  value = "${azurerm_storage_account.bosh_root_storage_account.name}"
}
