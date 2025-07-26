# FIX NODE.JS PATH - Get your app running NOW!

Write-Host "FIXING NODE.JS PATH ISSUE" -ForegroundColor Green
Write-Host "=========================" -ForegroundColor Yellow

Write-Host "`n1. Checking common Node.js installation paths..." -ForegroundColor Cyan

# Common Node.js installation paths
$nodePaths = @(
    "$env:ProgramFiles\nodejs\node.exe",
    "$env:ProgramFiles(x86)\nodejs\node.exe",
    "$env:APPDATA\npm\node.exe",
    "$env:LOCALAPPDATA\nvs\default\node.exe"
)

$nodeFound = $false
foreach ($path in $nodePaths) {
    if (Test-Path $path) {
        Write-Host "   Found Node.js at: $path" -ForegroundColor Green
        $nodeDir = Split-Path $path
        
        # Add to current session PATH
        $env:PATH = "$nodeDir;$env:PATH"
        
        # Test if it works now
        try {
            $version = & "$path" --version
            Write-Host "   Node.js version: $version" -ForegroundColor Green
            $nodeFound = $true
            break
        } catch {
            Write-Host "   Path found but Node.js not working" -ForegroundColor Red
        }
    }
}

if (-not $nodeFound) {
    Write-Host "`n2. Node.js not found. Quick install options:" -ForegroundColor Yellow
    Write-Host "   Option A: Restart VS Code (if you just installed Node.js)" -ForegroundColor White
    Write-Host "   Option B: Use PowerShell as Administrator" -ForegroundColor White
    Write-Host "   Option C: Install via Chocolatey (fastest)" -ForegroundColor White
    
    $choice = Read-Host "`n   Choose option (A/B/C)"
    
    if ($choice -eq "C" -or $choice -eq "c") {
        Write-Host "`n   Installing Chocolatey and Node.js..." -ForegroundColor Cyan
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
        choco install nodejs -y
        refreshenv
    } else {
        Write-Host "`n   Please restart VS Code and try again" -ForegroundColor Yellow
        exit
    }
}

Write-Host "`n3. Installing app dependencies..." -ForegroundColor Cyan
try {
    npm install
    Write-Host "   Dependencies installed!" -ForegroundColor Green
} catch {
    Write-Host "   Error installing dependencies. Try: npm install" -ForegroundColor Red
}

Write-Host "`n4. Installing Expo CLI..." -ForegroundColor Cyan
try {
    npm install -g @expo/cli
    Write-Host "   Expo CLI installed!" -ForegroundColor Green
} catch {
    Write-Host "   Error installing Expo CLI. Try: npm install -g @expo/cli" -ForegroundColor Red
}

Write-Host "`nREADY TO START YOUR APP!" -ForegroundColor Magenta
Write-Host "=========================" -ForegroundColor Yellow
Write-Host "`nRun these commands:" -ForegroundColor Green
Write-Host "   npx expo start" -ForegroundColor Cyan
Write-Host "`nThen:" -ForegroundColor Green
Write-Host "   1. Install 'Expo Go' app on your iPhone" -ForegroundColor White
Write-Host "   2. Scan the QR code that appears" -ForegroundColor White
Write-Host "   3. Your TAD Service app will open on iPhone!" -ForegroundColor White

Write-Host "`nDOWNLOAD SPACE GROTESK FONT:" -ForegroundColor Yellow
Write-Host "   1. Go to: https://fonts.google.com/specimen/Space+Grotesk" -ForegroundColor White
Write-Host "   2. Download and extract to assets/fonts/ folder" -ForegroundColor White

Read-Host "`nPress Enter to open font download page"
Start-Process "https://fonts.google.com/specimen/Space+Grotesk"
