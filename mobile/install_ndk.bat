@echo off
echo ========================================
echo Installing Android NDK 27.0.12077973
echo ========================================
echo.

set SDK_PATH=%LOCALAPPDATA%\Android\Sdk
set SDKMANAGER=%SDK_PATH%\cmdline-tools\latest\bin\sdkmanager.bat

if not exist "%SDKMANAGER%" (
    echo ERROR: Android SDK command-line tools not found!
    echo.
    echo Please install Android SDK Command-line Tools:
    echo 1. Open Android Studio
    echo 2. Go to: Tools ^> SDK Manager
    echo 3. Click: SDK Tools tab
    echo 4. Check: Android SDK Command-line Tools
    echo 5. Click: Apply
    echo.
    echo Or download from: https://developer.android.com/studio#command-tools
    pause
    exit /b 1
)

echo Found SDK Manager at: %SDKMANAGER%
echo.
echo Installing NDK 27.0.12077973...
echo This may take a few minutes...
echo.

"%SDKMANAGER%" "ndk;27.0.12077973"

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo NDK installed successfully!
    echo ========================================
    echo.
    echo Now run: flutter clean ^&^& flutter run
) else (
    echo.
    echo ========================================
    echo Installation failed!
    echo ========================================
    echo.
    echo Please install NDK manually:
    echo 1. Open Android Studio
    echo 2. Tools ^> SDK Manager ^> SDK Tools
    echo 3. Check "Show Package Details"
    echo 4. Find "NDK (Side by side)"
    echo 5. Check version 27.0.12077973
    echo 6. Click Apply
)

pause
