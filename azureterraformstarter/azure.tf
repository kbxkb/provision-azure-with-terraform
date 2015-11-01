# Connect to the Azure Provider
# Environment variable AZURE_SETTINGS_FILE is set to file path for the settings_file...
provider "azure" {
}

# create a storage account
resource "azure_storage_service" "storage" {
        name = "tfteststorage1"
        location = "South Central US"
        description = "Made by Terraform"
        account_type = "Standard_LRS"
}
