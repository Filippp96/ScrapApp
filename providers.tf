terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.27.0"
    }
  }

  cloud {
    organization = "deepdive_cg_fk"
    workspaces {
      name = "ScrapApp_Production"
    }
  }
}

provider "azurerm" {
  subscription_id = "81d677b5-e197-4b2e-b9fc-254b49d7a794"
  features {
  }
}