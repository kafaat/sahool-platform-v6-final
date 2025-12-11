#!/usr/bin/env bash
set -euo pipefail

MODE="${1:-debug}"

echo "======================================"
echo " SAHOOL Mobile v11.1 - Dev Helper"
echo " Mode: ${MODE}"
echo "======================================"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${SCRIPT_DIR}/.."

if ! command -v flutter >/dev/null 2>&1; then
  echo "❌ Flutter غير مثبت أو غير موجود في PATH"
  exit 1
fi

case "${MODE}" in
  clean)
    echo "🧹 تنظيف المشروع..."
    flutter clean
    flutter pub get
    ;;
  debug)
    echo "📦 تثبيت الاعتماديات..."
    flutter pub get
    echo "🚀 تشغيل التطبيق (Debug)..."
    flutter run
    ;;
  release)
    echo "📦 تثبيت الاعتماديات..."
    flutter pub get
    echo "🏗️ بناء APK (Release)..."
    flutter build apk --release
    echo "✅ APK جاهز في: build/app/outputs/flutter-apk/app-release.apk"
    ;;
  ios)
    echo "📦 تثبيت الاعتماديات..."
    flutter pub get
    echo "🍎 بناء iOS (Release)..."
    flutter build ios --release
    ;;
  test)
    echo "🧪 تشغيل الاختبارات..."
    flutter test
    ;;
  *)
    echo "Usage: $0 {debug|release|clean|test|ios}"
    exit 1
    ;;
esac

echo ""
echo "✅ انتهى التنفيذ بنجاح!"
