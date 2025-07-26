# 🚀 Quick IPA Generation Guide

## For Windows Users with Free iOS Certificates

Since you have **10 free certificates per week**, here are the fastest ways to get your TAD Service app IPA:

---

## 🎯 Method 1: Codemagic (Recommended - 10 minutes)

### Step 1: Setup Repository
```powershell
# Run this in your project folder
.\quick_ipa_setup.ps1
```

### Step 2: Codemagic Setup
1. Go to **https://codemagic.io/signup**
2. Sign up with GitHub
3. Connect your `tad-service-app` repository
4. The build will automatically use the `codemagic.yaml` config

### Step 3: Add iOS Certificate
1. In Codemagic dashboard → **App Settings** → **Code signing**
2. Upload your **Development Certificate (.p12)**
3. Upload your **Provisioning Profile (.mobileprovision)**
4. Update `ios/ExportOptions.plist` with your Team ID

### Step 4: Trigger Build
- Click **Start new build**
- Wait ~10-15 minutes
- Download IPA from **Artifacts**

---

## 🎯 Method 2: GitHub Actions (Alternative - 15 minutes)

### Step 1: Push to GitHub
```powershell
git add .
git commit -m "Add iOS build workflow"
git push origin main
```

### Step 2: Add Secrets
In GitHub repository → **Settings** → **Secrets and variables** → **Actions**:
- `IOS_CERTIFICATE_BASE64`: Your certificate in base64
- `IOS_CERTIFICATE_PASSWORD`: Certificate password
- `IOS_PROVISIONING_PROFILE_BASE64`: Provisioning profile in base64

### Step 3: Run Workflow
- Go to **Actions** tab
- Run **Build iOS IPA** workflow
- Download IPA from artifacts

---

## 🎯 Method 3: Local Build (If you have Mac access)

```bash
# Clone and setup
git clone [your-repo-url]
cd tad-service-app
flutter pub get
cd ios && pod install && cd ..

# Build IPA
flutter build ios --release
cd ios
xcodebuild -workspace Runner.xcworkspace \
  -scheme Runner \
  -configuration Release \
  -destination generic/platform=iOS \
  -archivePath ../build/Runner.xcarchive \
  archive

xcodebuild -exportArchive \
  -archivePath ../build/Runner.xcarchive \
  -exportPath ../build/ipa \
  -exportOptionsPlist ExportOptions.plist
```

---

## 📱 Installing IPA on iPhone

### Method 1: Apple Configurator 2 (Mac only)
1. Download Apple Configurator 2 from Mac App Store
2. Connect iPhone via USB
3. Drag & drop IPA file

### Method 2: diawi.com (Any platform)
1. Go to **https://www.diawi.com**
2. Upload your IPA
3. Share the link with your iPhone
4. Open link in Safari on iPhone
5. Follow installation prompts

### Method 3: AltStore (Windows/Mac)
1. Install AltStore on your computer
2. Install AltStore app on iPhone
3. Use AltStore to install IPA

### Method 4: TestFlight (For distribution)
1. Upload IPA to App Store Connect
2. Create TestFlight build
3. Invite testers via email

---

## 🔧 Certificate Setup (Free Certificates)

### Get Development Certificate:
1. Go to **https://developer.apple.com/account**
2. **Certificates, Identifiers & Profiles**
3. **Certificates** → **+** → **iOS Development**
4. Download `.cer` file and convert to `.p12`

### Get Provisioning Profile:
1. **Profiles** → **+** → **iOS App Development**
2. Select your App ID: `com.tadservice.tad_service_app`
3. Select your certificate
4. Select your device
5. Download `.mobileprovision` file

---

## ⚡ Quick Start (Just run this!)

```powershell
# 1. Run setup script
.\quick_ipa_setup.ps1

# 2. Go to codemagic.io and connect your repo
# 3. Add your iOS certificates
# 4. Build!
```

**Your IPA will be ready in ~10-15 minutes!** 🎉

---

## 📋 What's Already Configured

✅ **Complete Flutter app** with all features  
✅ **Professional UI** optimized for field technicians  
✅ **Offline-first architecture**  
✅ **Customer management, scheduling, reports**  
✅ **Digital signatures**  
✅ **iPhone 8+ compatibility**  
✅ **Codemagic build configuration**  
✅ **GitHub Actions workflow**  
✅ **iOS export settings**  

You just need to add your certificates and build! 🚀
