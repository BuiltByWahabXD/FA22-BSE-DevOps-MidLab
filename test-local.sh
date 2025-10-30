#!/bin/bash
# Local Testing Script for CI/CD Pipeline

echo "=================================="
echo "Laravel CI/CD - Local Test Runner"
echo "=================================="
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test 1: Check if Docker containers are running
echo "📦 Checking Docker containers..."
if docker-compose ps | grep -q "Up"; then
    echo -e "${GREEN}✓ Docker containers are running${NC}"
else
    echo -e "${RED}✗ Docker containers are not running${NC}"
    echo "Run: docker-compose up -d"
    exit 1
fi
echo ""

# Test 2: Install Composer dependencies
echo "📚 Installing Composer dependencies..."
docker-compose exec -T app composer install --no-interaction --quiet
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Composer dependencies installed${NC}"
else
    echo -e "${RED}✗ Failed to install Composer dependencies${NC}"
    exit 1
fi
echo ""

# Test 3: Run database migrations
echo "🗄️ Running database migrations..."
docker-compose exec -T app php artisan migrate --force
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Database migrations completed${NC}"
else
    echo -e "${RED}✗ Database migrations failed${NC}"
    exit 1
fi
echo ""

# Test 4: Run PHPUnit tests
echo "🧪 Running PHPUnit tests..."
docker-compose exec -T app php artisan test
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ All tests passed${NC}"
else
    echo -e "${RED}✗ Some tests failed${NC}"
    exit 1
fi
echo ""

# Test 5: Run Laravel Pint (Code Style)
echo "🎨 Checking code style with Laravel Pint..."
docker-compose exec -T app ./vendor/bin/pint --test
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Code style is correct${NC}"
else
    echo -e "${YELLOW}⚠ Code style needs formatting (not critical)${NC}"
fi
echo ""

# Test 6: Check if application is accessible
echo "🌐 Checking if application is accessible..."
if curl -s http://localhost:8080 > /dev/null; then
    echo -e "${GREEN}✓ Application is accessible at http://localhost:8080${NC}"
else
    echo -e "${RED}✗ Application is not accessible${NC}"
    exit 1
fi
echo ""

echo "=================================="
echo -e "${GREEN}✓ All checks passed!${NC}"
echo "You can now commit and push your changes."
echo "=================================="
