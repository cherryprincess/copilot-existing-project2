# CI/CD Pipeline Documentation

This repository contains both GitHub Actions and Azure DevOps pipeline configurations for building and deploying the Flask application to Azure Kubernetes Service (AKS).

## 🚀 Pipeline Overview

### GitHub Actions Pipeline (`.github/workflows/build-deploy.yml`)
- **Build Job**: Builds Docker image with build ID as tag and pushes to ACR
- **Deploy Job**: Deploys to AKS cluster using the built image

### Azure DevOps Pipeline (`azure-pipelines.yml`)
- **Build Stage**: Builds Docker image with build number as tag
- **Deploy Stage**: Deploys to AKS cluster in existing namespace

## 📋 Prerequisites

### 1. Azure Resources
- Azure Container Registry (ACR)
- Azure Kubernetes Service (AKS) cluster
- Resource Group
- Service Principal with appropriate permissions

### 2. Repository Secrets/Variables

#### GitHub Secrets:
```
AZURE_CREDENTIALS - Service Principal JSON
REGISTRY_USERNAME - ACR username
REGISTRY_PASSWORD - ACR password
```

#### Azure DevOps Variables:
```
containerRegistry - ACR URL
aksClusterName - AKS cluster name
aksResourceGroup - Resource group name
namespace - Kubernetes namespace
```

## 🔧 Setup Instructions

### Option 1: Automated Setup
Run the PowerShell setup script:
```powershell
.\setup-azure-resources.ps1
```

### Option 2: Manual Setup

#### 1. Create Azure Resources
```bash
# Create Resource Group
az group create --name your-resource-group --location eastus

# Create ACR
az acr create --resource-group your-resource-group --name your-registry --sku Standard --admin-enabled true

# Create AKS
az aks create \
  --resource-group your-resource-group \
  --name your-aks-cluster \
  --node-count 3 \
  --enable-addons monitoring \
  --generate-ssh-keys \
  --attach-acr your-registry
```

#### 2. Create Service Principal
```bash
az ad sp create-for-rbac \
  --name "aks-github-sp" \
  --role contributor \
  --scopes /subscriptions/{subscription-id}/resourceGroups/your-resource-group \
  --sdk-auth
```

#### 3. Configure GitHub Secrets
1. Go to repository → Settings → Secrets and variables → Actions
2. Add the following secrets:
   - `AZURE_CREDENTIALS`: Service Principal JSON output
   - `REGISTRY_USERNAME`: ACR username
   - `REGISTRY_PASSWORD`: ACR password

#### 4. Configure Azure DevOps
1. Create service connection to AKS
2. Update pipeline variables with your values
3. Create environment named "production"

## 🔄 Pipeline Features

### Build Job Features:
- **Multi-platform builds**: Linux/AMD64
- **Layer caching**: GitHub Actions cache
- **Security scanning**: Trivy vulnerability scanner
- **Metadata extraction**: Automated tagging
- **Build ID tagging**: Uses `build-{build-number}` format

### Deploy Job Features:
- **Namespace creation**: Creates namespace if it doesn't exist
- **Rolling updates**: Zero-downtime deployments
- **Health checks**: Validates deployment success
- **Cleanup**: Optional old image cleanup

## 🏷️ Image Tagging Strategy

### GitHub Actions Tags:
- `build-{run-number}` - Primary tag for deployment
- `{branch-name}-{sha}` - Branch-specific tag
- `latest` - Latest from main branch
- `pr-{number}` - Pull request tags

### Azure DevOps Tags:
- `build-{build-number}` - Primary tag for deployment
- `latest` - Latest from main branch

## 🚦 Pipeline Triggers

### GitHub Actions:
- Push to `main` and `develop` branches
- Pull requests to `main` branch
- Manual workflow dispatch

### Azure DevOps:
- Push to `main` and `develop` branches
- Pull requests to `main` branch

## 📊 Security Features

### Build Security:
- Trivy vulnerability scanning
- Non-root container execution
- Minimal base image usage
- Dependency scanning

### Deploy Security:
- Namespace isolation
- Network policies
- Security contexts
- Resource limits
- Read-only root filesystem

## 🔍 Monitoring and Troubleshooting

### Common Issues:

1. **Image Pull Errors**
   ```bash
   kubectl describe pod -n flask-app-namespace
   ```

2. **Deployment Failures**
   ```bash
   kubectl logs -f deployment/flask-app-deployment -n flask-app-namespace
   ```

3. **Service Issues**
   ```bash
   kubectl get svc -n flask-app-namespace
   kubectl describe svc flask-app-service -n flask-app-namespace
   ```

### Useful Commands:
```bash
# Check deployment status
kubectl rollout status deployment/flask-app-deployment -n flask-app-namespace

# View pods
kubectl get pods -n flask-app-namespace

# Port forward for testing
kubectl port-forward svc/flask-app-service 8080:80 -n flask-app-namespace

# View logs
kubectl logs -f deployment/flask-app-deployment -n flask-app-namespace
```

## 📂 File Structure

```
├── .github/workflows/
│   └── build-deploy.yml          # GitHub Actions workflow
├── azure-pipelines.yml           # Azure DevOps pipeline
├── k8s-complete-deployment.yaml  # Complete K8s deployment
├── k8s-deployment-template.yaml  # Template with token replacement
├── setup-azure-resources.ps1     # Setup script
├── Dockerfile                    # Docker image definition
└── CI_CD_README.md               # This file
```

## 🔄 Deployment Process

1. **Code Push**: Developer pushes code to repository
2. **Build Trigger**: Pipeline triggered automatically
3. **Image Build**: Docker image built with build ID tag
4. **Security Scan**: Trivy scans for vulnerabilities
5. **Push to ACR**: Image pushed to Azure Container Registry
6. **Deploy Trigger**: Deploy job starts (main branch only)
7. **K8s Deploy**: Image deployed to AKS cluster
8. **Health Check**: Deployment validated and tested

## 📈 Performance Optimization

### Build Optimization:
- Docker layer caching
- Multi-stage builds
- Minimal image size
- Parallel job execution

### Deploy Optimization:
- Rolling updates
- Resource limits
- Health checks
- Namespace isolation

## 🔒 Security Best Practices

1. **Secrets Management**: All sensitive data in secrets
2. **Least Privilege**: Minimal permissions for service accounts
3. **Network Security**: Network policies implemented
4. **Container Security**: Non-root execution, read-only filesystem
5. **Image Security**: Regular vulnerability scanning
6. **Resource Limits**: CPU/memory constraints

## 🆘 Support

For issues or questions:
1. Check pipeline logs in GitHub Actions/Azure DevOps
2. Review Kubernetes events: `kubectl get events -n flask-app-namespace`
3. Check application logs: `kubectl logs -f deployment/flask-app-deployment -n flask-app-namespace`
4. Verify service connectivity: `kubectl get svc -n flask-app-namespace`
