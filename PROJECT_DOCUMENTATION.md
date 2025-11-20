# توثيق شامل لمشروع ParkingTec - نظام إدارة مواقف السيارات

## جدول المحتويات

1. [نظرة عامة](#نظرة-عامة)
2. [البنية المعمارية](#البنية-المعمارية)
3. [هيكل المشروع](#هيكل-المشروع)
4. [الميزات (Features)](#الميزات-features)
5. [النماذج (Models)](#النماذج-models)
6. [نقاط النهاية (API Endpoints)](#نقاط-النهاية-api-endpoints)
7. [قواعد العمل (Business Logic)](#قواعد-العمل-business-logic)
8. [الشاشات (Screens)](#الشاشات-screens)
9. [إدارة الحالة (State Management)](#إدارة-الحالة-state-management)
10. [التوجيه (Routing)](#التوجيه-routing)
11. [سيناريوهات الاستخدام](#سيناريوهات-الاستخدام)
12. [قواعد التطوير](#قواعد-التطوير)

---

## نظرة عامة

**ParkingTec** هو تطبيق Flutter لإدارة مواقف السيارات، مصمم للحراس (Wardens) لإدارة عمليات اليومية (Daily Shifts) والفواتير (Invoices).

### الهدف الرئيسي

تطبيق موبايل لإدارة مواقف السيارات يتيح:

- إدارة نوبات العمل اليومية (Daily Shifts)
- إنشاء وإدارة فواتير ركن السيارات
- دعم نوعين من التسعير: ثابت (Fixed) أو بالساعة (Hourly)
- مسح QR Code للفواتير
- طباعة الفواتير
- إدارة الملف الشخصي

### التقنيات المستخدمة

- **Flutter**: إطار عمل التطبيق
- **Riverpod**: إدارة الحالة والاعتمادات (Dependency Injection)
- **Clean Architecture**: بنية معمارية نظيفة مع Feature-First Organization
- **GoRouter**: التوجيه والتنقل
- **Retrofit + Dio**: طلبات HTTP
- **Freezed**: إنشاء classes غير قابلة للتعديل و union types
- **Firebase**: الإشعارات (FCM)
- **SharedPreferences**: التخزين المحلي
- **Flutter Secure Storage**: تخزين آمن للتوكنات

---

## البنية المعمارية

### Clean Architecture Layers

المشروع يتبع **Clean Architecture** مع تنظيم **Feature-First**:

```
lib/
├── core/                          # الكود المشترك
│   ├── config/                    # إعدادات التطبيق
│   ├── constants/                 # ثوابت (API endpoints)
│   ├── di/                        # Dependency Injection
│   ├── errors/                    # معالجة الأخطاء
│   ├── network/                   # شبكة (interceptors)
│   ├── routing/                   # التوجيه
│   ├── services/                  # خدمات (API, FCM, Storage)
│   ├── storage/                   # التخزين
│   ├── theme/                     # الثيمات
│   ├── utils/                     # أدوات مساعدة
│   └── widgets/                   # ويدجتات قابلة لإعادة الاستخدام
│
└── features/                      # الميزات (منظمة حسب الميزة)
    ├── auth/                      # المصادقة
    ├── config/                    # إعدادات التطبيق
    ├── daily/                     # اليومية
    ├── home/                      # الصفحة الرئيسية
    ├── invoice/                   # الفواتير
    └── ...
```

### طبقات كل ميزة (Feature Layers)

كل ميزة تحتوي على 3 طبقات:

```
feature_name/
├── data/                          # طبقة البيانات
│   ├── datasources/               # مصادر البيانات (Remote/Local)
│   ├── models/                    # DTOs (Data Transfer Objects)
│   └── repositories/              # تنفيذ Repositories
│
├── domain/                        # طبقة المجال
│   ├── entities/                  # الكيانات (Business Objects)
│   ├── repositories/              # واجهات Repositories
│   └── usecases/                  # حالات الاستخدام (Business Logic)
│
└── presentation/                  # طبقة العرض
    ├── controllers/               # ViewModels (StateNotifier/AsyncNotifier)
    ├── pages/                     # الشاشات (ConsumerWidget)
    ├── states/                    # حالات (Freezed Union Types)
    ├── widgets/                   # ويدجتات خاصة بالميزة
    └── providers/                 # Riverpod Providers
```

### Dependency Rule

```
Presentation → Domain ← Data
```

- **Presentation** تعتمد على **Domain** فقط
- **Data** تعتمد على **Domain** فقط
- **Domain** لا تعتمد على أي شيء

---

## هيكل المشروع

### المجلدات الرئيسية

#### `lib/core/`

الكود المشترك بين جميع الميزات:

- **`config/`**: إعدادات التطبيق
- **`constants/`**: ثوابت (API endpoints)
- **`di/providers/`**: Riverpod providers للاعتمادات
- **`errors/`**: أنواع الأخطاء ومعالجتها
- **`network/`**: Interceptors للشبكة
- **`routing/`**: تعريفات المسارات
- **`services/`**: خدمات (API Service, FCM, Secure Storage)
- **`storage/`**: التخزين المحلي
- **`theme/`**: الثيمات (Light/Dark)
- **`utils/`**: أدوات مساعدة
- **`widgets/`**: ويدجتات قابلة لإعادة الاستخدام

#### `lib/features/`

الميزات منظمة حسب الوظيفة:

- **`auth/`**: المصادقة (Login, Logout, Profile)
- **`config/`**: إعدادات التطبيق من API
- **`daily/`**: إدارة اليومية (Start, Terminate)
- **`home/`**: الصفحة الرئيسية
- **`invoice/`**: إدارة الفواتير (Create, Complete, List, Details)
- **`printing/`**: طباعة الفواتير
- **`splash/`**: شاشة البداية

---

## الميزات (Features)

### 1. المصادقة (Authentication)

**المسار**: `lib/features/auth/`

#### الوظائف:

- تسجيل الدخول (Login)
- تسجيل الخروج (Logout)
- الحصول على الملف الشخصي (Get Profile)
- تحديث الملف الشخصي

#### الشاشات:

- `LoginPage`: شاشة تسجيل الدخول

#### Controllers:

- `AuthController`: يدير حالة المصادقة

#### States:

- `AuthState`: initial, loading, authenticated, error

#### API Endpoints:

- `POST /login`: تسجيل الدخول
- `POST /logout`: تسجيل الخروج
- `GET /profile`: الحصول على الملف الشخصي
- `POST /profile/update`: تحديث الملف الشخصي

---

### 2. اليومية (Daily Shifts)

**المسار**: `lib/features/daily/`

#### الوظائف:

- بدء يومية جديدة (Start Daily)
- إنهاء يومية (Terminate Daily)
- التحقق من وجود يومية نشطة

#### الشاشات:

- `StartDailyPage`: شاشة بدء اليومية
- `TerminateDailyPage`: شاشة إنهاء اليومية

#### Controllers:

- `DailyController`: يدير حالة اليومية

#### States:

- `DailyState`: initial, loading, loaded, error

#### API Endpoints:

- `POST /dailies/start`: بدء يومية
- `POST /dailies/terminate`: إنهاء يومية
- `GET /dailies/active`: التحقق من اليومية النشطة

#### قواعد العمل:

- يجب أن يكون المستخدم مسجل دخول
- لا يمكن بدء يومية جديدة إذا كانت هناك يومية نشطة
- عند إنهاء اليومية، يجب إدخال `end_balance` و `notes` (اختياري)

---

### 3. الفواتير (Invoices)

**المسار**: `lib/features/invoice/`

#### الوظائف:

- إنشاء فاتورة جديدة
- عرض قائمة الفواتير (All, Active, Pending)
- عرض تفاصيل فاتورة
- إكمال فاتورة (Complete Invoice)
- دفع فاتورة (Pay Invoice)
- مسح QR Code
- البحث في الفواتير

#### الشاشات:

- `InvoiceListPage`: قائمة الفواتير (مع Tabs)
- `InvoiceDetailsPage`: تفاصيل فاتورة
- `CreateInvoiceDialog`: حوار إنشاء فاتورة
- `CompleteInvoiceDialog`: حوار إكمال فاتورة

#### Controllers (منفصلة):

- `AllInvoicesController`: إدارة قائمة جميع الفواتير
- `ActiveInvoicesController`: إدارة قائمة الفواتير النشطة
- `PendingInvoicesController`: إدارة قائمة الفواتير قيد الإحضار
- `CreateInvoiceController`: إنشاء فواتير جديدة
- `InvoiceDetailsController`: تحميل تفاصيل فاتورة واحدة
- `CompleteInvoiceController`: إكمال الفواتير

#### States:

- `AllInvoicesState`: initial, loading, loaded, error
- `ActiveInvoicesState`: initial, loading, loaded, error
- `PendingInvoicesState`: initial, loading, loaded, error
- `CreateInvoiceState`: initial, loading, success, error
- `InvoiceDetailsState`: initial, loading, loaded, error
- `CompleteInvoiceState`: initial, loading, success, error

#### API Endpoints:

- `GET /invoices`: جميع الفواتير
- `GET /invoices/active`: الفواتير النشطة
- `GET /invoices/pending`: الفواتير قيد الإحضار
- `GET /invoices/{id}`: فاتورة محددة
- `POST /invoices/store`: إنشاء فاتورة
- `POST /invoices/complete`: إكمال فاتورة
- `POST /invoices/{id}/pay`: دفع فاتورة
- `POST /invoices/{id}/pickup`: استلام سيارة
- `GET /p/{id}`: مسح QR Code (public endpoint)

#### قواعد العمل:

- **Fixed Pricing**: سعر ثابت، يمكن الدفع عند الإنشاء
- **Hourly Pricing**: يحسب حسب الساعات، يتم الحساب عند الإكمال
- إذا كان `barcode_enabled = true`، يجب مسح QR Code لإكمال الفاتورة
- حساب الساعات: إذا بدأ في ساعة جديدة، تُحسب كساعة كاملة

---

### 4. إعدادات التطبيق (App Config)

**المسار**: `lib/features/config/`

#### الوظائف:

- جلب إعدادات التطبيق من API
- عرض الإعدادات في شاشة Settings

#### الشاشات:

- `ConfigPage`: شاشة الإعدادات

#### Controllers:

- `ConfigController`: يدير حالة الإعدادات

#### States:

- `ConfigState`: initial, loading, loaded, error

#### API Endpoints:

- `GET /app/config`: جلب الإعدادات

#### الإعدادات:

- `barcode_enabled`: تفعيل/تعطيل QR Code
- `show_prices`: إظهار/إخفاء الأسعار
- `pricing_type`: نوع التسعير (fixed/hourly)
- `default_fixed_price`: السعر الثابت الافتراضي
- `default_hourly_rate`: سعر الساعة الافتراضي
- `currency`: العملة
- `currency_symbol`: رمز العملة
- `system_name`: اسم النظام
- `logo`: شعار النظام

---

### 5. الصفحة الرئيسية (Home)

**المسار**: `lib/features/home/`

#### الوظائف:

- عرض معلومات اليومية
- عرض إحصائيات (Today Sales, Active Cars)
- أزرار سريعة للوصول للميزات

#### الشاشات:

- `HomePage`: الصفحة الرئيسية

#### Widgets:

- `CustomActionsAppBar`: شريط أعلى مخصص
- `CarAnimationWidget`: رسوم متحركة للسيارة
- `LotCard`: بطاقة موقف

---

## النماذج (Models)

### 1. User Model

**المسار**: `lib/features/auth/data/models/user.dart`

```dart
class User {
  final int id;
  final String? name;
  final String? phone;
  final String? email;
  final String? address;
  final String? picture;
  final String? pictureUrl;
  final String? todaySalesBalance;
  final String? totalActiveCars;
  final ActiveDaily? activeDaily;

  bool get hasActiveDaily => activeDaily != null && activeDaily!.isActive;
}
```

### 2. Daily Model

**المسار**: `lib/features/daily/data/models/daily.dart`

```dart
class Daily {
  final int? id;
  final int? wardenId;
  final int? userId;
  final String? startDate;
  final String? startTime;
  final String? endTime;
  final double? startBalance;
  final double? endBalance;
  final double? balance;
  final String? notes;
  final String? status;

  bool get isActive => status == 'active' && endTime == null;
  Duration get duration => ...;
}
```

### 3. Invoice Model

**المسار**: `lib/features/invoice/data/models/invoice.dart`

```dart
class Invoice {
  final int invoiceId;
  final String? customerName;
  final String carNum;
  final String? carModel;
  final String pricingType; // 'fixed' or 'hourly'
  final double? amount;
  final double? finalAmount;
  final double? hourlyRate;
  final double hours;
  final String startTime;
  final String? endTime;
  final int? startTimestamp;
  final int? endTimestamp;
  final double durationHours;
  final bool hasQrCode;
  final String? qrCode;
  final String status; // 'active' or 'completed'
  final String carStatus; // 'active', 'pending', 'complete'
  final String? statusLabel;
  final bool requested;
  final String? wardenName;
  final String? dailyDate;
  final String? documentUrl;

  // Helper getters
  bool get isCompleted => status == 'completed' || carStatus == 'complete';
  bool get isFixedPricing => pricingType == 'fixed';
  bool get isHourlyPricing => pricingType == 'hourly';
  bool get isActive => status == 'active';
  bool get isPending => carStatus == 'pending';
  bool get isPaid => isFixedPricing && (amount != null && amount! > 0);
  double? get displayAmount => finalAmount ?? amount;
  DateTime? get startDateTime => ...;
  DateTime? get endDateTime => ...;
}
```

### 4. AppConfig Model

**المسار**: `lib/features/config/data/models/app_config.dart`

```dart
class AppConfig {
  final bool barcodeEnabled;
  final bool showPrices;
  final String pricingType; // 'fixed' or 'hourly'
  final double? defaultFixedPrice;
  final double? defaultHourlyRate;
  final String? currency;
  final String? currencySymbol;
  final String? systemName;
  final String? logo;
}
```

---

## نقاط النهاية (API Endpoints)

### Base URL

```
https://parking.alwafierp.com/api
```

### Authentication Endpoints

| Method | Endpoint          | Description             | Auth Required |
| ------ | ----------------- | ----------------------- | ------------- |
| POST   | `/login`          | تسجيل الدخول            | ❌            |
| POST   | `/logout`         | تسجيل الخروج            | ✅            |
| GET    | `/profile`        | الحصول على الملف الشخصي | ✅            |
| POST   | `/profile/update` | تحديث الملف الشخصي      | ✅            |

### Daily Endpoints

| Method | Endpoint             | Description              | Auth Required |
| ------ | -------------------- | ------------------------ | ------------- |
| POST   | `/dailies/start`     | بدء يومية                | ✅            |
| POST   | `/dailies/terminate` | إنهاء يومية              | ✅            |
| GET    | `/dailies/active`    | التحقق من اليومية النشطة | ✅            |

### Invoice Endpoints

| Method | Endpoint                | Description          | Auth Required |
| ------ | ----------------------- | -------------------- | ------------- |
| GET    | `/invoices`             | جميع الفواتير        | ✅            |
| GET    | `/invoices/active`      | الفواتير النشطة      | ✅            |
| GET    | `/invoices/pending`     | الفواتير قيد الإحضار | ✅            |
| GET    | `/invoices/{id}`        | فاتورة محددة         | ✅            |
| POST   | `/invoices/store`       | إنشاء فاتورة         | ✅            |
| POST   | `/invoices/complete`    | إكمال فاتورة         | ✅            |
| POST   | `/invoices/{id}/pay`    | دفع فاتورة           | ✅            |
| POST   | `/invoices/{id}/pickup` | استلام سيارة         | ✅            |
| GET    | `/p/{id}`               | مسح QR Code (public) | ❌            |

### Config Endpoints

| Method | Endpoint      | Description     | Auth Required |
| ------ | ------------- | --------------- | ------------- |
| GET    | `/app/config` | إعدادات التطبيق | ✅            |

### Request Headers

جميع الطلبات المطلوبة للمصادقة تحتاج:

```
Authorization: Bearer <TOKEN>
Content-Type: application/json
Accept: application/json
```

### Response Format

جميع الاستجابات تستخدم الصيغة:

```json
{
  "data": {...},
  "message": "..."
}
```

---

## قواعد العمل (Business Logic)

### 1. اليومية (Daily Shifts)

#### بدء اليومية:

- يجب أن يكون المستخدم مسجل دخول
- لا يمكن بدء يومية جديدة إذا كانت هناك يومية نشطة
- `start_balance`: الرصيد الابتدائي (مطلوب)
- `notes`: ملاحظات (اختياري)

#### إنهاء اليومية:

- يجب أن تكون هناك يومية نشطة
- `end_balance`: الرصيد النهائي (مطلوب)
- `notes`: ملاحظات (اختياري)
- عند إنهاء اليومية، يتم تحديث `balance` تلقائياً

### 2. الفواتير (Invoices)

#### إنشاء فاتورة:

- `car_num`: رقم السيارة (مطلوب)
- `customer_name`: اسم العميل (اختياري)
- `car_model`: موديل السيارة (اختياري)
- `amount`: المبلغ (للفواتير الثابتة فقط، اختياري)

#### Fixed Pricing (ثابت):

- إذا تم إرسال `amount`، يجب أن يساوي `default_fixed_price`
- إذا لم يتم إرسال `amount` أو كان `0`، تُسجل الفاتورة بمبلغ `0` حتى يتم الدفع لاحقاً
- يمكن الدفع عند الإنشاء أو لاحقاً

#### Hourly Pricing (بالساعة):

- لا حاجة لإرسال `amount`
- يتم حساب المبلغ تلقائياً عند الإكمال: `hourly_rate × hours`
- `amount` يبقى `0` حتى يتم إنهاء الفاتورة

#### إكمال فاتورة:

- للفواتير بالساعة: يجب إدخال `amount` (يمكن تعديله)
- للفواتير الثابتة: يتم استخدام `amount` المحدد عند الإنشاء
- إذا كان `barcode_enabled = true` و `has_qr_code = true`، يجب مسح QR Code أولاً

#### حساب الساعات:

- يتم حساب المدة بالدقائق ثم تحويلها لساعات
- **قاعدة مهمة**: إذا بدأ في ساعة جديدة، تُحسب كساعة كاملة
  - مثال: إذا بدأ في 10:01، تُحسب كساعة واحدة (1.0)
- حد أدنى: 0.25 ساعة (15 دقيقة)
- الصيغة: `ceil(hours)` (تقريب لأعلى)

#### حالات الفاتورة:

- **`status`**: `"active"` (نشطة) أو `"completed"` (مكتملة)
- **`car_status`**:
  - `"active"`: السيارة موجودة في الموقف
  - `"pending"`: تم طلب إحضار السيارة
  - `"complete"`: تم استلام السيارة

### 3. QR Code

- يتم إنشاء QR Code تلقائياً عند إنشاء الفاتورة إذا كان `barcode_enabled = true`
- يحتوي QR Code على رابط: `https://your-domain.com/p/{invoice_id}`
- يمكن مسح QR Code للوصول لتفاصيل الفاتورة (public endpoint)
- لإكمال فاتورة بها QR Code، يجب مسحه أولاً للتحقق

### 4. تحديث الرصيد

يتم تحديث رصيد اليومية النشطة تلقائياً عند:

- دفع فاتورة ثابتة
- إنهاء فاتورة بالساعة
- استلام سيارة (pickup)

---

## الشاشات (Screens)

### 1. Splash Screen

**المسار**: `lib/features/splash/presentation/pages/splash_page.dart`

- شاشة البداية
- التحقق من حالة تسجيل الدخول
- التوجيه للصفحة المناسبة

### 2. Login Page

**المسار**: `lib/features/auth/presentation/pages/login_page.dart`

- تسجيل الدخول بالهاتف وكلمة المرور
- التحقق من صحة البيانات
- حفظ التوكن بعد تسجيل الدخول

### 3. Home Page

**المسار**: `lib/features/home/presentation/pages/home_page.dart`

- عرض معلومات اليومية
- عرض إحصائيات (Today Sales, Active Cars)
- أزرار سريعة:
  - Start Daily Session
  - End Daily Session
  - Create Invoice
  - Invoices List
  - Settings
  - Logout

### 4. Start Daily Page

**المسار**: `lib/features/daily/presentation/pages/start_daily_page.dart`

- إدخال `start_balance`
- إدخال `notes` (اختياري)
- رسوم متحركة للسيارة
- زر "Start Session"

### 5. Terminate Daily Page

**المسار**: `lib/features/daily/presentation/pages/terminate_daily_page.dart`

- إدخال `end_balance`
- إدخال `notes` (اختياري)
- رسوم متحركة للسيارة
- زر "Terminate Session"

### 6. Invoice List Page

**المسار**: `lib/features/invoice/presentation/pages/invoice_list_page.dart`

- Tabs: All, Active, Pending
- شريط بحث (بحث محلي في الفواتير المحملة)
- قائمة/شبكة الفواتير (responsive للتابلت)
- زر Floating Action Button لإنشاء فاتورة
- زر QR Scanner في AppBar

### 7. Invoice Details Page

**المسار**: `lib/features/invoice/presentation/pages/invoice_details_page.dart`

- عرض تفاصيل الفاتورة:
  - Header (Invoice ID, Status)
  - Timer (للفواتير بالساعة النشطة)
  - Payment Status (للفواتير الثابتة النشطة)
  - Car Details
  - Amount Information (إذا كان `show_prices = true`)
  - QR Code (إذا كان متوفراً)
  - Actions (Complete, Pay, Pickup)

### 8. Config Page

**المسار**: `lib/features/config/presentation/pages/config_page.dart`

- عرض إعدادات التطبيق:
  - Currency
  - Pricing Type
  - Fixed Price / Hourly Rate
  - Barcode Enabled
  - Show Prices
  - System Name
  - Logo

---

## إدارة الحالة (State Management)

### Riverpod

المشروع يستخدم **Riverpod** لإدارة الحالة والاعتمادات.

### Controllers (ViewModels)

كل Controller هو `StateNotifier` أو `AsyncNotifier`:

```dart
class InvoiceController extends StateNotifier<InvoiceState> {
  final Ref ref;

  InvoiceController(this.ref) : super(const InvoiceState.initial());

  Future<void> loadInvoices() async {
    state = const InvoiceState.loading();
    // ... load data
    state = InvoiceState.loaded(invoices);
  }
}
```

### States (Freezed Union Types)

جميع States تستخدم **Freezed** union types:

```dart
@freezed
class InvoiceState with _$InvoiceState {
  const factory InvoiceState.initial() = _Initial;
  const factory InvoiceState.loading() = _Loading;
  const factory InvoiceState.loaded({
    required List<Invoice> invoices,
  }) = _Loaded;
  const factory InvoiceState.error({
    required Failure failure,
  }) = _Error;
}
```

### Providers

```dart
final invoiceControllerProvider =
  StateNotifierProvider<InvoiceController, InvoiceState>(
    (ref) => InvoiceController(ref),
  );
```

### Usage in UI

```dart
class InvoiceListPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(invoiceControllerProvider);

    return state.when(
      initial: () => ...,
      loading: () => ...,
      loaded: (invoices) => ...,
      error: (failure) => ...,
    );
  }
}
```

### Cross-Controller Communication

عند إنشاء فاتورة، يتم تحديث قوائم الفواتير:

```dart
// In CreateInvoiceController
result.fold(
  (failure) => ...,
  (invoice) {
    _safeSetState(CreateInvoiceState.success(invoice: invoice));
    // Refresh list controllers
    Future.delayed(const Duration(milliseconds: 100), () {
      ref.read(allInvoicesControllerProvider.notifier).loadAllInvoices();
      ref.read(activeInvoicesControllerProvider.notifier).loadActiveInvoices();
    });
  },
);
```

---

## التوجيه (Routing)

### GoRouter

المشروع يستخدم **GoRouter** للتوجيه.

### Routes Class

جميع المسارات معرفة في `lib/core/routing/routes.dart`:

```dart
class Routes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String home = '/';
  static const String invoices = '/invoices';
  static const String config = '/config';

  // Helper methods
  static String invoiceDetails(int id) => '/invoices/$id';
  static String lotDetails(String id) => '/lot/$id';
}
```

### Navigation

```dart
// Push
context.push(Routes.invoiceDetails(123));

// Go (replace)
context.go(Routes.home);

// Pop
context.pop();
```

---

## سيناريوهات الاستخدام

### سيناريو 1: بدء يومية وإنشاء فاتورة

1. المستخدم يسجل دخول
2. يضغط "Start Daily Session"
3. يدخل `start_balance` و `notes` (اختياري)
4. يضغط "Start Session"
5. يتم إنشاء اليومية، يتم التوجيه للصفحة الرئيسية
6. يضغط "Create Invoice"
7. يدخل بيانات السيارة (`car_num` مطلوب، `customer_name` و `car_model` اختياري)
8. إذا كان Fixed Pricing، يدخل `amount`
9. يضغط "Create"
10. يتم إنشاء الفاتورة، يتم إغلاق الحوار

### سيناريو 2: إكمال فاتورة بالساعة

1. المستخدم يفتح قائمة الفواتير
2. يضغط على فاتورة نشطة (Hourly)
3. يضغط "Complete Invoice"
4. إذا كان `barcode_enabled = true` و `has_qr_code = true`:
   - يتم فتح QR Scanner
   - يمسح QR Code
   - يتم التحقق من أن QR Code يطابق الفاتورة
5. يتم فتح حوار "Complete Invoice"
6. يتم حساب المبلغ تلقائياً (يمكن تعديله)
7. يضغط "Confirm"
8. يتم إكمال الفاتورة، يتم تحديث القوائم

### سيناريو 3: إنهاء يومية

1. المستخدم يضغط "End Daily Session" في الصفحة الرئيسية
2. يتم فتح حوار "Terminate Daily"
3. يدخل `end_balance` و `notes` (اختياري)
4. يضغط "Confirm"
5. يتم إنهاء اليومية، يتم التوجيه لصفحة "Start Daily"

### سيناريو 4: البحث في الفواتير

1. المستخدم يفتح قائمة الفواتير
2. يكتب في شريط البحث (رقم السيارة، اسم العميل، أو الموديل)
3. يتم البحث محلياً في الفواتير المحملة (لا يوجد API call)
4. يتم عرض النتائج المفلترة

---

## قواعد التطوير

### 1. Clean Architecture

- **Domain Layer**: لا تعتمد على أي شيء
- **Data Layer**: تعتمد على Domain فقط
- **Presentation Layer**: تعتمد على Domain فقط

### 2. Feature-First Organization

- كل ميزة في مجلد منفصل
- كل ميزة تحتوي على جميع الطبقات (Data, Domain, Presentation)
- الكود المشترك في `core/`

### 3. State Management

- استخدام **Riverpod** فقط
- Controllers هي `StateNotifier` أو `AsyncNotifier`
- States هي Freezed union types
- استخدام `ref.watch` للقراءة
- استخدام `ref.read` للإجراءات
- استخدام `ref.listen` للآثار الجانبية (navigation, snackbars)

### 4. Error Handling

- استخدام `Either<Failure, Success>` (Dartz) في Domain
- Mapping exceptions إلى Failures في Data Layer
- عرض رسائل خطأ واضحة للمستخدم

### 5. Localization

- جميع النصوص في `lib/l10n/intl_ar.arb` و `lib/l10n/intl_en.arb`
- استخدام `S.of(context)` للوصول للنصوص
- لا توجد نصوص hardcoded

### 6. Code Generation

- استخدام `build_runner` لتوليد الكود:
  ```bash
  dart run build_runner build --delete-conflicting-outputs
  ```
- **لا تقم بتعديل الملفات `.g.dart` يدوياً**

### 7. Testing

- Unit tests للـ Use Cases
- Widget tests للشاشات
- Integration tests للتدفق الكامل

### 8. Naming Conventions

- **Files**: `snake_case.dart`
- **Classes**: `PascalCase`
- **Variables/Functions**: `camelCase`
- **Constants**: `UPPER_SNAKE_CASE`

### 9. Code Quality

- استخدام `flutter_lints`
- Functions صغيرة ومحددة (~20 statement)
- SOLID principles
- Null-safety دائماً

### 10. Git Workflow

- **production**: فرع الإصدار (يوزع لـ Firebase App Distribution)
- **main**: فرع التكامل
- **feature/**: فروع الميزات

---

## ملاحظات مهمة

### 1. API Response Structure

جميع استجابات API تستخدم الصيغة:

```json
{
  "data": {...},
  "message": "..."
}
```

### 2. Authentication

- التوكن يُحفظ في `SecureStorage`
- يتم إضافة التوكن تلقائياً لجميع الطلبات عبر Interceptor
- عند 401 Unauthorized، يتم مسح التوكن والتوجيه للصفحة الرئيسية

### 3. Invoice Calculation

- **Fixed**: `final_amount = amount`
- **Hourly**: `final_amount = hourly_rate × hours` (بعد الإكمال)
- حساب الساعات: `ceil(hours)` (تقريب لأعلى)

### 4. QR Code

- يتم إنشاء QR Code تلقائياً إذا كان `barcode_enabled = true`
- QR Code يحتوي على SVG string (ليس نص عادي)
- استخدام `flutter_svg` لعرض SVG QR Codes

### 5. Responsive Design

- استخدام `flutter_screenutil` للتصميم المتجاوب
- `LayoutBuilder` للتحقق من حجم الشاشة (tablet/mobile)
- GridView للتابلت، ListView للموبايل

---

## الخلاصة

هذا المشروع هو تطبيق Flutter لإدارة مواقف السيارات يستخدم:

- **Clean Architecture** مع **Feature-First Organization**
- **Riverpod** لإدارة الحالة
- **GoRouter** للتوجيه
- **Retrofit + Dio** للشبكة
- **Freezed** للـ States
- **Firebase** للإشعارات

جميع الميزات منظمة بشكل مستقل، مع كود مشترك في `core/`. كل ميزة تحتوي على 3 طبقات (Data, Domain, Presentation) مع فصل واضح للمسؤوليات.

---

**آخر تحديث**: 2025-01-18
