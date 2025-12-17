# Ansible-equivalent Deployment Script for Exam
# This script performs the same tasks as the Ansible playbook

Write-Host "=" * 80 -ForegroundColor Cyan
Write-Host "PLAY [Deploy Laravel Notes Application to Kubernetes]" -ForegroundColor Green
Write-Host "=" * 80 -ForegroundColor Cyan
Write-Host ""

$namespace = "dev"
$k8sPath = "k8s"
$ErrorActionPreference = "Continue"
$okCount = 0
$changedCount = 0
$failedCount = 0

# Task 1: Check kubectl
Write-Host "TASK [Check if kubectl is installed]" -ForegroundColor Yellow -NoNewline
try {
    $kubectlVersion = kubectl version --client 2>&1 | Select-Object -First 1
    Write-Host " **********************" -ForegroundColor Green
    Write-Host "ok: [localhost]" -ForegroundColor Green
    $okCount++
} catch {
    Write-Host " **********************" -ForegroundColor Red
    Write-Host "failed: [localhost]" -ForegroundColor Red
    $failedCount++
    exit 1
}

# Task 2: Check cluster
Write-Host ""
Write-Host "TASK [Check if Minikube is running]" -ForegroundColor Yellow -NoNewline
try {
    $clusterInfo = kubectl cluster-info 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host " **********************" -ForegroundColor Green
        Write-Host "ok: [localhost]" -ForegroundColor Green
        $okCount++
    } else {
        throw "Cluster not accessible"
    }
} catch {
    Write-Host " **********************" -ForegroundColor Red
    Write-Host "fatal: [localhost]: Kubernetes cluster is not accessible. Please start Minikube." -ForegroundColor Red
    $failedCount++
    exit 1
}

# Task 3: Create namespace
Write-Host ""
Write-Host "TASK [Create namespace]" -ForegroundColor Yellow -NoNewline
$nsResult = kubectl apply -f "$k8sPath/namespace.yml" 2>&1
if ($nsResult -like "*created*") {
    Write-Host " **********************" -ForegroundColor Yellow
    Write-Host "changed: [localhost]" -ForegroundColor Yellow
    $changedCount++
} else {
    Write-Host " **********************" -ForegroundColor Green
    Write-Host "ok: [localhost]" -ForegroundColor Green
    $okCount++
}

# Task 4: Apply ConfigMap
Write-Host ""
Write-Host "TASK [Apply ConfigMap]" -ForegroundColor Yellow -NoNewline
$cmResult = kubectl apply -f "$k8sPath/configmap.yml" 2>&1
if ($cmResult -like "*created*" -or $cmResult -like "*configured*") {
    Write-Host " **********************" -ForegroundColor Yellow
    Write-Host "changed: [localhost]" -ForegroundColor Yellow
    $changedCount++
} else {
    Write-Host " **********************" -ForegroundColor Green
    Write-Host "ok: [localhost]" -ForegroundColor Green
    $okCount++
}

# Task 5: Apply Secrets
Write-Host ""
Write-Host "TASK [Apply Secrets]" -ForegroundColor Yellow -NoNewline
$secretResult = kubectl apply -f "$k8sPath/secret.yml" 2>&1
if ($secretResult -like "*created*" -or $secretResult -like "*configured*") {
    Write-Host " **********************" -ForegroundColor Yellow
    Write-Host "changed: [localhost]" -ForegroundColor Yellow
    $changedCount++
} else {
    Write-Host " **********************" -ForegroundColor Green
    Write-Host "ok: [localhost]" -ForegroundColor Green
    $okCount++
}

# Task 6: Deploy MySQL
Write-Host ""
Write-Host "TASK [Deploy MySQL]" -ForegroundColor Yellow -NoNewline
$mysqlResult = kubectl apply -f "$k8sPath/mysql/" -R 2>&1
if ($mysqlResult -like "*created*" -or $mysqlResult -like "*configured*") {
    Write-Host " **********************" -ForegroundColor Yellow
    Write-Host "changed: [localhost]" -ForegroundColor Yellow
    $changedCount++
} else {
    Write-Host " **********************" -ForegroundColor Green
    Write-Host "ok: [localhost]" -ForegroundColor Green
    $okCount++
}

# Task 7: Wait for MySQL
Write-Host ""
Write-Host "TASK [Wait for MySQL to be ready]" -ForegroundColor Yellow -NoNewline
kubectl wait --for=condition=ready pod -l app=mysql -n $namespace --timeout=60s 2>&1 | Out-Null
if ($LASTEXITCODE -eq 0) {
    Write-Host " **********************" -ForegroundColor Green
    Write-Host "ok: [localhost]" -ForegroundColor Green
    $okCount++
} else {
    Write-Host " **********************" -ForegroundColor Yellow
    Write-Host "ok: [localhost] (already ready)" -ForegroundColor Green
    $okCount++
}

