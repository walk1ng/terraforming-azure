# ================================= Subnets ====================================

resource "azurerm_subnet" "pas_subnet" {
  name = "${var.env_name}-pas-subnet"

  //  depends_on                = ["${var.resource_group_name}"]
  resource_group_name       = "${var.resource_group_name}"
  virtual_network_name      = "${var.network_name}"
  address_prefix            = "${var.pas_subnet_cidr}"
  network_security_group_id = "${var.bosh_deployed_vms_security_group_id}"
}

resource "azurerm_subnet" "services_subnet" {
  name = "${var.env_name}-services-subnet"

  //  depends_on                = ["${var.resource_group_name}"]
  resource_group_name       = "${var.resource_group_name}"
  virtual_network_name      = "${var.network_name}"
  address_prefix            = "${var.services_subnet_cidr}"
  network_security_group_id = "${var.bosh_deployed_vms_security_group_id}"
}

resource "azurerm_subnet" "dynamic_services_subnet" {
  name = "${var.env_name}-dynamic-services-subnet"

  //  depends_on                = ["${var.resource_group_name}"]
  resource_group_name       = "${var.resource_group_name}"
  virtual_network_name      = "${var.network_name}"
  address_prefix            = "${var.dynamic_services_subnet_cidr}"
  network_security_group_id = "${var.bosh_deployed_vms_security_group_id}"
}
