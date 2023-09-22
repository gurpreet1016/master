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

# Create an Azure DevOps pipeline job to run Snyk for security scanning
resource "azurerm_devops_build_pipeline" "snyk_job" {
  project_id    = "CF_project_id"  
  name          = "Snyk Job"
  agent_pool_id = "CF_agent_pool_id" 
  repository {
    repo_type   = "TfsGit"
    repo_id     = "CF_repo_id" 
    branch_name = "main"  
  }

  configuration {
    repository_id = "CF_repo_id"  
    filename      = "azure-pipelines.yml"
  }

  triggers {
    batch_push_enabled = true
    branches           = ["main"]
  }

  # Add a job to run Snyk for security scanning. Snyk helps to find out about the misconfiguration. I have had experience with snyk so I am adding its reference. 
  job {
    job_name   = "Run Snyk"
    job_type   = "job"
    depends_on = []

    steps {
      # Installing Node.js and Snyk CLI
      script {
        script = """
          # Install Node.js which is a dependency
          curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
          sudo apt-get install -y nodejs

          # Install Snyk CLI globally
          sudo npm install -g snyk

          # Run Snyk security scan on the code
          snyk test
        """
      }
    }
  }
}


