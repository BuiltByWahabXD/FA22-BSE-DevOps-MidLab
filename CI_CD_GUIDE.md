# CI/CD Configuration Guide for Teammate 2
## GitHub Actions Workflow for Laravel Notes App

---

## 📋 Overview

This document provides the recommended GitHub Actions workflow configuration for our Laravel Notes Application. This is meant to help **Teammate 2** (CI/CD Engineer) set up the automated pipeline.

---

## 🎯 Pipeline Requirements

### Trigger Events
- Push to `main` branch
- Push to `dev` branch
- Pull requests to `main` branch

### Pipeline Stages
1. ✅ Code checkout
2. ✅ PHP & Composer setup
3. ✅ MySQL service container
4. ✅ Environment configuration
5. ✅ Database migrations
6. ✅ PHPUnit tests
7. ✅ Laravel Pint (code style)
8. ✅ Docker image build
9. ✅ Push to Docker Hub

---

## 🔐 Required GitHub Secrets

Configure these secrets in: **Repository Settings > Secrets and variables > Actions**

| Secret Name | Description | Example Value |
|------------|-------------|---------------|
| `DOCKER_HUB_USERNAME` | Docker Hub username | `your-dockerhub-username` |
| `DOCKER_HUB_ACCESS_TOKEN` | Docker Hub access token | `dckr_pat_xxxxxxxxxxxxx` |
| `MYSQL_DATABASE` | Database name for testing | `notes_db` |
| `MYSQL_USER` | Database username | `laravel_user` |
| `MYSQL_PASSWORD` | Database password | `password` |
| `MYSQL_ROOT_PASSWORD` | MySQL root password | `root` |

### How to Create Docker Hub Access Token:
1. Log in to Docker Hub
2. Go to **Account Settings > Security**
3. Click **New Access Token**
4. Name: `github-actions-laravel-notes`
5. Permissions: **Read, Write, Delete**
6. Copy the token (save it securely)

---

## 📄 Complete GitHub Actions Workflow

Create this file: `.github/workflows/laravel-ci-cd.yml`

```yaml
name: Laravel CI/CD Pipeline

on:
  push:
    branches: 
      - main
      - dev
  pull_request:
    branches: 
      - main

jobs:
  test-and-build:
    name: Test & Build Laravel Application
    runs-on: ubuntu-latest
    
    services:
      mysql:
        image: mysql:8.0
        env:
          MYSQL_ROOT_PASSWORD: ${{ secrets.MYSQL_ROOT_PASSWORD }}
          MYSQL_DATABASE: ${{ secrets.MYSQL_DATABASE }}
          MYSQL_USER: ${{ secrets.MYSQL_USER }}
          MYSQL_PASSWORD: ${{ secrets.MYSQL_PASSWORD }}
        ports:
          - 3306:3306
        options: >-
          --health-cmd="mysqladmin ping --silent"
          --health-interval=10s
          --health-timeout=5s
          --health-retries=5

    steps:
      - name: 📥 Checkout Code
        uses: actions/checkout@v4
        
      - name: 🐘 Setup PHP
        uses: shivammathur/setup-php@v2
        with:
          php-version: '8.2'
          extensions: mbstring, xml, ctype, json, bcmath, pdo, pdo_mysql, tokenizer, openssl
          coverage: none
          tools: composer:v2
          
      - name: 📦 Cache Composer Dependencies
        uses: actions/cache@v3
        with:
          path: vendor
          key: ${{ runner.os }}-composer-${{ hashFiles('**/composer.lock') }}
          restore-keys: |
            ${{ runner.os }}-composer-
            
      - name: 🎼 Install Composer Dependencies
        run: composer install --prefer-dist --no-progress --no-interaction --optimize-autoloader
        
      - name: 📋 Copy Environment File
        run: cp .env.example .env
        
      - name: 🔑 Generate Application Key
        run: php artisan key:generate
        
      - name: ⚙️ Configure Environment for Testing
        run: |
          php artisan config:clear
          php artisan cache:clear
        env:
          DB_CONNECTION: mysql
          DB_HOST: 127.0.0.1
          DB_PORT: 3306
          DB_DATABASE: ${{ secrets.MYSQL_DATABASE }}
          DB_USERNAME: ${{ secrets.MYSQL_USER }}
          DB_PASSWORD: ${{ secrets.MYSQL_PASSWORD }}
          
      - name: 🗄️ Wait for MySQL to be Ready
        run: |
          until mysqladmin ping -h 127.0.0.1 -P 3306 -u${{ secrets.MYSQL_USER }} -p${{ secrets.MYSQL_PASSWORD }} --silent; do
            echo 'Waiting for MySQL...'
            sleep 2
          done
          echo 'MySQL is ready!'
          
      - name: 🔄 Run Database Migrations
        run: php artisan migrate --force
        env:
          DB_CONNECTION: mysql
          DB_HOST: 127.0.0.1
          DB_PORT: 3306
          DB_DATABASE: ${{ secrets.MYSQL_DATABASE }}
          DB_USERNAME: ${{ secrets.MYSQL_USER }}
          DB_PASSWORD: ${{ secrets.MYSQL_PASSWORD }}
          
      - name: 🧪 Execute PHPUnit Tests
        run: php artisan test
        env:
          DB_CONNECTION: mysql
          DB_HOST: 127.0.0.1
          DB_PORT: 3306
          DB_DATABASE: ${{ secrets.MYSQL_DATABASE }}
          DB_USERNAME: ${{ secrets.MYSQL_USER }}
          DB_PASSWORD: ${{ secrets.MYSQL_PASSWORD }}
          APP_ENV: testing
          
      - name: 🎨 Run Laravel Pint (Code Style)
        run: ./vendor/bin/pint --test
        continue-on-error: true
        
      - name: 🐳 Set up Docker Buildx
        if: github.event_name == 'push'
        uses: docker/setup-buildx-action@v3
        
      - name: 🔐 Login to Docker Hub
        if: github.event_name == 'push'
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKER_HUB_USERNAME }}
          password: ${{ secrets.DOCKER_HUB_ACCESS_TOKEN }}
          
      - name: 📦 Extract Metadata for Docker
        if: github.event_name == 'push'
        id: meta
        uses: docker/metadata-action@v5
        with:
          images: ${{ secrets.DOCKER_HUB_USERNAME }}/laravel-notes-app
          tags: |
            type=ref,event=branch
            type=sha,prefix={{branch}}-
            type=raw,value=latest,enable={{is_default_branch}}
            
      - name: 🏗️ Build and Push Docker Image
        if: github.event_name == 'push'
        uses: docker/build-push-action@v5
        with:
          context: .
          file: ./docker/php/Dockerfile
          push: true
          tags: ${{ steps.meta.outputs.tags }}
          labels: ${{ steps.meta.outputs.labels }}
          cache-from: type=registry,ref=${{ secrets.DOCKER_HUB_USERNAME }}/laravel-notes-app:buildcache
          cache-to: type=registry,ref=${{ secrets.DOCKER_HUB_USERNAME }}/laravel-notes-app:buildcache,mode=max
          
      - name: ✅ Deployment Summary
        if: github.event_name == 'push'
        run: |
          echo "🎉 Pipeline completed successfully!"
          echo "📦 Docker image pushed to Docker Hub"
          echo "🏷️ Tags: ${{ steps.meta.outputs.tags }}"
          echo "🔗 Image: ${{ secrets.DOCKER_HUB_USERNAME }}/laravel-notes-app"
```

