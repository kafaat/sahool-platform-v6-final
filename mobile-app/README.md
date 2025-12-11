# 🌾 SAHOOL Mobile v11.0

**Smart Agricultural Hub for Operations & Optimization Lifecycle**

سهول - منصة الزراعة الذكية

## 📱 Features

### Core Features
- 🗺️ **Field Management** - إدارة الحقول الزراعية
- 📋 **Task Management** - إدارة المهام والأنشطة
- 🌤️ **Weather Monitoring** - متابعة أحوال الطقس
- 🤖 **AI Assistant** - مساعد ذكي مدعوم بالذكاء الاصطناعي
- 📊 **Analytics Dashboard** - لوحة تحليلات شاملة
- 🛰️ **NDVI Monitoring** - مراقبة مؤشر NDVI

### Technical Features
- ✅ Clean Architecture
- ✅ BLoC State Management
- ✅ Material Design 3
- ✅ RTL Arabic Support
- ✅ Dark Mode Support
- ✅ Offline First Design
- ✅ Professional UI/UX

## 🚀 Getting Started

### Prerequisites
- Flutter SDK >= 3.2.0
- Dart SDK >= 3.2.0

### Installation

```bash
# Clone the repository
git clone https://github.com/kafaat/sahool-mobile.git

# Navigate to project
cd sahool_mobile

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Build

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

## 📁 Project Structure

```
lib/
├── app/                    # App configuration
├── core/                   # Core utilities
│   ├── config/            # App configuration
│   ├── constants/         # Constants
│   ├── di/                # Dependency injection
│   ├── error/             # Error handling
│   ├── extensions/        # Dart extensions
│   ├── logging/           # Logging
│   ├── network/           # Network layer
│   ├── observers/         # BLoC observers
│   └── types/             # Type definitions
├── data/                   # Data layer
│   ├── datasources/       # Data sources
│   ├── models/            # Data models
│   └── repositories/      # Repository implementations
├── domain/                 # Domain layer
│   ├── entities/          # Business entities
│   ├── repositories/      # Repository contracts
│   └── usecases/          # Use cases
├── features/               # Feature modules
│   ├── auth/              # Authentication
│   ├── dashboard/         # Dashboard
│   ├── fields/            # Field management
│   ├── tasks/             # Task management
│   ├── weather/           # Weather
│   └── profile/           # User profile
└── presentation/           # Presentation layer
    ├── router/            # Navigation
    ├── theme/             # Theming
    └── widgets/           # Shared widgets
```

## 🎨 Design System

### Colors
- Primary: `#2E7D32` (Agricultural Green)
- Secondary: `#FFB300` (Golden Wheat)
- Success: `#4CAF50`
- Warning: `#FFA726`
- Error: `#EF5350`
- Info: `#42A5F5`

### Typography
- Font Family: Cairo (Arabic optimized)

## 📄 License

Copyright © 2024 SAHOOL. All rights reserved.
