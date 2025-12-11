# SAHOOL Mobile v12 – Development Guide

تاريخ التوليد: 2025-12-11T12:46:24.488855Z

هذه الوثيقة تلخص ما تم دمجه في هذا الإصدار وكيفية تشغيل المشروع في وضع التطوير.

## 1. نظرة عامة

- Field Suite v12 (رسم الحقول، Pivot، Free Draw، NDVI، Zones، Irrigation Layers، Notes، Tasks)
- NDVI Monitoring (Dashboard Summary + NDVI Map Page + Offline Cache)
- Livestock Analytics + Irrigation Management
- AI Assistant v2 (BLoC + Offline History + Suggestions)
- Offline Engine (SharedPreferences + OfflineHelper)
- تكامل مع Backend (OpenAPI 3.1.0 عبر EnvConfig + DioClient + Interceptors)
- Map System (MapLibre جاهز للدمج مع طبقات NDVI الحقيقية)
- Router متكامل (Dashboard، Fields، Field Suite، NDVI، AI، Livestock، Irrigation، Reports)
- سكربتات التطوير (Bash + PowerShell)

## 2. تشغيل المشروع في وضع التطوير

### 2.1 المتطلبات

- Flutter 3.16 أو أعلى
- Dart SDK متوافق
- Android SDK / Xcode (حسب المنصة)
- اتصال بالإنترنت للوصول إلى الـ backend / Kong عند اللزوم

### 2.2 الأوامر الأساسية

```bash
# من جذر المشروع
flutter pub get

# تشغيل مباشر على جهاز متصل
flutter run

# أو باستخدام السكربت المدمج (Linux / macOS / WSL)
./scripts/sahool_mobile_dev.sh debug

# على Windows (PowerShell)
pwsh ./scripts/sahool_mobile_dev.ps1 -Mode debug
```

## 3. أهم المسارات في lib/

- `lib/features/field_suite/` : كل ما يخص Field Suite
- `lib/features/ndvi/` : NDVI Monitoring (Bloc + Pages + Widgets)
- `lib/features/ai_assistant/` : مساعد سهول الذكي
- `lib/features/livestock/` : تحليلات المواشي
- `lib/features/irrigation/` : إدارة الري
- `lib/core/config/` : AppConfig + EnvConfig
- `lib/core/network/` : DioClient + Interceptors + ApiEndpoints
- `lib/core/offline/` : OfflineHelper
- `lib/presentation/router/` : Routes + AppRouter

## 4. نمط العمل المقترح للمطورين

1. تعديل أي Feature داخل مجلدها في `lib/features/...`
2. تشغيل التطبيق عبر السكربت أو `flutter run`
3. استخدام Backend حقيقي عبر تعديل `EnvConfig` أو `AppConfig`
4. استخدام OfflineHelper لتخزين بيانات تجريبية أثناء التطوير بدون اتصال ثابت

## 5. المزامنة مع Backend

- جميع الاستدعاءات HTTP تمر عبر `DioClient` المهيأ من `AppConfig` و `EnvConfig`.
- لدعم البيئات (dev/staging/prod) يتم ضبط `Environment` في التهيئة الأولى للتطبيق.