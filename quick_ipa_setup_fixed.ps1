# TAD Service - Quick IPA Generation Setup
# For Windows users with free iOS certificates

Write-Host "TAD Service - Quick IPA Setup" -ForegroundColor Green
Write-Host "===============================" -ForegroundColor Yellow

# Step 1: Check Git
Write-Host "`n1. Checking Git..." -ForegroundColor Cyan
if (Get-Command git -ErrorAction SilentlyContinue) {
    Write-Host "   Git is installed" -ForegroundColor Green
} else {
    Write-Host "   Git not found. Install from: https://git-scm.com/download/win" -ForegroundColor Red
    exit
}

# Step 2: Initialize Git Repository
Write-Host "`n2. Setting up Git repository..." -ForegroundColor Cyan
if (!(Test-Path ".git")) {
    git init
    git add .
    git commit -m "Initial commit: TAD Service Flutter App"
    Write-Host "   Git repository initialized" -ForegroundColor Green
} else {
    Write-Host "   Git repository already exists" -ForegroundColor Green
}

# Step 3: GitHub Repository Setup
Write-Host "`n3. GitHub Repository Setup" -ForegroundColor Cyan
Write-Host "   Next steps for GitHub:" -ForegroundColor Yellow
Write-Host "   1. Go to https://github.com/new" -ForegroundColor White
Write-Host "   2. Create repository named: tad-service-app" -ForegroundColor White
Write-Host "   3. Don't initialize with README" -ForegroundColor White
Write-Host "   4. Copy the repository URL" -ForegroundColor White

$repoUrl = Read-Host "`n   Enter your GitHub repository URL"

if ($repoUrl) {
    git remote add origin $repoUrl
    git branch -M main
    git push -u origin main
    Write-Host "   Code pushed to GitHub successfully!" -ForegroundColor Green
}

# Step 4: Codemagic Setup
Write-Host "`n4. Codemagic IPA Generation Setup" -ForegroundColor Cyan
Write-Host "   Codemagic setup steps:" -ForegroundColor Yellow
Write-Host "   1. Go to https://codemagic.io/signup" -ForegroundColor White
Write-Host "   2. Sign up with your GitHub account" -ForegroundColor White
Write-Host "   3. Connect your tad-service-app repository" -ForegroundColor White
Write-Host "   4. The codemagic.yaml file is already configured!" -ForegroundColor White
Write-Host "   5. Add your iOS certificates in Codemagic settings" -ForegroundColor White
Write-Host "   6. Trigger a build to get your IPA!" -ForegroundColor White

Read-Host "`n   Press Enter to open Codemagic signup page"
Start-Process "https://codemagic.io/signup"

# Step 5: Alternative - GitHub Actions
Write-Host "`n5. Alternative: GitHub Actions" -ForegroundColor Cyan
Write-Host "   GitHub Actions setup:" -ForegroundColor Yellow
Write-Host "   1. Enable GitHub Actions in your repository" -ForegroundColor White
Write-Host "   2. Add iOS certificates to GitHub Secrets" -ForegroundColor White
Write-Host "   3. Workflow file is already created" -ForegroundColor White

Write-Host "`nSetup Summary:" -ForegroundColor Green
Write-Host "   Project files ready" -ForegroundColor Green
Write-Host "   Git repository configured" -ForegroundColor Green
Write-Host "   Codemagic config file created" -ForegroundColor Green
Write-Host "   iOS export options configured" -ForegroundColor Green

Write-Host "`nYour IPA will be ready in 10-15 minutes after build!" -ForegroundColor Magenta
Write-Host "   You can install it using Apple Configurator or diawi.com" -ForegroundColor Cyan
