param(
  [ValidateSet("debug", "release", "clean", "test")]
  [string]$Mode = "debug"
)

Write-Host "======================================" -ForegroundColor Green
Write-Host " SAHOOL Mobile v11.1 - Dev Helper"    -ForegroundColor Green
Write-Host " Mode: $Mode"                         -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Green

# انتقل لمجلد السكربت ثم لمجلد المشروع
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location $scriptDir/..

if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
  Write-Error "Flutter غير مثبت أو غير مضاف إلى PATH."
  exit 1
}

switch ($Mode) {
  "clean" {
    Write-Host "🧹 تنظيف المشروع..."
    flutter clean
    flutter pub get
  }
  "debug" {
    Write-Host "📦 تثبيت الاعتماديات..."
    flutter pub get
    Write-Host "🚀 تشغيل التطبيق (Debug)..."
    flutter run
  }
  "release" {
    Write-Host "📦 تثبيت الاعتماديات..."
    flutter pub get
    Write-Host "🏗️ بناء APK (Release)..."
    flutter build apk --release
    Write-Host "✅ APK جاهز في: build/app/outputs/flutter-apk/app-release.apk"
  }
  "test" {
    Write-Host "🧪 تشغيل الاختبارات..."
    flutter test
  }
}

Write-Host ""
Write-Host "✅ انتهى التنفيذ بنجاح!" -ForegroundColor Green
