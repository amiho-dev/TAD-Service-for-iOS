# REACT NATIVE SETUP - SUPER SIMPLE!
# Get your TAD Service app running in minutes

Write-Host "TAD SERVICE - REACT NATIVE SETUP" -ForegroundColor Green
Write-Host "==================================" -ForegroundColor Yellow

# Check if Node.js is installed
Write-Host "`n1. Checking Node.js..." -ForegroundColor Cyan
try {
    $nodeVersion = node --version
    Write-Host "   Node.js installed: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "   Node.js not found! Installing..." -ForegroundColor Yellow
    Write-Host "   Opening Node.js download page..." -ForegroundColor White
    Start-Process "https://nodejs.org/en/download/"
    Read-Host "   Install Node.js and press Enter to continue"
}

# Install dependencies
Write-Host "`n2. Installing dependencies..." -ForegroundColor Cyan
npm install

# Install Expo CLI
Write-Host "`n3. Installing Expo CLI..." -ForegroundColor Cyan
npm install -g @expo/cli
npm install -g eas-cli

Write-Host "`n4. DOWNLOAD SPACE GROTESK FONT" -ForegroundColor Cyan
Write-Host "   1. Go to Google Fonts" -ForegroundColor White
Write-Host "   2. Download Space Grotesk font family" -ForegroundColor White
Write-Host "   3. Extract .ttf files to assets/fonts/ folder" -ForegroundColor White

Read-Host "`n   Press Enter to open Google Fonts"
Start-Process "https://fonts.google.com/specimen/Space+Grotesk"

Write-Host "`n5. START DEVELOPMENT SERVER" -ForegroundColor Cyan
Write-Host "   Run: npx expo start" -ForegroundColor Yellow
Write-Host "   Then scan QR code with Expo Go app on iPhone!" -ForegroundColor White

Write-Host "`n6. BUILD IPA (when ready)" -ForegroundColor Cyan
Write-Host "   Run: eas build --platform ios --profile preview" -ForegroundColor Yellow
Write-Host "   No certificates needed for preview builds!" -ForegroundColor White

Write-Host "`nYOUR APP IS READY!" -ForegroundColor Magenta
Write-Host "Features included:" -ForegroundColor Green
Write-Host "   - Dark mode design" -ForegroundColor Cyan
Write-Host "   - Customer search" -ForegroundColor Cyan
Write-Host "   - Meeting scheduler" -ForegroundColor Cyan
Write-Host "   - Service reports" -ForegroundColor Cyan
Write-Host "   - Digital signatures" -ForegroundColor Cyan
Write-Host "   - Space Grotesk font support" -ForegroundColor Cyan

Write-Host "`nNext steps:" -ForegroundColor Yellow
Write-Host "1. Download Space Grotesk fonts" -ForegroundColor White
Write-Host "2. Run: npx expo start" -ForegroundColor White
Write-Host "3. Test on iPhone with Expo Go" -ForegroundColor White
Write-Host "4. Build IPA when ready!" -ForegroundColor White
