# Docker Security Best Practices Configuration
# This file documents the security measures implemented in the Dockerfile

## Security Measures Implemented:

### 1. Base Image Security
- Uses official Python 3.11.10-slim-bullseye image (specific version, not latest)
- Slim image reduces attack surface
- Bullseye is a stable Debian release with security updates

### 2. User Security
- Creates and runs as non-root user 'appuser'
- Prevents privilege escalation attacks
- Follows principle of least privilege

### 3. System Security
- Updates system packages and installs security patches
- Removes package manager cache to reduce image size
- Only installs necessary system packages

### 4. Python Security
- Upgrades pip to latest version
- Uses --no-cache-dir to prevent cache-related vulnerabilities
- Pins pip version for reproducibility

### 5. Application Security
- Sets FLASK_ENV=production (disables debug mode)
- Sets PYTHONDONTWRITEBYTECODE=1 (prevents .pyc files)
- Sets PYTHONUNBUFFERED=1 (prevents output buffering)

### 6. Container Security
- Includes health check for container monitoring
- Uses exec form of CMD for proper signal handling
- Exposes only necessary port (8080)

### 7. Build Security
- Uses .dockerignore to exclude sensitive files
- Excludes test files, documentation, and development tools
- Multi-stage approach with dependency caching

## Build Command:
docker build -t flask-app:secure .

## Run Command (with additional security):
docker run -d \
  --name flask-app \
  --read-only \
  --tmpfs /tmp \
  --tmpfs /var/tmp \
  --security-opt=no-new-privileges \
  --cap-drop=ALL \
  --user appuser \
  -p 8080:8080 \
  flask-app:secure

## Security Scanning:
# Run these commands to scan for vulnerabilities:
# docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy image flask-app:secure
# docker run --rm -v /var/run/docker.sock:/var/run/docker.sock clair-scanner flask-app:secure
