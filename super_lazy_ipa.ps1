# SUPER LAZY IPA GENERATION SCRIPT
# This does EVERYTHING for you automatically

Write-Host "SUPER LAZY IPA GENERATION - Doing everything for you!" -ForegroundColor Magenta
Write-Host "========================================================" -ForegroundColor Yellow

# Auto-install Git if missing
Write-Host "`nStep 1: Checking Git..." -ForegroundColor Green
try {
    $null = git --version 2>$null
    Write-Host "Git is installed!" -ForegroundColor Green
}
catch {
    Write-Host "Installing Git automatically..." -ForegroundColor Yellow
    # Download and install Git silently
    $gitUrl = "https://github.com/git-for-windows/git/releases/download/v2.41.0.windows.3/Git-2.41.0.3-64-bit.exe"
    $gitInstaller = "$env:TEMP\GitInstaller.exe"
    
    Write-Host "Downloading Git..." -ForegroundColor Yellow
    Invoke-WebRequest -Uri $gitUrl -OutFile $gitInstaller
    
    Write-Host "Installing Git (this will take a moment)..." -ForegroundColor Yellow
    Start-Process -FilePath $gitInstaller -ArgumentList "/SILENT" -Wait
    
    # Refresh environment variables
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    
    Write-Host "Git installed!" -ForegroundColor Green
}

# Initialize Git repo
Write-Host "`nStep 2: Setting up Git repository..." -ForegroundColor Green
if (!(Test-Path ".git")) {
    git init
    git add .
    git commit -m "Initial commit: TAD Service Flutter App - Auto generated"
    Write-Host "Git repository created!" -ForegroundColor Green
} else {
    Write-Host "Git repository already exists!" -ForegroundColor Green
}

# Open all necessary pages automatically
Write-Host "`nStep 3: Opening all websites you need..." -ForegroundColor Green

Write-Host "Opening GitHub to create repository..." -ForegroundColor Yellow
Start-Process "https://github.com/new"
Start-Sleep -Seconds 2

Write-Host "Opening Codemagic to sign up..." -ForegroundColor Yellow
Start-Process "https://codemagic.io/signup"
Start-Sleep -Seconds 2

Write-Host "Opening Apple Developer for certificates..." -ForegroundColor Yellow
Start-Process "https://developer.apple.com/account/resources/certificates/list"
Start-Sleep -Seconds 2

Write-Host "Opening diawi.com for IPA installation..." -ForegroundColor Yellow
Start-Process "https://www.diawi.com"

# Create a simple instruction file
$instructions = @"
LAZY PERSON'S IPA GENERATION INSTRUCTIONS
==========================================

I've opened all the websites you need. Here's what to do:

1. GITHUB (already open):
   - Create repository named: tad-service-app
   - Don't add README (we have files already)
   - Copy the repository URL

2. APPLE DEVELOPER (already open):
   - Create iOS Development Certificate
   - Create Provisioning Profile for: com.tadservice.tad_service_app
   - Download both files

3. CODEMAGIC (already open):
   - Sign up with GitHub
   - Connect your tad-service-app repository
   - Go to App Settings > Code signing
   - Upload your certificate (.p12) and provisioning profile
   - Click "Start new build"

4. WAIT 10-15 MINUTES:
   - Your IPA will be ready in Codemagic artifacts

5. INSTALL ON IPHONE:
   - Go to diawi.com (already open)
   - Upload your IPA
   - Open the link on your iPhone
   - Install the app

REPOSITORY URL TO COPY/PASTE:
-----------------------------
When you create the GitHub repo, run this command:

git remote add origin [YOUR_REPO_URL]
git push -u origin main

That's it! Your app will be building automatically!
"@

$instructions | Out-File -FilePath "LAZY_INSTRUCTIONS.txt" -Encoding UTF8

Write-Host "`nStep 4: Created instruction file..." -ForegroundColor Green
Write-Host "Opening instruction file..." -ForegroundColor Yellow
Start-Process "LAZY_INSTRUCTIONS.txt"

Write-Host "`n========================" -ForegroundColor Magenta
Write-Host "EVERYTHING IS READY!" -ForegroundColor Magenta
Write-Host "========================" -ForegroundColor Magenta
Write-Host "All websites are open in your browser" -ForegroundColor Green
Write-Host "Instruction file is open" -ForegroundColor Green
Write-Host "Just follow the simple steps!" -ForegroundColor Green
Write-Host "`nYour IPA will be ready in 15 minutes!" -ForegroundColor Cyan

Read-Host "`nPress Enter when you've created your GitHub repo to push the code"

# Get repo URL and push
$repoUrl = Read-Host "Paste your GitHub repository URL here (or press Enter to skip)"

if ($repoUrl -and $repoUrl.Trim() -ne "") {
    Write-Host "Pushing code to GitHub..." -ForegroundColor Yellow
    try {
        git remote add origin $repoUrl
        git branch -M main
        git push -u origin main
        Write-Host "CODE PUSHED! Go to Codemagic and start building!" -ForegroundColor Green
    }
    catch {
        Write-Host "Manual push needed. Run: git remote add origin $repoUrl && git push -u origin main" -ForegroundColor Yellow
    }
}

Write-Host "`nDONE! Now just wait for your IPA!" -ForegroundColor Magenta
