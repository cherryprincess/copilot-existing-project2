# Setup Script for Azure DevOps/GitHub Actions Integration
# This script helps set up the necessary Azure resources and secrets

# Variables - Update these with your values
$RESOURCE_GROUP = "your-resource-group"
$LOCATION = "eastus"
$AKS_CLUSTER_NAME = "your-aks-cluster"
$ACR_NAME = "your-registry"
$SERVICE_PRINCIPAL_NAME = "aks-github-sp"
$NAMESPACE = "flask-app-namespace"

Write-Host "Setting up Azure resources for CI/CD pipeline..." -ForegroundColor Green

# Create Resource Group
Write-Host "Creating resource group..." -ForegroundColor Yellow
az group create --name $RESOURCE_GROUP --location $LOCATION

# Create Azure Container Registry
Write-Host "Creating Azure Container Registry..." -ForegroundColor Yellow
az acr create --resource-group $RESOURCE_GROUP --name $ACR_NAME --sku Standard --admin-enabled true

# Create AKS Cluster
Write-Host "Creating AKS cluster..." -ForegroundColor Yellow
az aks create `
  --resource-group $RESOURCE_GROUP `
  --name $AKS_CLUSTER_NAME `
  --node-count 3 `
  --enable-addons monitoring `
  --generate-ssh-keys `
  --attach-acr $ACR_NAME

# Get AKS credentials
Write-Host "Getting AKS credentials..." -ForegroundColor Yellow
az aks get-credentials --resource-group $RESOURCE_GROUP --name $AKS_CLUSTER_NAME

# Create service principal for GitHub Actions
Write-Host "Creating service principal..." -ForegroundColor Yellow
$SP_JSON = az ad sp create-for-rbac --name $SERVICE_PRINCIPAL_NAME --role contributor --scopes /subscriptions/(az account show --query id --output tsv)/resourceGroups/$RESOURCE_GROUP --sdk-auth

# Get ACR credentials
Write-Host "Getting ACR credentials..." -ForegroundColor Yellow
$ACR_USERNAME = az acr credential show --name $ACR_NAME --query username --output tsv
$ACR_PASSWORD = az acr credential show --name $ACR_NAME --query passwords[0].value --output tsv

# Create namespace in AKS
Write-Host "Creating namespace in AKS..." -ForegroundColor Yellow
kubectl create namespace $NAMESPACE --dry-run=client -o yaml | kubectl apply -f -

Write-Host "Setup completed!" -ForegroundColor Green
Write-Host ""
Write-Host "=== GitHub Secrets to Configure ===" -ForegroundColor Cyan
Write-Host "AZURE_CREDENTIALS: $SP_JSON"
Write-Host "AZURE_CONTAINER_REGISTRY: $ACR_NAME.azurecr.io"
Write-Host "REGISTRY_USERNAME: $ACR_USERNAME"
Write-Host "REGISTRY_PASSWORD: $ACR_PASSWORD"
Write-Host "AKS_CLUSTER_NAME: $AKS_CLUSTER_NAME"
Write-Host "AKS_RESOURCE_GROUP: $RESOURCE_GROUP"
Write-Host ""
Write-Host "=== Workflow Environment Variables (automatically configured) ===" -ForegroundColor Cyan
Write-Host "NAMESPACE: $NAMESPACE"
Write-Host ""
Write-Host "=== Next Steps ===" -ForegroundColor Magenta
Write-Host "1. Add the above secrets to your GitHub repository"
Write-Host "2. Update the workflow file with your specific values"
Write-Host "3. Update the Azure DevOps pipeline with your service connection"
Write-Host "4. Test the pipeline by pushing to main branch"
