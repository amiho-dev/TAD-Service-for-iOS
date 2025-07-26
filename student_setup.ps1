# STUDENT SETUP - No Apple Developer Account Needed!
# Get your IPA without certificates

Write-Host "STUDENT TAD SERVICE SETUP" -ForegroundColor Green
Write-Host "=========================" -ForegroundColor Yellow
Write-Host "No Apple Developer account needed!" -ForegroundColor Cyan

Write-Host "`n1. Upload to GitHub (Manual - Super Easy)" -ForegroundColor Cyan
Write-Host "   Since Git might not work, let's do it manually:" -ForegroundColor Yellow
Write-Host "   1. Go to https://github.com/amiho-dev/tad-service" -ForegroundColor White
Write-Host "   2. Click 'uploading an existing file'" -ForegroundColor White
Write-Host "   3. Drag ALL files from this folder to the browser" -ForegroundColor White
Write-Host "   4. Commit with message: 'Flutter TAD Service App'" -ForegroundColor White

Read-Host "`n   Press Enter to open your GitHub repo"
Start-Process "https://github.com/amiho-dev/tad-service"

Write-Host "`n2. GitHub Actions will build your unsigned IPA!" -ForegroundColor Cyan
Write-Host "   After uploading files:" -ForegroundColor Yellow
Write-Host "   1. Go to 'Actions' tab in your GitHub repo" -ForegroundColor White
Write-Host "   2. The build will start automatically" -ForegroundColor White
Write-Host "   3. Wait 15-20 minutes" -ForegroundColor White
Write-Host "   4. Download 'TAD-Service-Unsigned-IPA' from artifacts" -ForegroundColor White

Write-Host "`n3. Install on iPhone (No Certificate Needed!)" -ForegroundColor Cyan
Write-Host "   Option A - AltStore (Recommended):" -ForegroundColor Yellow
Write-Host "   1. Install AltStore on your computer and iPhone" -ForegroundColor White
Write-Host "   2. Use AltStore to install the unsigned IPA" -ForegroundColor White
Write-Host "   3. Refresh every 7 days (free limit)" -ForegroundColor White

Write-Host "`n   Option B - Sideloadly:" -ForegroundColor Yellow
Write-Host "   1. Download Sideloadly (free tool)" -ForegroundColor White
Write-Host "   2. Connect iPhone via USB" -ForegroundColor White
Write-Host "   3. Drag IPA to Sideloadly" -ForegroundColor White
Write-Host "   4. Use your Apple ID (free)" -ForegroundColor White

Write-Host "`n   Option C - iOS App Installer:" -ForegroundColor Yellow
Write-Host "   1. Upload IPA to diawi.com" -ForegroundColor White
Write-Host "   2. Get install link" -ForegroundColor White
Write-Host "   3. Open link on iPhone Safari" -ForegroundColor White

Write-Host "`nSTUDENT ADVANTAGES:" -ForegroundColor Green
Write-Host "   - No Apple Developer account needed ($0 vs $99)" -ForegroundColor Cyan
Write-Host "   - No certificates or provisioning profiles" -ForegroundColor Cyan
Write-Host "   - Builds automatically on GitHub" -ForegroundColor Cyan
Write-Host "   - Multiple install methods" -ForegroundColor Cyan
Write-Host "   - Perfect for testing and development" -ForegroundColor Cyan

Write-Host "`nYour app will work exactly the same!" -ForegroundColor Magenta
Write-Host "The only difference is how you install it (which is actually easier!)" -ForegroundColor Yellow

Read-Host "`nPress Enter to open helpful tools..."

# Open useful tools
Start-Process "https://altstore.io"  # AltStore
Start-Process "https://sideloadly.io"  # Sideloadly
Start-Process "https://diawi.com"  # diawi for web install

Write-Host "`nNext steps:" -ForegroundColor Green
Write-Host "1. Upload files to GitHub (browser)" -ForegroundColor White
Write-Host "2. Wait for GitHub Actions build (15-20 min)" -ForegroundColor White
Write-Host "3. Download unsigned IPA" -ForegroundColor White
Write-Host "4. Install using AltStore/Sideloadly/diawi" -ForegroundColor White
