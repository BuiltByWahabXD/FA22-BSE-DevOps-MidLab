# Laravel Notes Application
### DevOps Mid-Lab Exam Project - Group 17

![Laravel](https://img.shields.io/badge/Laravel-11.x-red?style=flat-square&logo=laravel)
![PHP](https://img.shields.io/badge/PHP-8.2+-blue?style=flat-square&logo=php)
![MySQL](https://img.shields.io/badge/MySQL-8.0-orange?style=flat-square&logo=mysql)
![Docker](https://img.shields.io/badge/Docker-Enabled-blue?style=flat-square&logo=docker)
![CI/CD](https://img.shields.io/badge/CI%2FCD-GitHub%20Actions-green?style=flat-square&logo=githubactions)

---

## 📋 Table of Contents

- [Project Overview](#-project-overview)
- [Features](#-features)
- [Tech Stack](#-tech-stack)
- [Prerequisites](#-prerequisites)
- [Installation](#-installation)
- [Running the Application](#-running-the-application)
- [Testing](#-testing)
- [Code Quality & Linting](#-code-quality--linting)
- [CI/CD Pipeline](#-cicd-pipeline)
- [Docker Configuration](#-docker-configuration)
- [Database Management](#-database-management)
- [Contributors](#-contributors)
- [Proof of Work](#-proof-of-work)
- [License](#-license)

---

## 🎯 Project Overview

The **Laravel Notes Application** is a full-stack web application developed as part of the DevOps Mid-Lab Exam. This project demonstrates modern DevOps practices including:

- **Containerization** with Docker and Docker Compose
- **Automated Testing** with PHPUnit
- **Continuous Integration/Continuous Deployment (CI/CD)** with GitHub Actions
- **Database Management** with MySQL
- **Code Quality** enforcement with Laravel Pint

The application provides a simple yet robust CRUD (Create, Read, Update, Delete) interface for managing notes, built using Laravel's elegant syntax and best practices.

### 🎓 Academic Context

- **Institution**: COMSATS University
- **Course**: DevOps
- **Assessment**: Mid-Lab Exam
- **Group**: Group 17
- **Semester**: 7
- **Date**: October 30, 2025

---

## ✨ Features

### Application Features
- ✅ Create, Read, Update, and Delete notes
- ✅ RESTful API architecture
- ✅ Database-backed persistence with MySQL
- ✅ Clean and intuitive user interface
- ✅ Eloquent ORM for database interactions
- ✅ Input validation and error handling

### DevOps Features
- 🐳 **Fully Dockerized**: Multi-container setup with Docker Compose
- 🔄 **CI/CD Pipeline**: Automated testing and deployment
- 🧪 **Automated Testing**: Comprehensive PHPUnit test suite
- 🔒 **Secret Management**: Secure handling of credentials via GitHub Secrets
- 📦 **Docker Hub Integration**: Automated image publishing
- 🎨 **Code Formatting**: Laravel Pint for consistent code style
- 📊 **Quality Assurance**: Automated testing on every commit

---

## 🛠 Tech Stack

### Backend
- **Laravel 11.x** - Modern PHP framework
- **PHP 8.2+** - Server-side programming language
- **Composer** - Dependency management for PHP

### Database
- **MySQL 8.0** - Relational database management system
- **Eloquent ORM** - Laravel's database abstraction layer

### Frontend
- **Blade Templates** - Laravel's templating engine
- **Vite** - Frontend build tool
- **CSS** - Styling

### DevOps & Infrastructure
- **Docker** - Containerization platform
- **Docker Compose** - Multi-container orchestration
- **Nginx (Alpine)** - Web server and reverse proxy
- **GitHub Actions** - CI/CD automation
- **Docker Hub** - Container image registry

### Testing & Quality
- **PHPUnit** - PHP testing framework
- **Laravel Pint** - Code style fixer
- **RefreshDatabase** - Test database management

---

## 📦 Prerequisites

Before you begin, ensure you have the following installed on your system:

### Required Software
- **Docker Desktop** (v20.10 or higher)
  - [Download for Windows](https://docs.docker.com/desktop/install/windows-install/)
  - [Download for Mac](https://docs.docker.com/desktop/install/mac-install/)
  - [Download for Linux](https://docs.docker.com/desktop/install/linux-install/)
  
- **Docker Compose** (v2.0 or higher)
  - Usually included with Docker Desktop
  - For Linux: `sudo apt-get install docker-compose-plugin`

- **Git** (for cloning the repository)
  - [Download Git](https://git-scm.com/downloads)

### Optional (for local development without Docker)
- PHP 8.2 or higher
- Composer 2.x
- MySQL 8.0
- Node.js 18+ & npm

### System Requirements
- **OS**: Windows 10/11, macOS, or Linux
- **RAM**: Minimum 4GB (8GB recommended)
- **Disk Space**: At least 2GB free space

---

## 🚀 Installation

Follow these steps to get the Laravel Notes Application running on your local machine:

### Step 1: Clone the Repository

```bash
# Clone the repository
git clone https://github.com/BuiltByWahabXD/FA22-BSE-DevOps-MidLab.git

# Navigate to the project directory
cd FA22-BSE-DevOps-MidLab
```

### Step 2: Create Environment Configuration

```bash
# Copy the example environment file
cp .env.example .env
```

### Step 3: Configure Environment Variables

Open the `.env` file and update the following database settings to match the Docker Compose configuration:

```env
# Application Settings
APP_NAME="Laravel Notes"
APP_ENV=local
APP_DEBUG=true
APP_URL=http://localhost:8080

# Database Configuration (must match docker-compose.yml)
DB_CONNECTION=mysql
DB_HOST=mysql
DB_PORT=3306
DB_DATABASE=notes_db
DB_USERNAME=laravel_user
DB_PASSWORD=password
```

> **Note**: The `DB_HOST` should be `mysql` (the service name from docker-compose.yml), not `localhost`.

### Step 4: Build and Start Docker Containers

```bash
# Build and start all containers in detached mode
docker-compose up -d --build
```

This command will:
- Build the PHP application container
- Start the MySQL database container
- Start the Nginx web server container
- Create the necessary Docker networks and volumes

### Step 5: Install PHP Dependencies

```bash
# Install Composer dependencies inside the container
docker-compose exec app composer install
```

### Step 6: Generate Application Key

```bash
# Generate a unique application encryption key
docker-compose exec app php artisan key:generate
```

### Step 7: Run Database Migrations

```bash
# Create database tables
docker-compose exec app php artisan migrate
```

### Step 8: (Optional) Seed the Database

```bash
# Populate the database with sample data
docker-compose exec app php artisan db:seed
```

---

## 🎮 Running the Application

### Access the Application

Once all containers are running, you can access the application at:

🌐 **http://localhost:8080**

### Verify Containers Are Running

```bash
# Check container status
docker-compose ps

# Expected output:
# NAME               STATUS          PORTS
# laravel-app        Up              9000/tcp
# laravel-mysql      Up              0.0.0.0:3306->3306/tcp
# laravel-nginx      Up              0.0.0.0:8080->80/tcp
```

### View Container Logs

```bash
# View all logs
docker-compose logs

# View specific service logs
docker-compose logs app
docker-compose logs mysql
docker-compose logs nginx

# Follow logs in real-time
docker-compose logs -f app
```

### Stop the Application

```bash
# Stop all containers (preserves data)
docker-compose stop

# Stop and remove containers (preserves volumes)
docker-compose down

# Stop, remove containers, and remove volumes (fresh start)
docker-compose down -v
```

### Restart the Application

```bash
# Restart all containers
docker-compose restart

# Restart a specific service
docker-compose restart app
```

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

1. **📥 Checkout Code**: Clone the repository
2. **🔧 Setup Environment**: Install PHP, Composer, Node.js
3. **🗄️ Database Setup**: Start MySQL service container
4. **🧪 Run Tests**: Execute PHPUnit test suite
5. **🎨 Code Quality**: Run Laravel Pint linter
6. **🐳 Build Docker Image**: Create production Docker image
7. **📤 Push to Docker Hub**: Publish image to registry

### Workflow File Location

The CI/CD configuration is maintained by **Teammate 2** and can be found at:
```
.github/workflows/ci-cd.yml
```

### Docker Hub Integration

Successful builds are automatically pushed to Docker Hub:

- **Registry**: `docker.io/[username]/laravel-notes-app`
- **Tags**: 
  - `latest` - Most recent successful build
  - `[commit-sha]` - Specific commit version

### Viewing Pipeline Status

1. Navigate to the **Actions** tab in GitHub
2. View workflow runs and their status
3. Click on a specific run to see detailed logs

### GitHub Secrets

The following secrets are configured (by Teammate 2):

- `DOCKER_HUB_USERNAME` - Docker Hub username
- `DOCKER_HUB_ACCESS_TOKEN` - Docker Hub authentication token
- `MYSQL_DATABASE` - Test database name
- `MYSQL_USER` - Database username
- `MYSQL_PASSWORD` - Database password

> **Note**: Secrets are managed by the CI/CD team member and are not visible in the codebase for security reasons.

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

## 👥 Contributors

This project was developed by **Group 17** as a collaborative effort:

### Team Members & Responsibilities

| Member | Role | Responsibilities |
|--------|------|-----------------|
| **FA22-BSE-160** | Infrastructure Setup | - Docker & Docker Compose configuration<br>- Application containerization<br>- Environment setup<br>- Initial project structure |
| **FA22-BSE-154** | CI/CD Engineer | - GitHub Actions workflow design<br>- Docker Hub integration<br>- Secret management<br>- Pipeline automation |
| **FA22-BSE-206** | Testing & Documentation | - PHPUnit configuration<br>- Feature test implementation<br>- Project documentation<br>- DevOps report |

### Collaboration Tools

- **Version Control**: Git & GitHub
- **Project Management**: GitHub Issues & Projects
- **Communication**: Team meetings and code reviews
- **Documentation**: Markdown files in repository

### Branch Strategy

- `main` - Production-ready code
- `dev` - Development branch
- `feature/*` - Individual feature branches
- `testing/*` - Testing-related branches
- `docs/*` - Documentation branches

### Contribution Guidelines

1. Create a feature branch from `dev`
2. Make your changes with clear, descriptive commits
3. Write or update tests for new features
4. Run tests and linting before pushing
5. Create a pull request to `dev` branch
6. Request code review from team members
7. Merge after approval and passing CI/CD checks

---

## 📸 Proof of Work

### Documentation & Evidence

Comprehensive proof of our DevOps implementation is documented in:

📄 **[DevOps Report](devops_report.md)** - Complete project documentation

The report includes:

#### Screenshots & Evidence Collected

1. **CI/CD Pipeline**
   - ✅ GitHub Actions workflow execution
   - ✅ All pipeline stages passing
   - ✅ Test execution logs
   - ✅ Build and deployment success

2. **Docker Hub**
   - ✅ Published Docker images
   - ✅ Multiple tagged versions
   - ✅ Automated push history
   - ✅ Image metadata

3. **Running Containers**
   - ✅ `docker ps` output showing all services
   - ✅ Container logs
   - ✅ Health check status
   - ✅ Network configuration

4. **Test Results**
   - ✅ PHPUnit test execution (all passing)
   - ✅ Test coverage report
   - ✅ CI/CD test logs
   - ✅ Local test execution

5. **Git History**
   - ✅ `git shortlog` showing contributions
   - ✅ Commit history by team member
   - ✅ Branch structure visualization
   - ✅ Pull request reviews

6. **Application Screenshots**
   - ✅ Laravel welcome page at localhost:8080
   - ✅ Database connection verification
   - ✅ CRUD operations demonstration
   - ✅ No errors in console

### Viewing Proof Materials

```bash
# Generate git contribution summary
git shortlog -s -n --all

# View detailed commit history
git log --graph --oneline --all --decorate

# Show contributions by specific author
git log --author="YourName" --oneline --shortstat
```

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

This project is developed for educational purposes as part of the DevOps Mid-Lab Exam at COMSATS University.

The Laravel framework is open-sourced software licensed under the [MIT license](https://opensource.org/licenses/MIT).

---

## 🙏 Acknowledgments

- **Laravel Team** - For the amazing framework
- **Docker Community** - For containerization tools
- **GitHub** - For hosting and CI/CD infrastructure
- **COMSATS Faculty** - For guidance and support
- **Group 17 Team** - For collaboration and teamwork

---

## 📞 Contact & Support

For questions or issues related to this project:

- **GitHub Repository**: [FA22-BSE-DevOps-MidLab](https://github.com/BuiltByWahabXD/FA22-BSE-DevOps-MidLab)
- **Issues**: [GitHub Issues](https://github.com/BuiltByWahabXD/FA22-BSE-DevOps-MidLab/issues)
- **Pull Requests**: [GitHub PRs](https://github.com/BuiltByWahabXD/FA22-BSE-DevOps-MidLab/pulls)

---

<p align="center">
  <strong>Built with ❤️ by Group 17</strong><br>
  DevOps Mid-Lab Exam • COMSATS University • October 2025
</p>

---

**Last Updated**: October 30, 2025  
**Version**: 1.0.0  
**Status**: ✅ Active Development
