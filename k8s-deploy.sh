# Kubernetes Deployment Script for Flask Application
# This script provides commands to deploy and manage the Flask application

# Build and tag the Docker image
docker build -t flask-app:secure .

# Apply the complete deployment (includes namespace, configmap, deployment, service, and network policy)
kubectl apply -f k8s-complete-deployment.yaml

# Verify deployment
kubectl get all -n flask-app-namespace

# Check deployment status
kubectl rollout status deployment/flask-app-deployment -n flask-app-namespace

# Get service information
kubectl get service flask-app-service -n flask-app-namespace

# Port forward to test the application locally
kubectl port-forward service/flask-app-service 8080:80 -n flask-app-namespace

# Scale the deployment
kubectl scale deployment flask-app-deployment --replicas=5 -n flask-app-namespace

# Update deployment with new image
kubectl set image deployment/flask-app-deployment flask-app=flask-app:secure -n flask-app-namespace

# Delete deployment
kubectl delete -f k8s-complete-deployment.yaml

# View logs
kubectl logs -f deployment/flask-app-deployment -n flask-app-namespace

# Describe deployment
kubectl describe deployment flask-app-deployment -n flask-app-namespace
