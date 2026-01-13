# Laravel Notes Application - DevOps Final Lab
### Complete CI/CD Pipeline with Infrastructure as Code

![Laravel](https://img.shields.io/badge/Laravel-11.x-red?style=flat-square&logo=laravel)
![PHP](https://img.shields.io/badge/PHP-8.2+-blue?style=flat-square&logo=php)
![MySQL](https://img.shields.io/badge/MySQL-8.0-orange?style=flat-square&logo=mysql)
![Redis](https://img.shields.io/badge/Redis-7-red?style=flat-square&logo=redis)
![Docker](https://img.shields.io/badge/Docker-Enabled-blue?style=flat-square&logo=docker)
![Kubernetes](https://img.shields.io/badge/Kubernetes-Ready-blue?style=flat-square&logo=kubernetes)
![Terraform](https://img.shields.io/badge/Terraform-IaC-purple?style=flat-square&logo=terraform)
![Ansible](https://img.shields.io/badge/Ansible-Automation-red?style=flat-square&logo=ansible)
![CI/CD](https://img.shields.io/badge/CI%2FCD-GitHub%20Actions-green?style=flat-square&logo=githubactions)
![Monitoring](https://img.shields.io/badge/Monitoring-Prometheus%20%26%20Grafana-orange?style=flat-square)
![AWS](https://img.shields.io/badge/AWS-ECS-orange?style=flat-square&logo=amazonaws)

---

## 📋 Table of Contents

- [Quick Start](#-quick-start)
- [How to Run Locally](#-how-to-run-locally)
- [Run via Docker Compose](#-run-via-docker-compose)
- [Run via Kubernetes](#-run-via-kubernetes)
- [Infrastructure Setup](#-infrastructure-setup-terraform)
- [Infrastructure Teardown](#-infrastructure-teardown)
- [Features](#-features)
- [Tech Stack](#-tech-stack)
- [Testing](#-testing)
- [Code Quality](#-code-quality--linting)
- [CI/CD Pipeline](#-cicd-pipeline)
- [Monitoring](#-monitoring)
- [Project Structure](#-project-structure)
- [Docker Configuration](#-docker-configuration)
- [Database Management](#-database-management)
- [Team & Contributions](#-team--contributions)
- [Proof of Work](#-proof-of-work)
- [Troubleshooting](#-troubleshooting)
- [Additional Resources](#-additional-resources)

---

## 🚀 Quick Start

This project demonstrates a complete DevOps pipeline with:
- ✅ Automated CI/CD (GitHub Actions)
- ✅ Infrastructure as Code (Terraform)
- ✅ Container Orchestration (Kubernetes)
- ✅ Configuration Management (Ansible)
- ✅ Monitoring & Observability (Prometheus & Grafana)
- ✅ Cloud Deployment (AWS ECS)

---

## 🖥️ How to Run Locally

### Prerequisites
- PHP 8.2+
- Composer
- MySQL 8.0
- Redis 7
- Node.js 20+

### Step 1: Clone Repository
```bash
git clone https://github.com/BuiltByWahabXD/FA22-BSE-DevOps-MidLab.git
cd FA22-BSE-DevOps-MidLab
```

### Step 2: Install Dependencies
```bash
# Install PHP dependencies
composer install

# Install NPM dependencies
npm install
```

### Step 3: Configure Environment
```bash
# Copy environment file
cp .env.example .env

# Generate application key
php artisan key:generate

# Configure database in .env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=notes_db
DB_USERNAME=root
DB_PASSWORD=your_password

# Configure Redis
REDIS_HOST=127.0.0.1
REDIS_PORT=6379
```

### Step 4: Setup Database
```bash
# Create database
mysql -u root -p -e "CREATE DATABASE notes_db;"

# Run migrations
php artisan migrate

# (Optional) Seed data
php artisan db:seed
```

### Step 5: Build Frontend Assets
```bash
npm run build
```

### Step 6: Start Development Server
```bash
php artisan serve
```

**Access:** http://localhost:8000

---

## 🐳 Run via Docker Compose

### Prerequisites
- Docker Desktop
- Docker Compose

### Step 1: Start All Services
```bash
docker-compose up -d
```

This will start:
- **App** (Laravel + Nginx) on port 80
- **MySQL** on port 3306
- **Redis** on port 6379

### Step 2: Run Migrations
```bash
docker-compose exec app php artisan migrate
```

### Step 3: Access Application
**URL:** http://localhost

### Stop Services
```bash
docker-compose down
```

### View Logs
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f app
```

---

## ☸️ Run via Kubernetes

### Prerequisites
- Minikube or local Kubernetes cluster
- kubectl
- Docker

### Step 1: Start Minikube
```bash
minikube start --cpus=4 --memory=4096
```

### Step 2: Create Namespace
```bash
kubectl apply -f k8s/namespace.yml
```

### Step 3: Deploy Services
```bash
# Deploy ConfigMaps and Secrets
kubectl apply -f k8s/configmap.yml
kubectl apply -f k8s/secret.yml

# Deploy MySQL
kubectl apply -f k8s/mysql/ -R

# Deploy Redis
kubectl apply -f k8s/redis/ -R

# Deploy Application
kubectl apply -f k8s/app/ -R
```

### Step 4: Wait for Pods to be Ready
```bash
kubectl get pods -n dev --watch
```

### Step 5: Access Application
```bash
# Get Minikube IP
minikube ip

# Get NodePort
kubectl get svc laravel-nginx -n dev
```

**Access:** http://<MINIKUBE_IP>:30080

### Deploy Monitoring (Optional)
```bash
kubectl apply -f k8s/monitoring-deployment.yml

# Access Prometheus
minikube service prometheus-service -n dev

# Access Grafana (admin/admin)
minikube service grafana-service -n dev
```

### Cleanup
```bash
kubectl delete namespace dev
```

---

## 🏗️ Infrastructure Setup (Terraform)

### Prerequisites
- Terraform 1.7+
- AWS CLI configured
- AWS credentials

### Step 1: Initialize Terraform
```bash
cd infra
terraform init
```

### Step 2: Review Plan
```bash
terraform plan
```

This provisions:
- VPC with 4 subnets (2 public, 2 private)
- 4 Security Groups (ALB, ECS, RDS, Redis)
- RDS MySQL instance
- ElastiCache Redis cluster
- ECS Fargate cluster
- Application Load Balancer

### Step 3: Apply Infrastructure
```bash
terraform apply
```

Type `yes` to confirm.

### Step 4: Get Outputs
```bash
terraform output
```

You'll see:
- ALB URL
- RDS endpoint
- Redis endpoint
- VPC ID

### Access Deployed Application
```bash
# Get ALB DNS
terraform output alb_url
```

---

## 💥 Infrastructure Teardown

### Terraform Destroy
```bash
cd infra
terraform destroy
```

Type `yes` to confirm.

This will:
- ✅ Destroy all AWS resources
- ✅ Remove ECS cluster and tasks
- ✅ Delete RDS database
- ✅ Remove ElastiCache Redis
- ✅ Delete ALB and target groups
- ✅ Remove VPC and networking

**⚠️ WARNING:** This action is irreversible!

### Verify Cleanup
```bash
# Check remaining resources
aws ecs list-clusters --region us-east-1
aws rds describe-db-instances --region us-east-1
aws elasticache describe-cache-clusters --region us-east-1
```

---

## 🎯 Features

### Application Features
- ✅ Full CRUD operations for notes
- ✅ Eloquent ORM for database interactions
- ✅ Input validation and error handling
- ✅ RESTful API design
- ✅ Responsive UI with Blade templates

### DevOps Features
- 🐳 **Docker & Docker Compose**: Multi-container setup
- ☸️ **Kubernetes**: Full orchestration with Minikube
- 🏗️ **Terraform**: Infrastructure as Code for AWS ECS
- 🤖 **Ansible**: Automated deployment and configuration
- 🔄 **CI/CD Pipeline**: 6-stage automated workflow
- 📊 **Prometheus**: Metrics collection and monitoring
- 📈 **Grafana**: Visualization and dashboards
- 🔒 **Secret Management**: GitHub Secrets, K8s Secrets
- 🧪 **Automated Testing**: Comprehensive PHPUnit test suite
- 🎨 **Code Formatting**: Laravel Pint for consistent style

---

## 🛠️ Tech Stack

### Backend
- **Laravel 11.x** - Modern PHP framework
- **PHP 8.2+** - Server-side programming language
- **Composer** - Dependency management for PHP

### Database & Cache
- **MySQL 8.0** - Relational database management system
- **Redis 7** - In-memory data store (cache & queue)
- **Eloquent ORM** - Laravel's database abstraction layer

### Frontend
- **Blade Templates** - Laravel's templating engine
- **Vite** - Frontend build tool
- **CSS** - Styling

### DevOps & Infrastructure
- **Docker** - Containerization platform
- **Docker Compose** - Multi-container orchestration
- **Kubernetes** - Container orchestration (Minikube)
- **Terraform** - Infrastructure as Code
- **Ansible** - Configuration management & automation
- **Nginx (Alpine)** - Web server and reverse proxy
- **GitHub Actions** - CI/CD automation
- **Docker Hub** - Container image registry

### Cloud Infrastructure
- **AWS ECS Fargate** - Serverless container orchestration
- **AWS RDS MySQL** - Managed database service
- **AWS ElastiCache Redis** - Managed caching service
- **AWS VPC** - Network isolation
- **Application Load Balancer** - Traffic distribution

### Monitoring & Observability
- **Prometheus** - Metrics collection and monitoring
- **Grafana** - Data visualization and dashboards

### Testing & Quality
- **PHPUnit** - PHP testing framework
- **Laravel Pint** - Code style fixer
- **RefreshDatabase** - Test database management

---

## 🧪 Testing

Our application includes a comprehensive test suite to ensure code quality and functionality.

### Running All Tests

```bash
# Run all tests using Laravel Artisan
docker-compose exec app php artisan test

# Run all tests using PHPUnit directly
docker-compose exec app php vendor/bin/phpunit
```

### Running Specific Test Suites

```bash
# Run only Feature tests
docker-compose exec app php artisan test --testsuite=Feature

# Run only Unit tests
docker-compose exec app php artisan test --testsuite=Unit
```

### Running Specific Test Files

```bash
# Run a specific test file
docker-compose exec app php artisan test tests/Feature/NoteTest.php

# Run a specific test method
docker-compose exec app php artisan test --filter test_can_create_a_note
```

### Verbose Test Output

```bash
# Run tests with detailed output
docker-compose exec app php artisan test --verbose
```

### Test Coverage

```bash
# Generate test coverage report (requires Xdebug)
docker-compose exec app php artisan test --coverage

# Generate HTML coverage report
docker-compose exec app php artisan test --coverage-html coverage
```

### Test Configuration

Tests are configured in `phpunit.xml` with the following key settings:

- **Database**: Uses MySQL container (`mysql` service)
- **Environment**: Isolated testing environment
- **Migrations**: Automatically run via `RefreshDatabase` trait
- **Test Data**: Each test runs with a fresh database state

### Understanding Our Tests

#### Feature Tests (`tests/Feature/NoteTest.php`)

Our feature tests cover the complete CRUD functionality:

| Test | Coverage |
|------|----------|
| `test_can_create_a_note` | Note creation and database persistence |
| `test_can_read_a_note` | Note retrieval from database |
| `test_can_update_a_note` | Note update and persistence |
| `test_can_delete_a_note` | Note deletion from database |
| `test_can_list_multiple_notes` | Bulk note retrieval |
| `test_note_has_fillable_attributes` | Mass assignment protection |

---

## 🎨 Code Quality & Linting

We use **Laravel Pint** to maintain consistent code style across the project.

### Running Laravel Pint

```bash
# Check code style (dry run - no changes made)
docker-compose exec app ./vendor/bin/pint --test

# Fix code style issues automatically
docker-compose exec app ./vendor/bin/pint

# Fix a specific directory
docker-compose exec app ./vendor/bin/pint app/

# Fix a specific file
docker-compose exec app ./vendor/bin/pint app/Models/Note.php
```

### Code Style Rules

Laravel Pint follows the PSR-12 coding standard with Laravel-specific conventions:

- ✅ Consistent indentation (4 spaces)
- ✅ Proper spacing around operators
- ✅ Consistent brace placement
- ✅ Proper import ordering
- ✅ Consistent naming conventions

### Pre-Commit Checks

Before committing code, always run:

```bash
# Run tests
docker-compose exec app php artisan test

# Check code style
docker-compose exec app ./vendor/bin/pint --test
```

---

## 🔄 CI/CD Pipeline

Our project uses **GitHub Actions** for automated continuous integration and deployment.

### Pipeline Overview

The CI/CD pipeline is triggered on:
- Push to `main` branch
- Push to `dev` branch
- Pull requests to `main` branch

### Pipeline Stages

The pipeline consists of 6 automated stages:

| Stage | Duration | Description |
|-------|----------|-------------|
| **1. Build & Test** | ~1m | Checkout code, install dependencies, run PHPUnit tests |
| **2. Security & Linting** | ~16s | Run Laravel Pint, security scans |
| **3. Docker Build & Push** | ~2m 14s | Build Docker image, push to Docker Hub |
| **4. Terraform Apply** | ~21s | Provision AWS infrastructure (ECS, RDS, Redis) |
| **5. Kubectl Apply** | ~5s | Deploy to Kubernetes cluster |
| **6. Smoke Tests** | ~14s | Post-deployment health checks |

**Total Duration**: ~4 minutes 30 seconds

### Workflow File Location

```
.github/workflows/laravel-ci-cd.yml
```

### Docker Hub Integration

Successful builds are automatically pushed to Docker Hub:

- **Registry**: `builtbywahab/laravel-notes`
- **Tags**: 
  - `latest` - Most recent successful build
  - `[commit-sha]` - Specific commit version

### GitHub Secrets Required

The following secrets must be configured in GitHub repository settings:

| Secret Name | Purpose |
|------------|---------|
| `DOCKER_TOKEN` | Docker Hub authentication token |
| `AWS_ACCESS_KEY_ID` | AWS authentication for Terraform |
| `AWS_SECRET_ACCESS_KEY` | AWS secret key for infrastructure |

### Viewing Pipeline Status

1. Navigate to the **Actions** tab in GitHub repository
2. View workflow runs and their status
3. Click on a specific run to see detailed logs for each stage

---

## 📊 Monitoring

Our application includes comprehensive monitoring using **Prometheus** and **Grafana**.

### Deployed Services

- **Prometheus**: Metrics collection (Port 30090)
- **Grafana**: Data visualization (Port 30030)

### Accessing Monitoring Dashboards

```bash
# Access Prometheus
minikube service prometheus-service -n dev

# Access Grafana (default credentials: admin/admin)
minikube service grafana-service -n dev
```

### Metrics Collected

- **Container Metrics**: CPU, Memory, Network usage
- **Application Metrics**: Request rates, response times
- **Database Metrics**: Connection pools, query performance
- **Redis Metrics**: Cache hit rates, memory usage

### Grafana Dashboards

1. **Kubernetes Overview** (Dashboard ID: 315)
   - Pod status and health
   - Resource utilization
   - Network traffic

2. **Custom Laravel Monitoring**
   - Application-specific metrics
   - Database queries
   - Cache performance

### Sample Prometheus Queries

```promql
# Container CPU usage
rate(container_cpu_usage_seconds_total[5m])

# Memory usage
container_memory_usage_bytes

# HTTP request rate
rate(http_requests_total[5m])
```

---

## 📂 Project Structure

```
FA22-BSE-DevOps-FinalLab/
├── .github/
│   └── workflows/
│       └── laravel-ci-cd.yml      # CI/CD pipeline configuration
├── ansible/
│   ├── deploy.yml                  # Ansible playbook
│   ├── inventory.ini               # Inventory file
│   └── run-deployment.ps1          # Deployment script
├── app/
│   ├── Http/Controllers/           # Application controllers
│   └── Models/                     # Eloquent models
│       ├── Note.php
│       └── User.php
├── config/                          # Laravel configuration files
├── database/
│   ├── migrations/                  # Database migrations
│   └── seeders/                     # Database seeders
├── docker/
│   ├── nginx/
│   │   └── default.conf             # Nginx configuration
│   └── php/
│       └── Dockerfile               # PHP Docker image
├── infra/                           # Terraform infrastructure
│   ├── main.tf                      # Main Terraform config
│   ├── vpc.tf                       # VPC configuration
│   ├── ecs.tf                       # ECS cluster
│   ├── rds.tf                       # RDS MySQL
│   ├── redis.tf                     # ElastiCache Redis
│   ├── alb.tf                       # Load balancer
│   ├── security-groups.tf           # Security groups
│   ├── variables.tf                 # Input variables
│   └── outputs.tf                   # Output values
├── k8s/                             # Kubernetes manifests
│   ├── namespace.yml
│   ├── configmap.yml
│   ├── secret.yml
│   ├── mysql/                       # MySQL deployment
│   ├── redis/                       # Redis deployment
│   ├── app/                         # Laravel app deployment
│   └── monitoring-deployment.yml    # Prometheus & Grafana
├── resources/
│   ├── views/                       # Blade templates
│   ├── css/                         # Stylesheets
│   └── js/                          # JavaScript files
├── routes/
│   └── web.php                      # Application routes
├── tests/
│   ├── Feature/
│   │   └── NoteTest.php             # Feature tests
│   └── Unit/                        # Unit tests
├── docker-compose.yml               # Docker Compose configuration
├── phpunit.xml                      # PHPUnit configuration
├── README.md                        # This file
├── devops_report.md                 # Technical documentation
└── DEPLOYMENT_CHECKLIST.md          # Deployment guide
```

---

## 🐳 Docker Configuration

### Service Architecture

Our Docker Compose setup includes three services:

#### 1. Application Service (`app`)
- **Base Image**: PHP 8.2 with FPM
- **Dockerfile**: `docker/php/Dockerfile`
- **Purpose**: Runs the Laravel application
- **Exposed Port**: 9000 (internal)

#### 2. Web Server Service (`nginx`)
- **Base Image**: nginx:alpine
- **Configuration**: `docker/nginx/default.conf`
- **Purpose**: Serves the application and handles HTTP requests
- **Exposed Port**: 8080 (external) → 80 (internal)

#### 3. Database Service (`mysql`)
- **Base Image**: mysql:8.0
- **Purpose**: Persistent data storage
- **Exposed Port**: 3306
- **Volume**: `mysql-data` for data persistence

### Docker Commands Reference

```bash
# Build containers
docker-compose build

# Start containers
docker-compose up -d

# Stop containers
docker-compose stop

# Restart containers
docker-compose restart

# View logs
docker-compose logs -f

# Execute command in container
docker-compose exec app [command]

# Access container shell
docker-compose exec app bash

# Remove containers and volumes
docker-compose down -v

# View container status
docker-compose ps
```

### Persistent Data

Data is stored in Docker volumes:
- **mysql-data**: Database files (persists between container restarts)

### Networking

All services communicate via the `laravel-network` bridge network:
- Services can reference each other by service name
- Example: `DB_HOST=mysql` (not `localhost`)

---

## 🗄️ Database Management

### Accessing the MySQL Database

```bash
# Access MySQL shell inside the container
docker-compose exec mysql mysql -u laravel_user -p
# Password: password

# Or using root user
docker-compose exec mysql mysql -u root -p
# Password: root
```

### Database Commands

```bash
# Run migrations
docker-compose exec app php artisan migrate

# Rollback migrations
docker-compose exec app php artisan migrate:rollback

# Reset and re-run migrations
docker-compose exec app php artisan migrate:fresh

# Reset and seed database
docker-compose exec app php artisan migrate:fresh --seed

# Check migration status
docker-compose exec app php artisan migrate:status
```

### Database Backups

```bash
# Create a backup
docker-compose exec mysql mysqldump -u laravel_user -ppassword notes_db > backup.sql

# Restore from backup
docker-compose exec -T mysql mysql -u laravel_user -ppassword notes_db < backup.sql
```

### Connect with External Tools

You can connect to the MySQL database using tools like MySQL Workbench or phpMyAdmin:

- **Host**: `localhost`
- **Port**: `3306`
- **Database**: `notes_db`
- **Username**: `laravel_user`
- **Password**: `password`

---

## 👥 Team & Contributions

This project was developed as part of the **DevOps Final Lab** at COMSATS University.

### Author
**Abdul Wahab** - Full Stack Developer & DevOps Engineer

### Contributions

All aspects of this project were implemented including:
- ✅ Infrastructure as Code (Terraform)
- ✅ Container Orchestration (Kubernetes)
- ✅ Configuration Management (Ansible)
- ✅ CI/CD Pipeline (GitHub Actions)
- ✅ Monitoring & Observability (Prometheus & Grafana)
- ✅ Application Development (Laravel)
- ✅ Testing & Quality Assurance
- ✅ Documentation

### Repository Information

- **GitHub**: [FA22-BSE-DevOps-MidLab](https://github.com/BuiltByWahabXD/FA22-BSE-DevOps-MidLab)
- **Docker Hub**: [builtbywahab/laravel-notes](https://hub.docker.com/r/builtbywahab/laravel-notes)

---

## 📸 Proof of Work

Comprehensive documentation and evidence of the DevOps implementation can be found in:

📄 **[DevOps Report](devops_report.md)** - Complete technical documentation

The report includes:

### Evidence Collected

1. **Terraform Infrastructure**
   - ✅ 32 AWS resources provisioned
   - ✅ Terraform outputs and state
   - ✅ AWS Console screenshots (VPC, ECS, RDS, Redis, ALB)

2. **Kubernetes Deployment**
   - ✅ Minikube cluster setup
   - ✅ All pods running (MySQL, Redis, Laravel)
   - ✅ Services and networking configuration
   - ✅ ConfigMaps and Secrets

3. **Ansible Automation**
   - ✅ Playbook execution (PLAY RECAP: 0 failed)
   - ✅ Automated deployment proof
   - ✅ Inventory configuration

4. **CI/CD Pipeline**
   - ✅ GitHub Actions workflow (all 6 stages passing)
   - ✅ Build and test logs
   - ✅ Docker Hub integration
   - ✅ Automated deployments

5. **Monitoring Setup**
   - ✅ Prometheus metrics collection
   - ✅ Grafana dashboards
   - ✅ Custom queries and alerts

6. **Testing Results**
   - ✅ PHPUnit test execution (all passing)
   - ✅ Code coverage reports
   - ✅ CI/CD test logs

---

## 🔧 Troubleshooting

### Common Issues & Solutions

#### Issue: Port 8080 Already in Use
```bash
# Find process using the port
netstat -ano | findstr :8080  # Windows
lsof -i :8080                 # Mac/Linux

# Change port in docker-compose.yml
ports:
  - "8081:80"  # Use different port
```

#### Issue: Database Connection Failed
```bash
# Ensure MySQL container is running
docker-compose ps

# Check database logs
docker-compose logs mysql

# Verify DB_HOST in .env is set to 'mysql'
```

#### Issue: Composer Dependencies Not Installed
```bash
# Install dependencies inside the container
docker-compose exec app composer install
```

#### Issue: Permission Denied Errors
```bash
# Fix storage permissions
docker-compose exec app chmod -R 775 storage bootstrap/cache
docker-compose exec app chown -R www-data:www-data storage bootstrap/cache
```

#### Issue: Tests Failing
```bash
# Ensure test database is configured
docker-compose exec app php artisan config:clear

# Check phpunit.xml configuration
# Verify DB_HOST is 'mysql' not 'localhost'

# Run migrations in test environment
docker-compose exec app php artisan migrate --env=testing
```

---

## 📚 Additional Resources

### Laravel Documentation
- [Official Laravel Documentation](https://laravel.com/docs)
- [Laravel Testing Guide](https://laravel.com/docs/testing)
- [Eloquent ORM](https://laravel.com/docs/eloquent)

### Docker Resources
- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)

### DevOps & CI/CD
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [DevOps Best Practices](https://www.atlassian.com/devops)
- [The Twelve-Factor App](https://12factor.net/)

### Testing
- [PHPUnit Documentation](https://phpunit.de/documentation.html)
- [Laravel Testing Best Practices](https://laravel.com/docs/testing)

---

## 📄 License

This project is developed for educational purposes as part of the DevOps Final Lab at COMSATS University.

The Laravel framework is open-sourced software licensed under the [MIT license](https://opensource.org/licenses/MIT).

---

## 🙏 Acknowledgments

- **Laravel Team** - For the amazing framework
- **Docker Community** - For containerization tools
- **GitHub** - For hosting and CI/CD infrastructure
- **AWS** - For cloud infrastructure services
- **COMSATS Faculty** - For guidance and support

---

## 📞 Contact & Support

For questions or issues related to this project:

- **GitHub Repository**: [FA22-BSE-DevOps-MidLab](https://github.com/BuiltByWahabXD/FA22-BSE-DevOps-MidLab)
- **Issues**: [GitHub Issues](https://github.com/BuiltByWahabXD/FA22-BSE-DevOps-MidLab/issues)
- **Pull Requests**: [GitHub PRs](https://github.com/BuiltByWahabXD/FA22-BSE-DevOps-MidLab/pulls)

---

<p align="center">
  <strong>Built with ❤️ by Abdul Wahab & Team</strong><br>
  DevOps Final Lab • COMSATS University • December 2025
</p>

---

**Last Updated**: December 18, 2025  
**Version**: 2.0.0  
**Status**: ✅ Production Ready • CI/CD Pipeline Active