---

## 🔍 Workflow Explanation

### Stage 1: Checkout & Setup
- **Checkout Code**: Clones the repository
- **Setup PHP**: Installs PHP 8.2 with required extensions
- **Cache Dependencies**: Speeds up subsequent runs

### Stage 2: Dependencies & Configuration
- **Install Composer**: Installs all PHP dependencies
- **Copy .env**: Creates environment file
- **Generate Key**: Creates Laravel application key
- **Clear Caches**: Ensures clean configuration

### Stage 3: Database
- **MySQL Service**: Runs as a service container
- **Wait for MySQL**: Ensures database is ready
- **Run Migrations**: Creates database schema

### Stage 4: Testing
- **PHPUnit Tests**: Runs all tests
- **Code Style Check**: Validates code formatting

### Stage 5: Docker (only on push)
- **Build Image**: Creates Docker image
- **Push to Hub**: Uploads to Docker Hub
- **Tagging**: Creates multiple tags (branch, SHA, latest)

---

## 🏷️ Docker Image Tagging Strategy

The workflow creates multiple tags for each build:

| Tag Type | Example | When Used |
|----------|---------|-----------|
| Branch | `main`, `dev` | Every push to that branch |
| SHA | `main-abc1234` | Specific commit reference |
| Latest | `latest` | Only on main branch |

### Example Tags:
```
dockerhub-username/laravel-notes-app:main
dockerhub-username/laravel-notes-app:main-abc1234
dockerhub-username/laravel-notes-app:latest
```

---

## 🧪 Testing the Workflow

### Local Testing (Before Pushing):

```bash
# 1. Ensure all tests pass locally
docker-compose exec app php artisan test

# 2. Check code style
docker-compose exec app ./vendor/bin/pint --test

# 3. Build Docker image locally
docker build -f docker/php/Dockerfile -t laravel-notes-app:local .

# 4. Test the built image
docker run --rm laravel-notes-app:local php -v
```

### After Pushing to GitHub:

1. Go to **Actions** tab in GitHub repository
2. Find the latest workflow run
3. Monitor each step's progress
4. Check for any failures
5. View logs for debugging

---

