# GitHub Secrets Configuration Guide
# Run this after setting up your Azure resources

Write-Host "GitHub Secrets Configuration Guide" -ForegroundColor Green
Write-Host "=================================" -ForegroundColor Green
Write-Host ""

Write-Host "1. Go to your GitHub repository" -ForegroundColor Yellow
Write-Host "2. Navigate to Settings > Secrets and variables > Actions" -ForegroundColor Yellow
Write-Host "3. Add the following secrets:" -ForegroundColor Yellow
Write-Host ""

Write-Host "Required Secrets:" -ForegroundColor Cyan
Write-Host "=================" -ForegroundColor Cyan
Write-Host ""

Write-Host "AZURE_CREDENTIALS" -ForegroundColor White
Write-Host "  Description: Service Principal JSON for Azure authentication"
Write-Host "  Example: { 'clientId': '...', 'clientSecret': '...', 'subscriptionId': '...', 'tenantId': '...' }"
Write-Host ""

Write-Host "AZURE_CONTAINER_REGISTRY" -ForegroundColor White
Write-Host "  Description: Your Azure Container Registry URL"
Write-Host "  Example: myregistry.azurecr.io"
Write-Host ""

Write-Host "REGISTRY_USERNAME" -ForegroundColor White
Write-Host "  Description: ACR username (usually the ACR name)"
Write-Host "  Example: myregistry"
Write-Host ""

Write-Host "REGISTRY_PASSWORD" -ForegroundColor White
Write-Host "  Description: ACR password/token"
Write-Host "  Example: (ACR admin password from Azure portal)"
Write-Host ""

Write-Host "AKS_CLUSTER_NAME" -ForegroundColor White
Write-Host "  Description: Your AKS cluster name"
Write-Host "  Example: my-aks-cluster"
Write-Host ""

Write-Host "AKS_RESOURCE_GROUP" -ForegroundColor White
Write-Host "  Description: Resource group containing your AKS cluster"
Write-Host "  Example: my-resource-group"
Write-Host ""

Write-Host "Commands to get the required values:" -ForegroundColor Magenta
Write-Host "====================================" -ForegroundColor Magenta
Write-Host ""

Write-Host "# Get ACR login server" -ForegroundColor Gray
Write-Host "az acr show --name <your-acr-name> --query loginServer --output tsv" -ForegroundColor Gray
Write-Host ""

Write-Host "# Get ACR credentials" -ForegroundColor Gray
Write-Host "az acr credential show --name <your-acr-name>" -ForegroundColor Gray
Write-Host ""

Write-Host "# Create service principal" -ForegroundColor Gray
Write-Host "az ad sp create-for-rbac --name 'github-actions-sp' --role contributor --scopes /subscriptions/{subscription-id}/resourceGroups/{resource-group} --sdk-auth" -ForegroundColor Gray
Write-Host ""

Write-Host "# Get AKS info" -ForegroundColor Gray
Write-Host "az aks show --resource-group <resource-group> --name <cluster-name> --query name --output tsv" -ForegroundColor Gray
Write-Host ""

Write-Host "Example values (replace with your actual values):" -ForegroundColor Red
Write-Host "=================================================" -ForegroundColor Red
Write-Host "AZURE_CONTAINER_REGISTRY: mycompany.azurecr.io"
Write-Host "REGISTRY_USERNAME: mycompany"
Write-Host "AKS_CLUSTER_NAME: my-production-cluster"
Write-Host "AKS_RESOURCE_GROUP: production-rg"
