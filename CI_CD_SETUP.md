# CI/CD Pipeline Setup - Complete Guide

## 🎯 Overview

This document provides complete instructions for the GitHub Actions CI/CD pipeline configured for the Laravel Notes Application.

---

## 📋 Pipeline Architecture

### Pipeline Stages:

1. **Build & Test** (Runs on all branches and PRs)
   - Checkout code
   - Setup PHP 8.2 & Node.js
   - Install dependencies (Composer & NPM)
   - Configure environment
   - Run database migrations
   - Execute PHPUnit tests
   - Run Laravel Pint (code style)
   - Build frontend assets

2. **Docker Build & Deploy** (Runs only on `main` branch push)
   - Build Docker image
   - Push to Docker Hub with multiple tags
   - Deploy summary

---

## 🔐 Required GitHub Secrets

Navigate to: **Repository Settings → Secrets and variables → Actions → New repository secret**

### Testing Stage Secrets:

| Secret Name | Example Value | Description |
|------------|---------------|-------------|
| `DB_USERNAME` | `laravel_user` | MySQL username for testing |
| `DB_PASSWORD` | `your_secure_password` | MySQL password for testing |
| `DB_DATABASE` | `notes_db` | Database name for testing |

### Deployment Stage Secrets:

| Secret Name | Example Value | Description |
|------------|---------------|-------------|
| `DOCKER_USERNAME` | `your-dockerhub-username` | Docker Hub account username |
| `DOCKER_TOKEN` | `dckr_pat_xxxxx` | Docker Hub access token |

---

## 🔧 How to Create Docker Hub Access Token

