data "template_file" "index" {
  template = "${file("${path.module}/files/index.js")}"
}

data "template_file" "function" {
  template = "${file("${path.module}/files/function.json")}"
  vars = {
    event_hub_name = var.event_hub_name
  }
}

data "template_file" "host" {
  template = "${file("${path.module}/files/host.json")}"
}

data "archive_file" "functionapp" {
  type        = "zip"
  output_path = "${path.module}/files/functionapp.zip"

  source {
    content  = "${data.template_file.index.rendered}"
    filename = "EventHubTrigger/index.js"
  }

  source {
    content  = "${data.template_file.function.rendered}"
    filename = "EventHubTrigger/function.json"
  }

  source {
    content  = "${data.template_file.host.rendered}"
    filename = "host.json"
  }
}

resource "azurerm_storage_account" "functionapp" {
  name                     = var.storage_account_name
  resource_group_name      = var.rg_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = var.tags
}

resource "azurerm_storage_container" "functionapp" {
  name                  = var.storage_container_name
  storage_account_name  = azurerm_storage_account.functionapp.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "functionapp" {
  name                   = "functionapp.zip"
  storage_account_name   = azurerm_storage_account.functionapp.name
  storage_container_name = azurerm_storage_container.functionapp.name
  type                   = "Block"
  source                 = "${path.module}/files/functionapp.zip"
}

data "azurerm_storage_account_sas" "functionapp" {
  connection_string = "${azurerm_storage_account.functionapp.primary_connection_string}"
  https_only        = true
  start             = "2020-10-01"
  expiry            = "2022-10-01"
  resource_types {
    object    = true
    container = false
    service   = false
  }
  services {
    blob  = true
    queue = false
    table = false
    file  = false
  }
  permissions {
    read    = true
    write   = false
    delete  = false
    list    = false
    add     = false
    create  = false
    update  = false
    process = false
  }
}

resource "azurerm_app_service_plan" "functionapp" {
  name                = var.azure_app_service_plan_name
  location            = var.location
  resource_group_name = var.rg_name
  kind                = "FunctionApp"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }

  tags = var.tags
}

resource "azurerm_function_app" "functionapp" {
  name                       = var.function_app_name
  location                   = var.location
  resource_group_name        = var.rg_name
  app_service_plan_id        = azurerm_app_service_plan.functionapp.id
  storage_account_name       = azurerm_storage_account.functionapp.name
  storage_account_access_key = azurerm_storage_account.functionapp.primary_access_key
  tags                       = var.tags
  version                    = "~3"
  app_settings = {
    FUNCTIONS_WORKER_RUNTIME : "node"
    WEBSITE_NODE_DEFAULT_VERSION : "~12"
    https_only : "true"
    FUNCTION_APP_EDIT_MODE : "readonly"
    NR_INSERT_KEY : var.nr_insert_key
    NR_TAGS : var.nr_tags
    EventHub : "${var.event_hub_namespace_default_primary_connection_string};EntityPath=${var.event_hub_name}"
    WEBSITE_RUN_FROM_PACKAGE : "https://${azurerm_storage_account.functionapp.name}.blob.core.windows.net/${azurerm_storage_container.functionapp.name}/${azurerm_storage_blob.functionapp.name}${data.azurerm_storage_account_sas.functionapp.sas}"
  }

}


