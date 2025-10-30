# Local Testing Script for CI/CD Pipeline (PowerShell)
# Run this before committing to ensure everything works

Write-Host "==================================" -ForegroundColor Cyan
Write-Host "Laravel CI/CD - Local Test Runner" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""

$ErrorActionPreference = "Continue"
$allTestsPassed = $true

# Test 1: Check if Docker containers are running
Write-Host "📦 Checking Docker containers..." -ForegroundColor Yellow
$containers = docker-compose ps
if ($containers -match "Up") {
    Write-Host "✓ Docker containers are running" -ForegroundColor Green
} else {
    Write-Host "✗ Docker containers are not running" -ForegroundColor Red
    Write-Host "Run: docker-compose up -d" -ForegroundColor Yellow
    exit 1
}
Write-Host ""

# Test 2: Install Composer dependencies
Write-Host "📚 Installing Composer dependencies..." -ForegroundColor Yellow
docker-compose exec -T app composer install --no-interaction --quiet 2>&1 | Out-Null
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Composer dependencies installed" -ForegroundColor Green
} else {
    Write-Host "✗ Failed to install Composer dependencies" -ForegroundColor Red
    $allTestsPassed = $false
}
Write-Host ""

# Test 3: Run database migrations
Write-Host "🗄️ Running database migrations..." -ForegroundColor Yellow
$migrationOutput = docker-compose exec -T app php artisan migrate --force 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Database migrations completed" -ForegroundColor Green
} else {
    Write-Host "✗ Database migrations failed" -ForegroundColor Red
    Write-Host $migrationOutput -ForegroundColor Red
    $allTestsPassed = $false
}
Write-Host ""

# Test 4: Run PHPUnit tests
Write-Host "🧪 Running PHPUnit tests..." -ForegroundColor Yellow
Write-Host "This may take 20-30 seconds..." -ForegroundColor Gray
$testOutput = docker-compose exec -T app php artisan test 2>&1
Write-Host $testOutput
if ($testOutput -match "Tests:.*passed" -and $LASTEXITCODE -eq 0) {
    Write-Host "✓ All tests passed" -ForegroundColor Green
} else {
    Write-Host "✗ Some tests failed" -ForegroundColor Red
    $allTestsPassed = $false
}
Write-Host ""

# Test 5: Run Laravel Pint (Code Style)
Write-Host "🎨 Checking code style with Laravel Pint..." -ForegroundColor Yellow
docker-compose exec -T app ./vendor/bin/pint --test 2>&1 | Out-Null
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Code style is correct" -ForegroundColor Green
} else {
    Write-Host "⚠ Code style needs formatting (not critical)" -ForegroundColor Yellow
}
Write-Host ""

# Test 6: Check if application is accessible
Write-Host "🌐 Checking if application is accessible..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8080" -UseBasicParsing -TimeoutSec 5
    if ($response.StatusCode -eq 200 -or $response.StatusCode -eq 302) {
        Write-Host "✓ Application is accessible at http://localhost:8080" -ForegroundColor Green
    }
} catch {
    Write-Host "✗ Application is not accessible" -ForegroundColor Red
    $allTestsPassed = $false
}
Write-Host ""

# Final summary
Write-Host "==================================" -ForegroundColor Cyan
if ($allTestsPassed) {
    Write-Host "✓ All checks passed!" -ForegroundColor Green
    Write-Host "You can now commit and push your changes." -ForegroundColor Green
    Write-Host "==================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Yellow
    Write-Host "1. Review your changes: git status" -ForegroundColor White
    Write-Host "2. Add files: git add ." -ForegroundColor White
    Write-Host "3. Commit: git commit -m 'Add CI/CD pipeline with GitHub Actions'" -ForegroundColor White
    Write-Host "4. Push: git push origin main" -ForegroundColor White
} else {
    Write-Host "⚠ Some tests failed. Please fix the issues before committing." -ForegroundColor Yellow
    Write-Host "==================================" -ForegroundColor Cyan
}
