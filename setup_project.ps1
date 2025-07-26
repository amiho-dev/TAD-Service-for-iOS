# TAD Service Flutter App Setup Script
# Run this script after installing Flutter and Git

Write-Host "Setting up TAD Service Flutter App..." -ForegroundColor Green

# Check if Flutter is installed
try {
    flutter --version
    Write-Host "✓ Flutter is installed" -ForegroundColor Green
} catch {
    Write-Host "✗ Flutter is not installed. Please install Flutter first." -ForegroundColor Red
    exit 1
}

# Check if Git is installed
try {
    git --version
    Write-Host "✓ Git is installed" -ForegroundColor Green
} catch {
    Write-Host "✗ Git is not installed. Please install Git first." -ForegroundColor Red
    exit 1
}

# Navigate to project directory
Set-Location "c:\Users\amiho\Documents\TAD Service"

# Initialize Git repository
Write-Host "Initializing Git repository..." -ForegroundColor Yellow
git init
git add .
git commit -m "Initial commit: TAD Service Flutter App"

# Get Flutter dependencies
Write-Host "Getting Flutter dependencies..." -ForegroundColor Yellow
flutter pub get

# Run Flutter doctor
Write-Host "Running Flutter doctor..." -ForegroundColor Yellow
flutter doctor

Write-Host "Setup complete! Next steps:" -ForegroundColor Green
Write-Host "1. Create a GitHub repository and push your code" -ForegroundColor Cyan
Write-Host "2. Set up Codemagic for iOS builds" -ForegroundColor Cyan
Write-Host "3. Configure Apple Developer account for iOS distribution" -ForegroundColor Cyan
