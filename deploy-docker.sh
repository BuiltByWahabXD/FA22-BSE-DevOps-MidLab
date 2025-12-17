#!/bin/bash

# ==============================================
# Quick Deploy Script - Docker Compose
# ==============================================

echo "🚀 Starting Laravel Notes - Final Lab Deployment"
echo "=================================================="

# Check if .env exists
if [ ! -f .env ]; then
    echo "📋 Creating .env file from .env.example..."
    cp .env.example .env
    echo "⚠️  Please run 'php artisan key:generate' to set APP_KEY"
else
    echo "✅ .env file exists"
fi

# Start Docker Compose services
echo ""
echo "🐳 Starting Docker Compose services..."
docker-compose up -d

# Wait for services to be ready
echo ""
echo "⏳ Waiting for services to start..."
sleep 10

# Check service status
echo ""
echo "📊 Service Status:"
docker-compose ps

# Install dependencies if needed
echo ""
read -p "Install Composer dependencies? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "📦 Installing Composer dependencies..."
    docker-compose exec -T app composer install --no-interaction
fi

# Run migrations
echo ""
read -p "Run database migrations? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🔄 Running migrations..."
    docker-compose exec -T app php artisan migrate --force
fi

# Display access information
echo ""
echo "=================================================="
echo "✅ Deployment Complete!"
echo "=================================================="
echo ""
echo "🌐 Access URLs:"
echo "   Laravel App:  http://localhost:8080"
echo "   Grafana:      http://localhost:3000 (admin/admin)"
echo "   Prometheus:   http://localhost:9090"
echo ""
echo "🔧 Useful Commands:"
echo "   View logs:       docker-compose logs -f"
echo "   Stop services:   docker-compose down"
echo "   Restart:         docker-compose restart"
echo "   Run tests:       docker-compose exec app php artisan test"
echo ""
echo "=================================================="
