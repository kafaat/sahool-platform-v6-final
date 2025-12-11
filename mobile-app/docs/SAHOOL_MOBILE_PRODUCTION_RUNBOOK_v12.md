# SAHOOL Mobile v12 – Production Runbook

هذه الوثيقة موجهة لفرق التشغيل/الإصدار (Ops / Release) لإطلاق SAHOOL Mobile في بيئة إنتاج.

## 1. أنواع الـ Builds

- Debug: لأغراض التطوير والاختبارات الداخلية.
- Release: إصدار APK / AAB للإنتاج.

## 2. خطوات بناء إصدار Release

### 2.1 المتطلبات

- حساب Google Play (أو متجر بديل)
- Keystore موقّع + إعدادات `key.properties`
- Flutter مثبت على خادم الـ CI أو جهاز الإصدار

### 2.2 أوامر البناء

```bash
# من جذر مشروع الموبايل
flutter clean
flutter pub get

# بناء APK
flutter build apk --release

# أو بناء AppBundle لإرساله إلى Google Play
flutter build appbundle --release
```

أو باستخدام السكربت المضمّن:

```bash
# Linux / macOS / WSL
./scripts/sahool_mobile_dev.sh release

# Windows PowerShell
pwsh ./scripts/sahool_mobile_dev.ps1 -Mode release
```

## 3. ربط التطبيق ببيئة الإنتاج

- يتم ضبط عناوين الـ API عبر:
  - `lib/core/config/app_config.dart`
  - و/أو `lib/core/config/env_config.dart`

- تأكد أن:
  - `apiBaseUrl` يشير إلى بوابة `Kong` أو `gateway-edge` في الإنتاج.
  - مفاتيح OAuth2 / Tokens محدثة ومخزنة بأمان.

## 4. مراقبة واستقرارية التطبيق

- تفعيل Crashlytics / Sentry (بحسب ما يتم اعتماده).
- تفعيل Logging مناسب (بدون كشف بيانات حساسة).
- اعتماد سياسة إصدار مرحلي (Staged Rollout) لتقليل المخاطر.

## 5. خطة رجوع (Rollback Plan)

- الاحتفاظ على الأقل بآخر إصدارين مستقرين.
- في حالة مشاكل حرجة:
  - إيقاف نشر الإصدار الجديد.
  - تفعيل إعادة نشر الإصدار السابق.
  - فتح تذكرة Incident وربطها بسجلات Git و Logs.