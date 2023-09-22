# Define the provide
provider "azurerm" {
  features {}
}

# Creation of an Azure DevOps service connection for Azure Container Registry (ACR)
resource "azurerm_devops_service_connection_azurerm" "acr_connection" {
  project_id           = "CF_12344"
  service_connection_name = "acr-connection"
  azurerm_service_connection_type_id = "arm"
  description          = "Azure Container Registry Service Connection"


# Providing all the relevant information for the service
  service_endpoint {
    service_endpoint_type = "azurerm"
    details = <<EOF
      {
        "environmentName": "AzureCloud",
        "scopeLevel": "managementGroup",
        "subscriptionId": "12345", 
        "subscriptionName": "CF_Subscription", 
        "resourceGroupName": "CF_acr_resource_group", 
        "registryLoginServer": "CF_acr_name.azurecr.io",  
        "registryId": "/subscriptions/CF_subscription_id/resourceGroups/CF_acr_resource_group/providers/Microsoft.ContainerRegistry/registries/CF_acr_name", 
        "defaultResourceGroup": "CF_acr_resource_group", 
        "creationMode": "Automatic",
        "managedBy": null
      }
EOF
  }
}


    