1. Log in to [Docker Hub](https://hub.docker.com/)
2. Click on your profile → **Account Settings**
3. Navigate to **Security** tab
4. Click **New Access Token**
5. Token description: `github-actions-laravel-notes`
6. Access permissions: **Read, Write, Delete**
7. Click **Generate**
8. **Copy the token immediately** (you won't see it again!)
9. Add it as `DOCKER_TOKEN` secret in GitHub

---

## 🌿 Supported Branches

The pipeline is configured to run on:

- ✅ `main` - Full pipeline (test + deploy to Docker Hub)
- ✅ `Testing-Doc-Branch` - Test only (no deployment)
- ✅ `Docker-Branch` - Test only (no deployment)
- ✅ `CI-CD-Branch` - Test only (no deployment)
- ✅ Pull Requests to `main` - Test only (no deployment)

---

## 🚀 Pipeline Execution Flow

### On Push to Any Branch:

```
┌─────────────────────────────────────┐
│  1. Code Checkout                   │
└─────────────────────────────────────┘
              ↓
┌─────────────────────────────────────┐
│  2. Setup PHP 8.2 & Extensions      │
└─────────────────────────────────────┘
              ↓
┌─────────────────────────────────────┐
│  3. Install Composer Dependencies   │
└─────────────────────────────────────┘
              ↓
┌─────────────────────────────────────┐
│  4. Setup Node.js & NPM Install     │
└─────────────────────────────────────┘
              ↓
┌─────────────────────────────────────┐
│  5. Configure .env & Generate Key   │
└─────────────────────────────────────┘
              ↓
┌─────────────────────────────────────┐
│  6. Start MySQL Service Container   │
└─────────────────────────────────────┘
              ↓
┌─────────────────────────────────────┐
│  7. Run Database Migrations         │
└─────────────────────────────────────┘
              ↓
┌─────────────────────────────────────┐
│  8. Execute PHPUnit Tests           │
└─────────────────────────────────────┘
              ↓
┌─────────────────────────────────────┐
│  9. Run Laravel Pint (Linting)      │
└─────────────────────────────────────┘
              ↓
┌─────────────────────────────────────┐
│  10. Build Frontend Assets (Vite)   │
└─────────────────────────────────────┘
```

### Additional Steps on `main` Branch:

```
┌─────────────────────────────────────┐
│  11. Setup Docker Buildx            │
└─────────────────────────────────────┘
              ↓
┌─────────────────────────────────────┐
│  12. Login to Docker Hub            │
└─────────────────────────────────────┘
              ↓
┌─────────────────────────────────────┐
│  13. Build Docker Image             │
└─────────────────────────────────────┘
              ↓
┌─────────────────────────────────────┐
│  14. Push to Docker Hub             │
│      Tags: latest, main, main-sha   │
└─────────────────────────────────────┘
              ↓
┌─────────────────────────────────────┐
│  15. Deployment Summary             │
└─────────────────────────────────────┘
```

---

## 🏷️ Docker Image Tagging Strategy

Each successful build on `main` creates multiple tags:

| Tag Format | Example | Purpose |
|-----------|---------|---------|
| `latest` | `your-user/laravel-notes-app:latest` | Always points to the most recent build |
| `branch-name` | `your-user/laravel-notes-app:main` | Specific branch tracking |
| `branch-sha` | `your-user/laravel-notes-app:main-abc1234` | Specific commit identification |

---

## 📊 Expected Test Results

### Successful Run Output:

```bash
✓ test the application returns a successful response
✓ that true is true
✓ can create a note
✓ can read a note
✓ can update a note
✓ can delete a note
✓ can list multiple notes
✓ note has fillable attributes

Tests:  8 passed (23 assertions)
Duration: 2-5 seconds
```

---

## 🔍 Monitoring Pipeline Execution

### View Pipeline Status:

1. Navigate to your GitHub repository
2. Click the **Actions** tab
3. Select **Laravel CI/CD Pipeline** workflow
4. View latest runs and their status

### Pipeline States:

- 🟢 **Green Check** - All tests passed, deployment successful
- 🔴 **Red X** - Tests failed or build error
- 🟡 **Yellow Dot** - Pipeline currently running
- ⚪ **Gray Circle** - Pipeline queued

---

## 🐛 Troubleshooting

### Issue: Tests Fail in CI but Pass Locally

**Possible Causes:**
- Database configuration mismatch
- Missing GitHub secrets
- MySQL service not ready

**Solution:**
```yaml
# The pipeline includes a MySQL readiness check:
- name: Wait for MySQL to be Ready
  run: |
    for i in {1..30}; do
      if mysqladmin ping -h 127.0.0.1 -P 3306 -u${{ secrets.DB_USERNAME }} -p${{ secrets.DB_PASSWORD }} --silent; then
        echo "MySQL is ready!"
        break
      fi
      sleep 2
    done
```

### Issue: Docker Hub Push Fails

**Possible Causes:**
- Invalid Docker Hub credentials
- Expired access token
- Repository doesn't exist

**Solution:**
1. Verify `DOCKER_USERNAME` secret is correct
2. Regenerate `DOCKER_TOKEN` in Docker Hub
3. Ensure repository exists or Docker Hub auto-creates it

### Issue: Composer Install Timeout

**Solution:**
The pipeline uses caching to speed up builds. If timeout persists:
```yaml
- name: Install Dependencies
  run: COMPOSER_MEMORY_LIMIT=-1 composer install --no-interaction
```

---

## 📈 Performance Optimization

### Current Optimizations:

1. **Dependency Caching**
   - Composer packages cached between runs
   - NPM modules cached
   - Speeds up builds by 2-3 minutes

2. **Parallel Test Execution**
   - PHPUnit runs tests in parallel when possible
   - Reduces test execution time

3. **Docker Build Cache**
   - Layers cached in Docker Hub registry
   - Faster subsequent builds

### Expected Pipeline Duration:

- **First Run**: 8-12 minutes
- **Subsequent Runs**: 4-6 minutes (with cache)
- **On main branch** (with Docker): 6-8 minutes

---

## 🎯 Testing Locally Before Push

### Run Tests Locally:

```bash
# With Docker
docker-compose exec app php artisan test

# With Docker (verbose)
docker-compose exec app php artisan test --verbose

# Check code style
docker-compose exec app ./vendor/bin/pint --test
```

### Build Docker Image Locally:

```bash
# Build image
docker build -f docker/php/Dockerfile -t laravel-notes-app:test .

# Run container
docker run --rm laravel-notes-app:test php -v

# Test the image
docker run --rm laravel-notes-app:test php artisan --version
```

---

## 🔒 Security Best Practices

### ✅ Implemented:

- All sensitive credentials stored as GitHub Secrets
- Secrets never exposed in logs
- Docker Hub uses access tokens (not passwords)
- Database credentials isolated per environment
- `.env` files in `.gitignore`

### 🚨 Never Do:

- ❌ Commit secrets to repository
- ❌ Log sensitive information
- ❌ Use production credentials in CI/CD
- ❌ Share access tokens publicly
- ❌ Hardcode passwords in code

---

## 📝 Verification Checklist

Before pushing to trigger the pipeline:

- [ ] All GitHub Secrets configured correctly
- [ ] Docker Hub repository created (or auto-create enabled)
- [ ] Local tests passing
- [ ] `.env.example` updated with correct structure
- [ ] `docker-compose.yml` configured properly
- [ ] Workflow file in `.github/workflows/laravel-ci-cd.yml`

---

## 🎓 Understanding the Pipeline Code

### Key Workflow Sections:

#### 1. Trigger Configuration
```yaml
on:
  push:
    branches: [main, Testing-Doc-Branch, Docker-Branch, CI-CD-Branch]
  pull_request:
    branches: [main]
```
Defines when the pipeline runs.

#### 2. Service Container
```yaml
services:
  mysql:
    image: mysql:8.0
    env:
      MYSQL_DATABASE: ${{ secrets.DB_DATABASE }}
```
Provides MySQL for testing without external dependencies.

#### 3. Conditional Deployment
```yaml
if: github.event_name == 'push' && github.ref == 'refs/heads/main'
```
Only deploys to Docker Hub on `main` branch pushes.

---

## 📞 Support & Additional Resources

### Documentation:
- [GitHub Actions Docs](https://docs.github.com/en/actions)
- [Laravel Testing](https://laravel.com/docs/testing)
- [Docker Hub](https://docs.docker.com/docker-hub/)

### Monitoring:
- Pipeline runs: `https://github.com/YOUR_USERNAME/YOUR_REPO/actions`
- Docker Hub: `https://hub.docker.com/r/YOUR_USERNAME/laravel-notes-app`

---

## ✅ Success Indicators

Your pipeline is working correctly when:

1. ✅ All 8 tests pass in CI
2. ✅ Code style check passes
3. ✅ Docker image builds successfully
4. ✅ Image appears in Docker Hub
5. ✅ Three tags created (latest, main, main-sha)
6. ✅ Build completes in under 10 minutes

---

**Last Updated:** October 29, 2025  
**Pipeline Version:** 1.0.0  
**Status:** Production Ready ✅
