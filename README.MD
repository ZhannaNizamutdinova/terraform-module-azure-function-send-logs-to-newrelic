# Terraform module to create Azure Function 
## Description
This terraform module automates creation of Azure function, which is triggered by Event Hub and is able to send Azure logs to New Relic.

Used documentation:
1. [azurerm_function_app](https://www.terraform.io/docs/providers/azurerm/r/function_app.html) Manages a Function App.
2. [azurerm_app_service_plan](https://www.terraform.io/docs/providers/azurerm/r/app_service_plan.html) Manages an App Service Plan component.
