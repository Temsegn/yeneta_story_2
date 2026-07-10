@echo off
echo ========================================
echo Kids Learning App - Quick Start
echo ========================================
echo.

echo Checking Flutter installation...
flutter doctor
echo.

echo Installing dependencies...
flutter pub get
echo.

echo Checking for connected devices...
flutter devices
echo.

echo Starting the app...
echo Press Ctrl+C to stop
echo.
flutter run
