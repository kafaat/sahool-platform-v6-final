# 🌾 Sahool Platform v6.8.1 FINAL CORRECTED

**نظام إدارة المزارع الذكي المتكامل - الإصدار النهائي المصحح**

هذا المستودع يحتوي على البنية المصححة والنهائية لمنصة Sahool الزراعية، والتي تعالج جميع المشاكل الحرجة في الإصدارات السابقة.

## 🚀 الميزات الرئيسية

- **Microservices Architecture:** 12 خدمة مصغرة قائمة على FastAPI/Python.
- **Geospatial:** خدمات متقدمة لإدارة الحقول والبيانات الجغرافية.
- **AI Integration:** خدمة Agent-Service متكاملة لتقديم النصائح.
- **Imagery & Weather:** خدمات لمعالجة صور الأقمار الصناعية وبيانات الطقس.
- **Deployment:** ملفات Docker Compose جاهزة للتشغيل.
- **Frontend:** واجهة ويب حديثة مبنية بـ Next.js.
- **Mobile:** تطبيق موبايل مبني بـ Flutter.

## 🛠️ البنية التقنية

| المكون | التقنية | الوصف |
|---|---|---|
| **Backend** | Python, FastAPI | 12 Microservices |
| **Frontend** | Next.js, React | واجهة الويب الرئيسية |
| **Mobile** | Flutter | تطبيق الموبايل |
| **Database** | PostgreSQL | قاعدة البيانات الرئيسية |
| **Storage** | MinIO (S3 Compatible) | تخزين الصور والبيانات |
| **Deployment** | Docker, Docker Compose | بيئة التطوير والإنتاج |

## 📦 البدء السريع

### 1. المتطلبات

- Docker
- Docker Compose (أو docker compose plugin)
- Git
- Node.js (لتشغيل Frontend)
- Flutter (لتشغيل Mobile App)

### 2. التشغيل

استخدم سكريبت البناء الموحد لتشغيل جميع الخدمات:

```bash
# تأكد من أنك في المجلد الرئيسي للمشروع
./build_sahool_v6_8_1_final_corrected.sh
# أو
./setup.sh
```

### 3. التشغيل اليدوي (Docker)

```bash
cd deploy/docker
docker-compose up --build -d
```

### 4. الوصول

- **Frontend:** http://localhost:3000
- **API Gateway:** http://localhost:8001 (Auth Service)
- **MinIO Console:** http://localhost:9001 (User: minio_user, Pass: minio_pass)

## 📄 التوثيق

- **ARCHITECTURE.md:** تفاصيل البنية
- **DEVELOPMENT.md:** دليل المطورين
- **DEPLOYMENT.md:** دليل النشر على Kubernetes

## 📞 الدعم

للمساعدة أو الإبلاغ عن مشاكل:
- GitHub Issues: [https://github.com/kafaat/sahool-platform-v6-final/issues](https://github.com/kafaat/sahool-platform-v6-final/issues)
- Email: support@sahool.com

## 📄 الترخيص

MIT License
