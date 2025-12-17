# ==============================================
# Quick Deploy Script - Kubernetes (Windows)
# ==============================================

Write-Host "🚀 Deploying Laravel Notes to Kubernetes" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green

# Check if Minikube is running
$minikubeStatus = minikube status 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Minikube is not running" -ForegroundColor Red
    $start = Read-Host "Start Minikube? (y/n)"
    if ($start -eq "y" -or $start -eq "Y") {
        Write-Host "🚀 Starting Minikube..." -ForegroundColor Cyan
        minikube start --cpus=4 --memory=8192
    } else {
        Write-Host "⚠️  Please start Minikube manually: minikube start" -ForegroundColor Yellow
        exit 1
    }
} else {
    Write-Host "✅ Minikube is running" -ForegroundColor Green
}

# Check APP_KEY in secret
Write-Host ""
Write-Host "⚠️  IMPORTANT: Make sure you've updated k8s/secret.yml with your APP_KEY" -ForegroundColor Yellow
$updated = Read-Host "Have you updated the secret.yml file? (y/n)"
if ($updated -ne "y" -and $updated -ne "Y") {
    Write-Host "Please update k8s/secret.yml with your Laravel APP_KEY" -ForegroundColor Yellow
    Write-Host "Generate key: php artisan key:generate --show"
    exit 1
}

# Deploy resources
Write-Host ""
Write-Host "📦 Deploying Kubernetes resources..." -ForegroundColor Cyan

kubectl apply -f k8s/namespace.yml
Write-Host "✅ Namespace created" -ForegroundColor Green

kubectl apply -f k8s/configmap.yml
Write-Host "✅ ConfigMap created" -ForegroundColor Green

kubectl apply -f k8s/secret.yml
Write-Host "✅ Secret created" -ForegroundColor Green

kubectl apply -f k8s/mysql-deployment.yml
Write-Host "✅ MySQL deployed" -ForegroundColor Green

Write-Host "⏳ Waiting for MySQL to be ready..." -ForegroundColor Yellow
kubectl wait --for=condition=ready pod -l app=mysql -n laravel-notes --timeout=300s

kubectl apply -f k8s/redis-deployment.yml
Write-Host "✅ Redis deployed" -ForegroundColor Green

Write-Host "⏳ Waiting for Redis to be ready..." -ForegroundColor Yellow
kubectl wait --for=condition=ready pod -l app=redis -n laravel-notes --timeout=300s

kubectl apply -f k8s/app-deployment.yml
Write-Host "✅ Application deployed" -ForegroundColor Green

kubectl apply -f k8s/monitoring-deployment.yml
Write-Host "✅ Monitoring deployed" -ForegroundColor Green

# Display status
Write-Host ""
Write-Host "📊 Deployment Status:" -ForegroundColor Cyan
kubectl get pods -n laravel-notes

Write-Host ""
Write-Host "🌐 Services:" -ForegroundColor Cyan
kubectl get services -n laravel-notes

# Get Minikube IP
$minikubeIP = minikube ip

Write-Host ""
Write-Host "==========================================" -ForegroundColor Green
Write-Host "✅ Deployment Complete!" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
Write-Host ""
Write-Host "🌐 Access URLs:" -ForegroundColor Cyan
Write-Host "   Laravel App:  http://$minikubeIP:30080"
Write-Host "   Grafana:      http://$minikubeIP:30030 (admin/admin)"
Write-Host "   Prometheus:   http://$minikubeIP:30090"
Write-Host ""
Write-Host "🔧 Useful Commands:" -ForegroundColor Cyan
Write-Host "   View pods:       kubectl get pods -n laravel-notes"
Write-Host "   View logs:       kubectl logs <pod-name> -n laravel-notes"
Write-Host "   Delete all:      kubectl delete namespace laravel-notes"
Write-Host ""
Write-Host "==========================================" -ForegroundColor Green
