@echo off
echo ================================================
echo         LOCAL TAD SERVICE APP START
echo ================================================
echo.
echo Starting Expo development server...
echo This might take a moment...
echo.

REM Try different ways to start expo
set NODE_PATH=C:\Program Files\nodejs
set PATH=%NODE_PATH%;%PATH%

REM Method 1: Try npx expo
"%NODE_PATH%\npx.cmd" expo start --web
if %ERRORLEVEL% EQU 0 goto success

echo.
echo Method 1 failed, trying Method 2...
echo.

REM Method 2: Try node directly with expo
"%NODE_PATH%\node.exe" "%~dp0node_modules\.bin\expo" start --web
if %ERRORLEVEL% EQU 0 goto success

echo.
echo Method 2 failed, trying Method 3...
echo.

REM Method 3: Try global expo
"%NODE_PATH%\expo.cmd" start --web
if %ERRORLEVEL% EQU 0 goto success

echo.
echo ================================================
echo   LOCAL SETUP FAILED - USE GITHUB CODESPACES!
echo ================================================
echo.
echo Windows has complex PATH/npm issues.
echo For instant success:
echo.
echo 1. Upload files to GitHub
echo 2. Create Codespace  
echo 3. Run: npm install && npx expo start --web
echo 4. Get your IPA: npx eas build --platform ios
echo.
echo GitHub Codespaces = ZERO setup issues!
echo.
pause
exit /b 1

:success
echo.
echo ================================================
echo     SUCCESS! App should open in browser
echo ================================================
echo.
echo For IPA build, run:
echo npx eas build --platform ios --profile preview
echo.
pause