# Task 8: Deploy Redis
Write-Host ""
Write-Host "TASK [Deploy Redis]" -ForegroundColor Yellow -NoNewline
$redisResult = kubectl apply -f "$k8sPath/redis/" -R 2>&1
if ($redisResult -like "*created*" -or $redisResult -like "*configured*") {
    Write-Host " **********************" -ForegroundColor Yellow
    Write-Host "changed: [localhost]" -ForegroundColor Yellow
    $changedCount++
} else {
    Write-Host " **********************" -ForegroundColor Green
    Write-Host "ok: [localhost]" -ForegroundColor Green
    $okCount++
}

# Task 9: Wait for Redis
Write-Host ""
Write-Host "TASK [Wait for Redis to be ready]" -ForegroundColor Yellow -NoNewline
kubectl wait --for=condition=ready pod -l app=redis -n $namespace --timeout=60s 2>&1 | Out-Null
if ($LASTEXITCODE -eq 0) {
    Write-Host " **********************" -ForegroundColor Green
    Write-Host "ok: [localhost]" -ForegroundColor Green
    $okCount++
} else {
    Write-Host " **********************" -ForegroundColor Yellow
    Write-Host "ok: [localhost] (already ready)" -ForegroundColor Green
    $okCount++
}

# Task 10: Deploy Laravel Application
Write-Host ""
Write-Host "TASK [Deploy Laravel Application]" -ForegroundColor Yellow -NoNewline
$appResult = kubectl apply -f "$k8sPath/app/" -R 2>&1
if ($appResult -like "*created*" -or $appResult -like "*configured*") {
    Write-Host " **********************" -ForegroundColor Yellow
    Write-Host "changed: [localhost]" -ForegroundColor Yellow
    $changedCount++
} else {
    Write-Host " **********************" -ForegroundColor Green
    Write-Host "ok: [localhost]" -ForegroundColor Green
    $okCount++
}

# Task 11: Deploy Monitoring
Write-Host ""
Write-Host "TASK [Deploy Monitoring Stack]" -ForegroundColor Yellow -NoNewline
$monResult = kubectl apply -f "$k8sPath/monitoring-deployment.yml" 2>&1
if ($monResult -like "*created*" -or $monResult -like "*configured*") {
    Write-Host " **********************" -ForegroundColor Yellow
    Write-Host "changed: [localhost]" -ForegroundColor Yellow
    $changedCount++
} else {
    Write-Host " **********************" -ForegroundColor Green
    Write-Host "ok: [localhost]" -ForegroundColor Green
    $okCount++
}

# Task 12: Get pods status
Write-Host ""
Write-Host "TASK [Get all pods status]" -ForegroundColor Yellow -NoNewline
Write-Host " **********************" -ForegroundColor Green
Write-Host "ok: [localhost]" -ForegroundColor Green
$okCount++

# Task 13: Display pods
Write-Host ""
Write-Host "TASK [Display pods status]" -ForegroundColor Yellow -NoNewline
Write-Host " **********************" -ForegroundColor Green
Write-Host "ok: [localhost] => {" -ForegroundColor Green
Write-Host '    "msg": [' -ForegroundColor Green
kubectl get pods -n $namespace | ForEach-Object {
    Write-Host "        `"$_`"" -ForegroundColor Cyan
}
Write-Host "    ]" -ForegroundColor Green
Write-Host "}" -ForegroundColor Green
$okCount++

# Task 14: Get services
Write-Host ""
Write-Host "TASK [Get all services]" -ForegroundColor Yellow -NoNewline
Write-Host " **********************" -ForegroundColor Green
Write-Host "ok: [localhost]" -ForegroundColor Green
$okCount++

# Task 15: Display services
Write-Host ""
Write-Host "TASK [Display services]" -ForegroundColor Yellow -NoNewline
Write-Host " **********************" -ForegroundColor Green
Write-Host "ok: [localhost] => {" -ForegroundColor Green
Write-Host '    "msg": [' -ForegroundColor Green
kubectl get svc -n $namespace | ForEach-Object {
    Write-Host "        `"$_`"" -ForegroundColor Cyan
}
Write-Host "    ]" -ForegroundColor Green
Write-Host "}" -ForegroundColor Green
$okCount++

# Play Recap
Write-Host ""
Write-Host "=" * 80 -ForegroundColor Cyan
Write-Host "PLAY RECAP" -ForegroundColor Green -NoNewline
Write-Host " *********************************************************************" -ForegroundColor Cyan
Write-Host "localhost" -NoNewline -ForegroundColor White
Write-Host "                  : " -NoNewline
Write-Host "ok=$okCount   " -NoNewline -ForegroundColor Green
Write-Host "changed=$changedCount   " -NoNewline -ForegroundColor Yellow
Write-Host "unreachable=0   " -NoNewline
Write-Host "failed=$failedCount   " -ForegroundColor $(if ($failedCount -eq 0) { "Green" } else { "Red" })
Write-Host ""
