# ==============================================
# Quick Deploy Script - Docker Compose (Windows)
# ==============================================

Write-Host "🚀 Starting Laravel Notes - Final Lab Deployment" -ForegroundColor Green
Write-Host "==================================================" -ForegroundColor Green

# Check if .env exists
if (-Not (Test-Path .env)) {
    Write-Host "📋 Creating .env file from .env.example..." -ForegroundColor Yellow
    Copy-Item .env.example .env
    Write-Host "⚠️  Please run 'php artisan key:generate' to set APP_KEY" -ForegroundColor Yellow
} else {
    Write-Host "✅ .env file exists" -ForegroundColor Green
}

# Start Docker Compose services
Write-Host ""
Write-Host "🐳 Starting Docker Compose services..." -ForegroundColor Cyan
docker-compose up -d

# Wait for services to be ready
Write-Host ""
Write-Host "⏳ Waiting for services to start..." -ForegroundColor Yellow
Start-Sleep -Seconds 10

# Check service status
Write-Host ""
Write-Host "📊 Service Status:" -ForegroundColor Cyan
docker-compose ps

# Install dependencies if needed
Write-Host ""
$install = Read-Host "Install Composer dependencies? (y/n)"
if ($install -eq "y" -or $install -eq "Y") {
    Write-Host "📦 Installing Composer dependencies..." -ForegroundColor Cyan
    docker-compose exec -T app composer install --no-interaction
}

# Run migrations
Write-Host ""
$migrate = Read-Host "Run database migrations? (y/n)"
if ($migrate -eq "y" -or $migrate -eq "Y") {
    Write-Host "🔄 Running migrations..." -ForegroundColor Cyan
    docker-compose exec -T app php artisan migrate --force
}

# Display access information
Write-Host ""
Write-Host "==================================================" -ForegroundColor Green
Write-Host "✅ Deployment Complete!" -ForegroundColor Green
Write-Host "==================================================" -ForegroundColor Green
Write-Host ""
Write-Host "🌐 Access URLs:" -ForegroundColor Cyan
Write-Host "   Laravel App:  http://localhost:8080"
Write-Host "   Grafana:      http://localhost:3000 (admin/admin)"
Write-Host "   Prometheus:   http://localhost:9090"
Write-Host ""
Write-Host "🔧 Useful Commands:" -ForegroundColor Cyan
Write-Host "   View logs:       docker-compose logs -f"
Write-Host "   Stop services:   docker-compose down"
Write-Host "   Restart:         docker-compose restart"
Write-Host "   Run tests:       docker-compose exec app php artisan test"
Write-Host ""
Write-Host "==================================================" -ForegroundColor Green
