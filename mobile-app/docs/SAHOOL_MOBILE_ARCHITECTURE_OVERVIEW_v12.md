# SAHOOL Mobile v12 – Architecture Overview

هذه الوثيقة تلخص الصورة المعمارية لتطبيق SAHOOL Mobile بعد الدمج الكامل لجميع الوحدات.

## 1. طبقات المعمارية

- Presentation Layer
  - Flutter Widgets + Pages + Routing (GoRouter)
  - Field Suite UI / NDVI Map / Dashboards / AI Assistant
- State Management
  - BLoC / Cubit للوحدات الرئيسية (Fields, NDVI, Livestock, Irrigation, AI)
- Domain
  - Entities + Use Cases (حيث يلزم)
- Data
  - Repositories + Remote DataSources + Local/Offline DataSources
- Core
  - Config (AppConfig / EnvConfig)
  - Network (DioClient + Interceptors + ApiEndpoints)
  - Offline (OfflineHelper)
  - DI (GetIt Service Locator)

## 2. أهم الوحدات المدمجة

- Field Suite
  - أدوات رسم الحدود (Polygon / Pivot / FreeDraw)
  - طبقات NDVI + Zones + Irrigation
  - Offline Cache للحقول والحدود
- NDVI Monitoring
  - ملخص في Dashboard
  - شاشة NDVI Map مع اختيار التاريخ
  - تخزين مشاهد NDVI Offline
- Livestock & Irrigation
  - تحليلات المواشي
  - إدارة دورات الري
- AI Assistant
  - محادثة ذكية مع المستخدم
  - تخزين رسائل Offline
- Offline Engine
  - SharedPreferences كطبقة تخزين خفيفة
- Integration
  - الاتصال بـ Backend عبر OpenAPI 3.1.0
  - جميع الاستدعاءات تمر عبر DioClient مع Interceptors للأمان والتوثيق

## 3. التوسعة المستقبلية

- إضافة Telemetry (OpenTelemetry) وربط التطبيق بـ observability stack.
- إضافة وحدة تقارير PDF أكثر تقدمًا.
- إضافة دعم Multi-tenant UI واضح (التبديل بين المزارع/المؤسسات).
- دعم Widgets مخصصة للأجهزة اللوحية (Tablet Optimized Layouts).