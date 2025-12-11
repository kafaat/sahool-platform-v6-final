# SAHOOL Field Suite Mobile v12 – Unified Specification (Summary)

> هذا الملف عبارة عن نسخة ملخّصة / عملية من وثيقة Field Suite Mobile التي بنيناها في المحادثة، مهيأة للاستخدام داخل الريبو.

## 1. الهدف

* إدارة الحقول ورسم حدودها (Polygon / Pivot Circle / Free Draw).
* عرض طبقات NDVI والـ Zones ودمجها مع خريطة الأساس.
* ربط أدوات الري والمواشي والمهام اليومية في تدفق واحد حول الحقل.
* دعم Online + Offline مع مزامنة لاحقة.

## 2. الوحدات داخل الموبايل

* `features/field_suite`  
  * صفحة `FieldSuitePage` مع:
    * MapLibre
    * Drawing Toolbar
    * Pivot Auto‑Detect
    * Free‑draw
    * Snap‑to‑grid / Snap‑to‑line
* `features/ndvi`
  * `NdviBloc` + `NdviMapPage` + `NdviReportPage`
  * NDVI View Modes: `auto`, `ndviTiles`, `baseMap`
* `features/irrigation`
  * `IrrigationManagementPage` + `IrrigationAddPage` + BLoC
* `features/livestock`
  * `LivestockAnalyticsPage` + BLoC + Charts
* `features/ai_assistant`
  * `AiAssistantPage` + `AiAssistantBloc` + Offline history

## 3. تكامل NDVI

* مصدر البلاط (Tiles) في `NdviMapPage`:

```dart
final ndviUrl =
    'https://tiles.sahool.example/fields/demo/ndvi/${state.selected!.id}/tiles/{{z}}/{{x}}/{{y}}.png';
```

يمكن تعديل هذا لاحقاً ليتصل بـ gateway الحقيقي (Kong → geo-core / imagery-core).

* منطق اختيار وضع العرض:

```dart
enum NdviViewMode { auto, ndviTiles, baseMap }
```

* في وضع `auto`:
  * إذا كانت نسبة الغيوم > 50% → نستخدم `baseMap`.
  * غير ذلك → نستخدم طبقة NDVI.

## 4. Offline First

* `OfflineHelper` في `core/offline/offline_helper.dart`:
  * يخزن:
    * رسائل المساعد الذكي.
    * مشاهد NDVI (تجريبية أو من الـ backend).
* يمكن استبدال `_generateFakeScenes()` في `NdviBloc` بنداء حقيقي للـ API لاحقاً.

## 5. ربط المزايا مع Dashboard

* ملخص NDVI في `dashboard_page.dart`:
  * يستخدم `NdviSummaryCard`.
  * يفتح `NdviMapPage` عند الضغط.
* كارت AI Insights يفتح `AiAssistantPage`.

## 6. نقاط تطوير مستقبلية (Next Steps)

* ربط NDVI الحقيقي مع geo‑core / imagery‑core عبر Kong.
* إضافة طبقات:
  * Soil Fertility Tiles
  * Weather Overlay
  * Water Stress
* ربط FieldSuite مباشرة مع:
  * IrrigationManagementPage
  * LivestockAnalyticsPage
* إضافة تقارير PDF من الموبايل (NDVI Report / Field Report).

> هذه الوثيقة ملخّص تنفيذي – يمكن توسيعها لاحقاً بوضع نفس النص الكامل من المحادثة إن رغبت.
