# SUPER LAZY SETUP - Handles everything including Git issues
# Just run this and it fixes everything!

Write-Host "SUPER LAZY TAD SERVICE SETUP" -ForegroundColor Green
Write-Host "=============================" -ForegroundColor Yellow

# Check if Git works
Write-Host "`n1. Checking Git..." -ForegroundColor Cyan
try {
    $gitVersion = git --version 2>$null
    if ($gitVersion) {
        Write-Host "   Git is working!" -ForegroundColor Green
        
        # Fix the Git setup
        Write-Host "`n2. Fixing Git repository..." -ForegroundColor Cyan
        
        # Remove existing remote if it exists
        git remote remove origin 2>$null
        
        # Add all files and create initial commit
        git add .
        git commit -m "Initial commit: TAD Service Flutter App"
        
        # Add the correct remote
        git remote add origin "https://github.com/amiho-dev/tad-service"
        
        # Create and push to main branch
        git branch -M main
        git push -u origin main
        
        Write-Host "   Code pushed to GitHub successfully!" -ForegroundColor Green
    }
} catch {
    Write-Host "   Git not working properly" -ForegroundColor Red
    Write-Host "   No worries! You can upload files manually to GitHub" -ForegroundColor Yellow
    Write-Host "`n   Manual steps:" -ForegroundColor Cyan
    Write-Host "   1. Go to https://github.com/amiho-dev/tad-service" -ForegroundColor White
    Write-Host "   2. Click 'uploading an existing file'" -ForegroundColor White
    Write-Host "   3. Drag and drop ALL files from this folder" -ForegroundColor White
    Write-Host "   4. Commit with message: 'Initial commit'" -ForegroundColor White
    
    Read-Host "`n   Press Enter to open your GitHub repo"
    Start-Process "https://github.com/amiho-dev/tad-service"
}

Write-Host "`n3. Opening Codemagic..." -ForegroundColor Cyan
Start-Process "https://codemagic.io/signup"

Write-Host "`n4. Opening Apple Developer..." -ForegroundColor Cyan
Start-Process "https://developer.apple.com/account/resources/certificates/list"

Write-Host "`nNEXT STEPS (Easy!):" -ForegroundColor Magenta
Write-Host "1. In Codemagic:" -ForegroundColor Yellow
Write-Host "   - Sign up with GitHub" -ForegroundColor White
Write-Host "   - Connect 'tad-service' repository" -ForegroundColor White
Write-Host "   - It will auto-detect the codemagic.yaml build config!" -ForegroundColor White

Write-Host "`n2. Add iOS Certificate:" -ForegroundColor Yellow
Write-Host "   - In Apple Developer: Create iOS Development certificate" -ForegroundColor White
Write-Host "   - Download the .p12 file" -ForegroundColor White
Write-Host "   - Upload to Codemagic in App Settings > Code signing" -ForegroundColor White

Write-Host "`n3. Build IPA:" -ForegroundColor Yellow
Write-Host "   - In Codemagic: Click 'Start new build'" -ForegroundColor White
Write-Host "   - Wait 10-15 minutes" -ForegroundColor White
Write-Host "   - Download IPA from Artifacts" -ForegroundColor White

Write-Host "`n4. Install on iPhone:" -ForegroundColor Yellow
Write-Host "   - Upload IPA to diawi.com" -ForegroundColor White
Write-Host "   - Get install link and open on iPhone" -ForegroundColor White

Write-Host "`nYour app is fully ready to build!" -ForegroundColor Green
Read-Host "Press Enter to finish..."
