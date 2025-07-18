# Kubernetes Deployment Script for Flask Application (PowerShell)
# This script provides commands to deploy and manage the Flask application

Write-Host "Building Docker image..." -ForegroundColor Green
docker build -t flask-app:secure .

Write-Host "Applying Kubernetes deployment..." -ForegroundColor Green
kubectl apply -f k8s-complete-deployment.yaml

Write-Host "Verifying deployment..." -ForegroundColor Green
kubectl get all -n flask-app-namespace

Write-Host "Checking deployment status..." -ForegroundColor Green
kubectl rollout status deployment/flask-app-deployment -n flask-app-namespace

Write-Host "Getting service information..." -ForegroundColor Green
kubectl get service flask-app-service -n flask-app-namespace

Write-Host "Deployment completed successfully!" -ForegroundColor Green
Write-Host "To test the application, run:" -ForegroundColor Yellow
Write-Host "kubectl port-forward service/flask-app-service 8080:80 -n flask-app-namespace" -ForegroundColor Yellow
Write-Host "Then visit http://localhost:8080" -ForegroundColor Yellow

# Additional useful commands
Write-Host "`nUseful commands:" -ForegroundColor Cyan
Write-Host "Scale deployment: kubectl scale deployment flask-app-deployment --replicas=5 -n flask-app-namespace"
Write-Host "View logs: kubectl logs -f deployment/flask-app-deployment -n flask-app-namespace"
Write-Host "Delete deployment: kubectl delete -f k8s-complete-deployment.yaml"
