terraform {
  required_version = ">= 0.13.0"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

provider "azurerm" {
  version = "=2.25.0"
  features {}
}

provider "archive" {}
