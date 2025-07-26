# TAD Service - LAZY SETUP (Does everything for you!)
# Just run this and follow the prompts

Write-Host "TAD Service - LAZY SETUP" -ForegroundColor Green
Write-Host "=========================" -ForegroundColor Yellow

# Step 1: Git setup
Write-Host "`n1. Setting up Git..." -ForegroundColor Cyan
if (!(Test-Path ".git")) {
    git init
    git add .
    git commit -m "Initial commit: TAD Service Flutter App"
    Write-Host "   Git repository created!" -ForegroundColor Green
} else {
    Write-Host "   Git already setup!" -ForegroundColor Green
}

# Step 2: Auto-open GitHub to create repo
Write-Host "`n2. Opening GitHub to create repository..." -ForegroundColor Cyan
Write-Host "   - Repository name: tad-service-app" -ForegroundColor White
Write-Host "   - Keep it PUBLIC (free builds)" -ForegroundColor White
Write-Host "   - DON'T add README, .gitignore, or license" -ForegroundColor White

Start-Process "https://github.com/new"
Write-Host "`nWaiting for you to create the GitHub repo..." -ForegroundColor Yellow
$repoUrl = Read-Host "Paste your GitHub repo URL here (https://github.com/username/tad-service-app.git)"

if ($repoUrl) {
    git remote add origin $repoUrl
    git branch -M main
    git push -u origin main
    Write-Host "   Code pushed to GitHub!" -ForegroundColor Green
}

# Step 3: Auto-open Codemagic
Write-Host "`n3. Opening Codemagic for iOS builds..." -ForegroundColor Cyan
Write-Host "   - Sign up with GitHub" -ForegroundColor White
Write-Host "   - Connect your tad-service-app repository" -ForegroundColor White
Write-Host "   - The build config is already done!" -ForegroundColor White

Start-Process "https://codemagic.io/signup"

# Step 4: Certificate instructions
Write-Host "`n4. iOS Certificate Setup (You need to do this once):" -ForegroundColor Cyan
Write-Host "   - Go to https://developer.apple.com/account" -ForegroundColor White
Write-Host "   - Certificates -> + -> iOS Development" -ForegroundColor White
Write-Host "   - Download and add to Codemagic" -ForegroundColor White

Start-Process "https://developer.apple.com/account/resources/certificates/list"

Write-Host "`n5. Final Steps:" -ForegroundColor Magenta
Write-Host "   1. In Codemagic: Add your iOS certificate" -ForegroundColor White
Write-Host "   2. Click 'Start new build'" -ForegroundColor White
Write-Host "   3. Wait 10-15 minutes" -ForegroundColor White
Write-Host "   4. Download IPA from artifacts" -ForegroundColor White
Write-Host "   5. Install via diawi.com or Apple Configurator" -ForegroundColor White

Write-Host "`nYour IPA will be ready soon!" -ForegroundColor Green
Read-Host "Press Enter to continue..."