## 🐛 Common Issues & Solutions

### Issue 1: MySQL Connection Timeout
**Solution**: Add wait-for-mysql step (already included in workflow)

### Issue 2: Composer Memory Limit
**Solution**: Add to workflow:
```yaml
- name: Install Dependencies
  run: COMPOSER_MEMORY_LIMIT=-1 composer install
```

### Issue 3: Docker Hub Authentication Failed
**Solution**: 
- Verify `DOCKER_HUB_ACCESS_TOKEN` is correct
- Regenerate token if expired
- Ensure token has write permissions

### Issue 4: Tests Failing in CI but Pass Locally
**Solution**:
- Check environment variables in workflow
- Ensure MySQL service is healthy
- Verify DB_HOST is `127.0.0.1` (not `mysql`)

### Issue 5: Docker Build Timeout
**Solution**: Add to workflow:
```yaml
- name: Build Docker Image
  timeout-minutes: 30
```

---

## 📊 Success Criteria

### Green Pipeline Should Show:
- ✅ All tests passing (8/8)
- ✅ Code style check passed
- ✅ Docker image built successfully
- ✅ Image pushed to Docker Hub
- ✅ All tags created correctly

### Workflow Duration:
- **Expected**: 5-8 minutes
- **Acceptable**: Up to 10 minutes
- **Needs Optimization**: Over 10 minutes

---

## 🔄 Continuous Improvement

### Phase 1 (Current):
- ✅ Basic CI/CD with tests
- ✅ Docker image building
- ✅ Docker Hub deployment

### Phase 2 (Future Enhancements):
- [ ] Add test coverage reporting
- [ ] Implement code quality badges
- [ ] Add security scanning (Snyk, Trivy)
- [ ] Parallel test execution
- [ ] Deployment to staging environment

### Phase 3 (Advanced):
- [ ] Automatic rollback on failure
- [ ] Performance testing
- [ ] Load testing
- [ ] Blue-green deployment
- [ ] Kubernetes deployment

---

## 📈 Monitoring & Notifications

### Add Slack/Discord Notifications:

```yaml
- name: 📢 Notify on Success
  if: success()
  uses: 8398a7/action-slack@v3
  with:
    status: success
    text: '✅ Pipeline passed! Tests: 8/8'
    webhook_url: ${{ secrets.SLACK_WEBHOOK }}

- name: 📢 Notify on Failure
  if: failure()
  uses: 8398a7/action-slack@v3
  with:
    status: failure
    text: '❌ Pipeline failed! Check logs.'
    webhook_url: ${{ secrets.SLACK_WEBHOOK }}
```

---

## 🎓 Best Practices

1. ✅ **Always use secrets** for sensitive data
2. ✅ **Cache dependencies** to speed up builds
3. ✅ **Use specific versions** for actions (e.g., `@v4` not `@latest`)
4. ✅ **Add health checks** for service containers
5. ✅ **Set timeouts** to prevent hanging jobs
6. ✅ **Use descriptive step names** with emojis
7. ✅ **Add continue-on-error** for non-critical steps
8. ✅ **Document everything** in comments

---

## 📝 Verification Checklist

After implementing the workflow:

- [ ] Workflow file created at `.github/workflows/laravel-ci-cd.yml`
- [ ] All GitHub Secrets configured
- [ ] Docker Hub repository created
- [ ] First workflow run successful
- [ ] All tests passing in CI
- [ ] Docker image visible in Docker Hub
- [ ] Multiple tags created properly
- [ ] Team members notified
- [ ] Documentation updated

---

## 📚 Additional Resources

### GitHub Actions:
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Workflow Syntax](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions)
- [GitHub Actions Marketplace](https://github.com/marketplace?type=actions)

### Docker:
- [Docker Hub Documentation](https://docs.docker.com/docker-hub/)
- [Dockerfile Best Practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
- [Multi-stage Builds](https://docs.docker.com/build/building/multi-stage/)

### Laravel:
- [Laravel Testing](https://laravel.com/docs/testing)
- [Laravel Deployment](https://laravel.com/docs/deployment)

---

## 👥 Team Coordination

### Before Implementation:
- [ ] Review this guide with the team
- [ ] Assign Teammate 2 to implement
- [ ] Set up Docker Hub repository
- [ ] Configure GitHub Secrets together

### During Implementation:
- [ ] Test workflow on a feature branch first
- [ ] Monitor first few runs carefully
- [ ] Document any changes or issues
- [ ] Update team on progress

### After Implementation:
- [ ] Share workflow results with team
- [ ] Update proof documentation
- [ ] Collect CI/CD screenshots
- [ ] Add badges to README

---

**Prepared By**: Teammate 3 (Testing & Documentation)  
**For**: Teammate 2 (CI/CD Engineer)  
**Date**: October 30, 2025  
**Status**: Ready for Implementation

---
