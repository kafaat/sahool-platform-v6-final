# SAHOOL Mobile – Full Stack TODO

هذه القائمة تساعد الفريق على متابعة حالة المميزات في نسخة v12 Hybrid Auto NDVI Fullstack.

## ✅ تم تنفيذه في هذه النسخة

- Field Suite (Polygon / Pivot / Free Draw + Snap).
- NDVI Monitoring:
  - Bloc + Offline scenes.
  - NDVI Map + Auto / NDVI / BaseMap modes.
  - NDVI Report (Line + Bar charts).
- Livestock Analytics (Pie + Bar charts).
- Irrigation Management (دورات ري + إحصاءات).
- AI Assistant:
  - محادثة ثنائية الاتجاه.
  - Suggestions جاهزة.
  - Offline history عبر SharedPreferences.
- Offline Helper (AI + NDVI).
- سكربتات dev/build:
  - `scripts/sahool_mobile_dev.ps1`
  - `scripts/sahool_mobile_dev.sh`

## 🔜 المقترح للنسخ القادمة

- ربط فعلي مع OpenAPI 3.1 (platform-core) للمسارات:
  - `/api/v1/fields`
  - `/api/v1/ndvi/...` (عند توفرها).
- طبقات خريطة إضافية:
  - Soil / Weather / Water‑Stress Tiles.
- Field Workflow كامل:
  - Field → NDVI → Irrigation → Livestock → Tasks → Reports.
- Flutter integration tests لتدفق الحقل الكامل.
