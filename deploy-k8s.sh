#!/bin/bash

# ==============================================
# Quick Deploy Script - Kubernetes
# ==============================================

echo "🚀 Deploying Laravel Notes to Kubernetes"
echo "=========================================="

# Check if Minikube is running
if ! minikube status > /dev/null 2>&1; then
    echo "❌ Minikube is not running"
    read -p "Start Minikube? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "🚀 Starting Minikube..."
        minikube start --cpus=4 --memory=8192
    else
        echo "⚠️  Please start Minikube manually: minikube start"
        exit 1
    fi
else
    echo "✅ Minikube is running"
fi

# Check APP_KEY in secret
echo ""
echo "⚠️  IMPORTANT: Make sure you've updated k8s/secret.yml with your APP_KEY"
read -p "Have you updated the secret.yml file? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Please update k8s/secret.yml with your Laravel APP_KEY"
    echo "Generate key: php artisan key:generate --show"
    exit 1
fi

# Deploy resources
echo ""
echo "📦 Deploying Kubernetes resources..."

kubectl apply -f k8s/namespace.yml
echo "✅ Namespace created"

kubectl apply -f k8s/configmap.yml
echo "✅ ConfigMap created"

kubectl apply -f k8s/secret.yml
echo "✅ Secret created"

kubectl apply -f k8s/mysql-deployment.yml
echo "✅ MySQL deployed"

echo "⏳ Waiting for MySQL to be ready..."
kubectl wait --for=condition=ready pod -l app=mysql -n laravel-notes --timeout=300s

kubectl apply -f k8s/redis-deployment.yml
echo "✅ Redis deployed"

echo "⏳ Waiting for Redis to be ready..."
kubectl wait --for=condition=ready pod -l app=redis -n laravel-notes --timeout=300s

kubectl apply -f k8s/app-deployment.yml
echo "✅ Application deployed"

kubectl apply -f k8s/monitoring-deployment.yml
echo "✅ Monitoring deployed"

# Display status
echo ""
echo "📊 Deployment Status:"
kubectl get pods -n laravel-notes

echo ""
echo "🌐 Services:"
kubectl get services -n laravel-notes

# Get Minikube IP
MINIKUBE_IP=$(minikube ip)

echo ""
echo "=========================================="
echo "✅ Deployment Complete!"
echo "=========================================="
echo ""
echo "🌐 Access URLs:"
echo "   Laravel App:  http://$MINIKUBE_IP:30080"
echo "   Grafana:      http://$MINIKUBE_IP:30030 (admin/admin)"
echo "   Prometheus:   http://$MINIKUBE_IP:30090"
echo ""
echo "🔧 Useful Commands:"
echo "   View pods:       kubectl get pods -n laravel-notes"
echo "   View logs:       kubectl logs <pod-name> -n laravel-notes"
echo "   Delete all:      kubectl delete namespace laravel-notes"
echo ""
echo "=========================================="
