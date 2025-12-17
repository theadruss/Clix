# Firebase Setup Script for CampusConnect
# Run this script to configure Firebase for your project

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Firebase Setup for CampusConnect" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Check if Firebase CLI is installed
Write-Host "Step 1: Checking FlutterFire CLI..." -ForegroundColor Yellow
try {
    flutterfire --version | Out-Null
    Write-Host "✓ FlutterFire CLI is installed" -ForegroundColor Green
} catch {
    Write-Host "✗ FlutterFire CLI not found. Installing..." -ForegroundColor Red
    dart pub global activate flutterfire_cli
    Write-Host "✓ FlutterFire CLI installed" -ForegroundColor Green
}

Write-Host ""

# Step 2: Login to Firebase
Write-Host "Step 2: Firebase Login" -ForegroundColor Yellow
Write-Host "You need to login to Firebase. This will open your browser." -ForegroundColor White
$login = Read-Host "Have you logged in to Firebase? (y/n)"
if ($login -ne "y") {
    Write-Host "Running: firebase login" -ForegroundColor Cyan
    firebase login
}

Write-Host ""

# Step 3: Configure Firebase
Write-Host "Step 3: Configuring Firebase for Flutter" -ForegroundColor Yellow
Write-Host "This will:" -ForegroundColor White
Write-Host "  - Show you a list of Firebase projects" -ForegroundColor White
Write-Host "  - Let you select or create a project" -ForegroundColor White
Write-Host "  - Configure Firebase for your platforms" -ForegroundColor White
Write-Host "  - Generate firebase_options.dart automatically" -ForegroundColor White
Write-Host ""
$ready = Read-Host "Ready to configure Firebase? (y/n)"
if ($ready -eq "y") {
    Write-Host "Running: flutterfire configure" -ForegroundColor Cyan
    flutterfire configure
    Write-Host ""
    Write-Host "✓ Firebase configuration complete!" -ForegroundColor Green
} else {
    Write-Host "You can run 'flutterfire configure' manually later." -ForegroundColor Yellow
}

Write-Host ""

# Step 4: Instructions for Firebase Console
Write-Host "Step 4: Firebase Console Setup" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "IMPORTANT: You need to complete these steps in Firebase Console:" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. Enable Authentication:" -ForegroundColor White
Write-Host "   - Go to: https://console.firebase.google.com/" -ForegroundColor Cyan
Write-Host "   - Select your project" -ForegroundColor Cyan
Write-Host "   - Click 'Authentication' → 'Get started'" -ForegroundColor Cyan
Write-Host "   - Go to 'Sign-in method' tab" -ForegroundColor Cyan
Write-Host "   - Enable 'Email/Password'" -ForegroundColor Cyan
Write-Host ""
Write-Host "2. Create Firestore Database:" -ForegroundColor White
Write-Host "   - Click 'Firestore Database' → 'Create database'" -ForegroundColor Cyan
Write-Host "   - Choose 'Start in test mode'" -ForegroundColor Cyan
Write-Host "   - Select a location" -ForegroundColor Cyan
Write-Host "   - Click 'Enable'" -ForegroundColor Cyan
Write-Host ""
Write-Host "3. Set Security Rules:" -ForegroundColor White
Write-Host "   - In Firestore, go to 'Rules' tab" -ForegroundColor Cyan
Write-Host "   - Copy rules from setup_firebase.md" -ForegroundColor Cyan
Write-Host "   - Click 'Publish'" -ForegroundColor Cyan
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Setup Complete!" -ForegroundColor Green
Write-Host "After completing Firebase Console setup, run: flutter run" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan

