# Kubernetes Deployment for Flask Application

This directory contains Kubernetes deployment files for the Flask change calculator application.

## Files Overview

- `k8s-complete-deployment.yaml` - Complete deployment with all resources
- `k8s-deployment.yaml` - Standalone deployment and service
- `k8s-namespace.yaml` - Namespace configuration
- `k8s-configmap.yaml` - Application configuration
- `k8s-deploy.sh` - Deployment script (Linux/Mac)
- `k8s-deploy.ps1` - Deployment script (Windows PowerShell)

## Deployment Resources

### 1. Namespace
- **Name**: `flask-app-namespace`
- **Purpose**: Isolates the application resources

### 2. ConfigMap
- **Name**: `flask-app-config`
- **Purpose**: Stores application configuration
- **Environment Variables**:
  - `FLASK_ENV=production`
  - `PYTHONUNBUFFERED=1`
  - `PYTHONDONTWRITEBYTECODE=1`

### 3. Deployment
- **Name**: `flask-app-deployment`
- **Replicas**: 3
- **Strategy**: RollingUpdate
- **Security Features**:
  - Runs as non-root user (UID 1000)
  - Read-only root filesystem
  - Drops all capabilities
  - Security profiles enabled

### 4. Service
- **Name**: `flask-app-service`
- **Type**: ClusterIP
- **Port**: 80 (external) → 8080 (internal)
- **Purpose**: Provides internal cluster access

### 5. NetworkPolicy
- **Name**: `flask-app-netpol`
- **Purpose**: Controls network traffic
- **Ingress**: Allows traffic from within cluster
- **Egress**: DNS and HTTPS traffic only

## Prerequisites

1. **Kubernetes Cluster**: Running cluster with kubectl configured
2. **Docker Image**: Built and available in cluster
3. **Permissions**: RBAC permissions for namespace and resource creation

## Quick Deployment

### Using PowerShell (Windows):
```powershell
.\k8s-deploy.ps1
```

### Using Bash (Linux/Mac):
```bash
chmod +x k8s-deploy.sh
./k8s-deploy.sh
```

### Manual Deployment:
```bash
# Build Docker image
docker build -t flask-app:secure .

# Deploy to Kubernetes
kubectl apply -f k8s-complete-deployment.yaml

# Verify deployment
kubectl get all -n flask-app-namespace
```

## Testing the Application

1. **Port Forward** (for local testing):
   ```bash
   kubectl port-forward service/flask-app-service 8080:80 -n flask-app-namespace
   ```

2. **Test Endpoints**:
   - Health check: `http://localhost:8080/`
   - Change calculator: `http://localhost:8080/change/1/25`

## Management Commands

### Scaling
```bash
kubectl scale deployment flask-app-deployment --replicas=5 -n flask-app-namespace
```

### Updating
```bash
kubectl set image deployment/flask-app-deployment flask-app=flask-app:v2 -n flask-app-namespace
```

### Monitoring
```bash
# Check status
kubectl rollout status deployment/flask-app-deployment -n flask-app-namespace

# View logs
kubectl logs -f deployment/flask-app-deployment -n flask-app-namespace

# Describe resources
kubectl describe deployment flask-app-deployment -n flask-app-namespace
```

### Cleanup
```bash
kubectl delete -f k8s-complete-deployment.yaml
```

## Security Features

- **Non-root execution**: Runs as UID 1000
- **Read-only filesystem**: Prevents runtime modifications
- **Capability dropping**: Removes all Linux capabilities
- **Network policies**: Restricts network access
- **Resource limits**: Prevents resource exhaustion
- **Security contexts**: Multiple layers of security

## Troubleshooting

### Common Issues:

1. **Image Pull Errors**: Ensure Docker image is built and available
2. **Permission Denied**: Check RBAC permissions
3. **Pod Not Starting**: Check resource limits and node capacity
4. **Network Issues**: Verify NetworkPolicy configuration

### Debug Commands:
```bash
# Check pod status
kubectl get pods -n flask-app-namespace

# Describe pod
kubectl describe pod <pod-name> -n flask-app-namespace

# Check events
kubectl get events -n flask-app-namespace

# Check logs
kubectl logs <pod-name> -n flask-app-namespace
```

## Production Considerations

- **Resource Limits**: Adjust based on actual usage
- **Replicas**: Scale based on load requirements
- **Monitoring**: Implement monitoring and alerting
- **Ingress**: Add ingress controller for external access
- **Secrets**: Use Kubernetes secrets for sensitive data
- **Persistent Storage**: Add if application requires data persistence
