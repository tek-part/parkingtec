# توثيق شامل لـ API الفواتير (Invoices API)

## جدول المحتويات
1. [نظرة عامة](#نظرة-عامة)
2. [إنشاء فاتورة جديدة](#1-إنشاء-فاتورة-جديدة)
3. [الحصول على فاتورة بالمعرف](#2-الحصول-على-فاتورة-بالمعرف)
4. [إنهاء فاتورة](#3-إنهاء-فاتورة-complete)
5. [استلام السيارة](#4-استلام-السيارة-pickup)
6. [دفع فاتورة](#5-دفع-فاتورة-pay)
7. [الفواتير النشطة](#6-الفواتير-النشطة-active)
8. [الفواتير قيد الإحضار](#7-الفواتير-قيد-الإحضار-pending)
9. [قائمة الفواتير](#8-قائمة-الفواتير-list-all)
10. [مسح الفاتورة](#9-مسح-الفاتورة-scan)
11. [طلب السيارة](#10-طلب-السيارة-request-car)
12. [هيكل الاستجابة](#invoiceresource---هيكل-الاستجابة)
13. [الملاحظات المهمة](#ملاحظات-مهمة)

---

## نظرة عامة

نظام الفواتير يدعم نوعين من التسعير:
- **Fixed (ثابت)**: سعر واحد للفاتورة
- **Hourly (بالساعة)**: السعر يحسب حسب عدد الساعات

### المصادقة
- معظم المسارات تتطلب مصادقة عبر `apiAuth` middleware
- استخدام Bearer Token في header: `Authorization: Bearer <TOKEN>`

### الاستجابة القياسية
جميع الاستجابات تستخدم الصيغة التالية:
```json
{
  "data": {...},
  "message": "..."
}
```

---

## 1. إنشاء فاتورة جديدة

### Endpoint
```
POST /api/invoices/store
```

### المصادقة
✅ مطلوبة (`apiAuth` middleware)

### Request Headers
```
Authorization: Bearer <TOKEN>
Content-Type: application/json
Accept: application/json
```

### Request Body
```json
{
  "customer_name": "أحمد محمد",      // اختياري
  "car_num": "123 أ ب ج",            // مطلوب
  "car_model": "مرسيدس",             // اختياري
  "amount": 50.00                     // اختياري (للفواتير الثابتة فقط)
}
```

### Validation Rules
- `customer_name`: `nullable|string|max:255`
- `car_num`: `required|string|max:255`
- `car_model`: `nullable|string|max:255`
- `amount`: `nullable|numeric|min:0`

### Business Logic

#### Fixed Pricing (ثابت):
- إذا تم إرسال `amount`، يجب أن يساوي `default_fixed_price` من الإعدادات تماماً
- إذا لم يتم إرسال `amount` أو كان `0`، يتم تسجيل الفاتورة بمبلغ `0` حتى يتم الدفع لاحقاً
- يتم تحديث رصيد اليومية تلقائياً إذا تم الدفع عند الإنشاء

#### Hourly Pricing (بالساعة):
- لا حاجة لإرسال `amount`
- يتم حساب المبلغ تلقائياً عند الاستلام (سعر الساعة × عدد الساعات)
- `amount` يبقى `0` حتى يتم إنهاء الفاتورة

### التحقق من التكرار
- يتحقق من عدم وجود فاتورة نشطة لنفس رقم السيارة
- الفاتورة النشطة: `end_time = null` و `car_status != 'complete'`

### إنشاء QR Code
- يتم إنشاء QR Code تلقائياً إذا كان `barcode_enabled = true` في الإعدادات
- يحتوي QR Code على رابط: `https://your-domain.com/p/{invoice_id}`

### Response (Success - 200)
```json
{
  "data": {
    "invoice_id": 1,
    "customer_name": "أحمد محمد",
    "car_num": "123 أ ب ج",
    "car_model": "مرسيدس",
    "pricing_type": "fixed",
    "amount": 50.00,
    "final_amount": 50.00,
    "hourly_rate": null,
    "hours": 0,
    "start_time": "2024-01-01T10:00:00.000000Z",
    "end_time": null,
    "start_timestamp": 1704106800000,
    "end_timestamp": null,
    "duration_hours": 0,
    "has_qr_code": true,
    "qr_code": "<svg>...</svg>",
    "status": "active",
    "car_status": "active",
    "status_label": "نشطة",
    "requested": false,
    "warden_name": "حارس الموقف",
    "daily_date": "2024-01-01T08:00:00.000000Z"
  },
  "message": "تم انشاء الفاتورة بنجاح"
}
```

### Response (Error - 422)
```json
{
  "data": null,
  "message": "السيارة رقم 123 أ ب ج موجودة بالفعل في فاتورة نشطة مع الحارس (أحمد). يرجى إنهاء الفاتورة السابقة أولاً."
}
```

### Response (Error - 422) - مبلغ غير صحيح
```json
{
  "data": null,
  "message": "المبلغ المدفوع عند الدخول يجب أن يساوي 50.00 دينار"
}
```

---

## 2. الحصول على فاتورة بالمعرف

### Endpoint
```
GET /api/invoices/{invoice}
```

### المصادقة
✅ مطلوبة (`apiAuth`)

### Route Parameters
- `invoice`: رقم الفاتورة (integer)

### Request Headers
```
Authorization: Bearer <TOKEN>
Accept: application/json
```

### Response (Success - 200)
```json
{
  "data": {
    "invoice_id": 1,
    "customer_name": "أحمد محمد",
    "car_num": "123 أ ب ج",
    "car_model": "مرسيدس",
    "pricing_type": "fixed",
    "amount": 50.00,
    "final_amount": 50.00,
    "hourly_rate": null,
    "hours": 0,
    "start_time": "2024-01-01T10:00:00.000000Z",
    "end_time": null,
    "start_timestamp": 1704106800000,
    "end_timestamp": null,
    "duration_hours": 0,
    "has_qr_code": true,
    "qr_code": "<svg>...</svg>",
    "status": "active",
    "car_status": "active",
    "status_label": "نشطة",
    "requested": false,
    "warden_name": "حارس الموقف",
    "daily_date": "2024-01-01T08:00:00.000000Z",
    "document_url": "http://example.com/uploads/invoices/invoice_1.pdf"
  },
  "message": "تم جلب تفاصيل الفاتورة بنجاح"
}
```

### Response (Error - 404)
```json
{
  "data": null,
  "message": "الفاتورة غير موجودة"
}
```

---

## 3. إنهاء فاتورة (Complete)

### Endpoint
```
POST /api/invoices/complete
```

### المصادقة
✅ مطلوبة (`apiAuth`)

### Request Headers
```
Authorization: Bearer <TOKEN>
Content-Type: application/json
Accept: application/json
```

### Request Body
```json
{
  "invoice_id": 1,                    // مطلوب
  "amount": 200.00                     // اختياري (مطلوب للفواتير الثابتة غير المدفوعة أو بالساعة)
}
```

### Validation Rules
- `invoice_id`: `required|integer|exists:invoices,id`
- `amount`: `nullable|numeric|min:0`

### Business Logic

#### Hourly Pricing:
1. يتم حساب المبلغ تلقائياً: `hourly_rate × hours`
2. يجب إرسال `amount` ومطابقته للمبلغ المحسوب (هامش خطأ: 0.1)
3. يتم تحديث رصيد اليومية تلقائياً
4. يتم تعيين `is_paid = true`

#### Fixed Pricing:
1. إذا كانت الفاتورة مدفوعة مسبقاً (`amount > 0`): لا حاجة لإرسال `amount`
2. إذا كانت غير مدفوعة (`amount = 0`): يجب إرسال `amount` ومطابقته لـ `default_fixed_price`
3. يتم تحديث رصيد اليومية تلقائياً

### حساب الساعات
- يتم حساب المدة بالدقائق ثم تحويلها لساعات
- الصيغة: `round(minutes / 60, 2)`
- يتم تسجيل `hours` في قاعدة البيانات

### إنشاء PDF
- يتم إنشاء ملف PDF تلقائياً بعد الإنهاء
- المسار: `uploads/invoices/invoice_{id}_completed_{timestamp}.pdf`
- يتم حفظ المسار في `document` field

### تحديث الحالة
- `end_time`: يتم تعيينه للوقت الحالي
- `car_status`: يتم تغييره إلى `"complete"`
- `is_paid`: يتم تعيينه إلى `true`

### Response (Success - 200)
```json
{
  "data": {
    "invoice_id": 1,
    "customer_name": "أحمد محمد",
    "car_num": "123 أ ب ج",
    "pricing_type": "hourly",
    "amount": 200.00,
    "final_amount": 200.00,
    "hourly_rate": 100.00,
    "hours": 2.0,
    "start_time": "2024-01-01T10:00:00.000000Z",
    "end_time": "2024-01-01T12:00:00.000000Z",
    "duration_hours": 2.0,
    "status": "completed",
    "car_status": "complete",
    "status_label": "مكتملة",
    "document_url": "http://example.com/uploads/invoices/invoice_1_completed_1234567890.pdf"
  },
  "message": "تم إنهاء الفاتورة وحساب المبلغ بنجاح"
}
```

### Response (Error - 422) - فاتورة مكتملة مسبقاً
```json
{
  "data": null,
  "message": "تم إنهاء هذه الفاتورة مسبقاً"
}
```

### Response (Error - 422) - مبلغ غير صحيح (Hourly)
```json
{
  "data": null,
  "message": "المبلغ المطلوب: 200.00 دينار - المبلغ المدخل: 150.00 دينار - يرجى إدخال المبلغ الصحيح"
}
```

### Response (Error - 422) - مبلغ غير صحيح (Fixed)
```json
{
  "data": null,
  "message": "المبلغ المطلوب: 50.00 دينار - المبلغ المدخل: 40.00 دينار - يرجى إدخال المبلغ الصحيح"
}
```

---

## 4. استلام السيارة (Pickup)

### Endpoint
```
POST /api/invoices/{invoice}/pickup
```

### المصادقة
✅ مطلوبة (`apiAuth`)

### Route Parameters
- `invoice`: رقم الفاتورة (integer)

### Request Headers
```
Authorization: Bearer <TOKEN>
Accept: application/json
```

### Request Body
لا يوجد (فارغ)

### Business Logic

#### التحقق من الدفع (Fixed):
- إذا كانت الفاتورة ثابتة وغير مدفوعة (`amount = 0`): يتم رفض الاستلام
- يجب دفع المبلغ أولاً عبر `/api/invoices/{invoice}/pay`

#### حساب المبلغ (Hourly):
- يتم حساب المبلغ تلقائياً: `hourly_rate × hours`
- يتم تحديث `amount` في الفاتورة
- يتم تحديث رصيد اليومية تلقائياً

#### إنشاء PDF:
- يتم إنشاء ملف PDF تلقائياً
- المسار: `uploads/invoices/invoice_{id}_pickup_{timestamp}.pdf`

#### تحديث الحالة:
- `end_time`: يتم تعيينه للوقت الحالي
- `hours`: يتم حسابها وحفظها
- `car_status`: يبقى `"active"` (لا يتغير إلى `"complete"`)

### Response (Success - 200)
```json
{
  "data": {
    "invoice_id": 1,
    "customer_name": "أحمد محمد",
    "car_num": "123 أ ب ج",
    "pricing_type": "hourly",
    "amount": 200.00,
    "final_amount": 200.00,
    "hourly_rate": 100.00,
    "hours": 2.0,
    "start_time": "2024-01-01T10:00:00.000000Z",
    "end_time": "2024-01-01T12:00:00.000000Z",
    "duration_hours": 2.0,
    "has_qr_code": true,
    "qr_code": "<svg>...</svg>",
    "status": "completed",
    "car_status": "complete",
    "document_url": "http://example.com/uploads/invoices/invoice_1_pickup_1234567890.pdf"
  },
  "message": "تم استلام السيارة بنجاح - يمكنك الآن مسح QR Code أو تحميل PDF"
}
```

### Response (Error - 422) - فاتورة مكتملة مسبقاً
```json
{
  "data": null,
  "message": "تم إنهاء هذه الفاتورة مسبقاً"
}
```

### Response (Error - 422) - يجب الدفع أولاً
```json
{
  "data": null,
  "message": "يجب دفع المبلغ المطلوب: 50.00 دينار قبل استلام السيارة"
}
```

---

## 5. دفع فاتورة (Pay)

### Endpoint
```
POST /api/invoices/{invoice}/pay
```

### المصادقة
✅ مطلوبة (`apiAuth`)

### Route Parameters
- `invoice`: رقم الفاتورة (integer)

### Request Headers
```
Authorization: Bearer <TOKEN>
Content-Type: application/json
Accept: application/json
```

### Request Body
```json
{
  "amount": 50.00                     // مطلوب
}
```

### Validation Rules
- `amount`: `required|numeric|min:0`

### Business Logic

#### التحقق من نوع الفاتورة:
- فقط الفواتير الثابتة (`pricing_type = "fixed"`) يمكن دفعها
- الفواتير بالساعة لا يمكن دفعها قبل الاستلام

#### التحقق من المبلغ:
- يجب أن يساوي `amount` لـ `default_fixed_price` من الإعدادات تماماً
- لا يوجد هامش خطأ

#### تحديث الرصيد:
- يتم تحديث رصيد اليومية النشطة تلقائياً
- يتم تحديث `amount` في الفاتورة

### Response (Success - 200)
```json
{
  "data": {
    "invoice": {
      "id": 1,
      "customer_name": "أحمد محمد",
      "car_num": "123 أ ب ج",
      "amount": 50.00,
      "pricing_type": "fixed"
    },
    "paid_amount": 50.00,
    "status": "paid"
  },
  "message": "تم دفع المبلغ بنجاح"
}
```

### Response (Error - 422) - نوع فاتورة غير صحيح
```json
{
  "data": null,
  "message": "لا يمكن دفع هذه الفاتورة قبل الاستلام - يتم الدفع حسب الساعات"
}
```

### Response (Error - 422) - فاتورة مدفوعة مسبقاً
```json
{
  "data": null,
  "message": "تم دفع هذه الفاتورة مسبقاً"
}
```

### Response (Error - 422) - مبلغ غير صحيح
```json
{
  "data": null,
  "message": "المبلغ المطلوب: 50.00 دينار - المبلغ المدخل: 40.00 دينار - يرجى إدخال المبلغ الصحيح"
}
```

---

## 6. الفواتير النشطة (Active)

### Endpoint
```
GET /api/invoices/active
```

### المصادقة
✅ مطلوبة (`apiAuth`)

### Request Headers
```
Authorization: Bearer <TOKEN>
Accept: application/json
```

### Query Parameters
لا يوجد

### Business Logic
- يتم جلب جميع فواتير الحارس الحالي
- الشرط: `warden_id = current_user` و `car_status = 'active'`
- يتم ترتيبها حسب `id` تنازلياً
- Pagination: 50 عنصر لكل صفحة

### Response (Success - 200)
```json
{
  "data": [
    {
      "invoice_id": 1,
      "customer_name": "أحمد محمد",
      "car_num": "123 أ ب ج",
      "pricing_type": "hourly",
      "hourly_rate": 100.00,
      "start_time": "2024-01-01T10:00:00.000000Z",
      "status": "active",
      "car_status": "active",
      "status_label": "نشطة"
    },
    {
      "invoice_id": 2,
      "customer_name": "سارة أحمد",
      "car_num": "456 د ه و",
      "pricing_type": "fixed",
      "amount": 50.00,
      "status": "active",
      "car_status": "active"
    }
  ],
  "message": "تم جلب الفواتير النشطة بنجاح"
}
```

---

## 7. الفواتير قيد الإحضار (Pending)

### Endpoint
```
GET /api/invoices/pending
```

### المصادقة
✅ مطلوبة (`apiAuth`)

### Request Headers
```
Authorization: Bearer <TOKEN>
Accept: application/json
```

### Query Parameters
لا يوجد

### Business Logic
- يتم جلب جميع فواتير الحارس الحالي
- الشرط: `warden_id = current_user` و `car_status = 'pending'`
- يتم ترتيبها حسب `id` تنازلياً
- Pagination: 50 عنصر لكل صفحة

### Response (Success - 200)
```json
{
  "data": [
    {
      "invoice_id": 1,
      "customer_name": "أحمد محمد",
      "car_num": "123 أ ب ج",
      "car_status": "pending",
      "status_label": "قيد الإحضار",
      "requested": true
    }
  ],
  "message": "تم جلب الفواتير قيد الإحضار بنجاح"
}
```

---

## 8. قائمة الفواتير (List All)

### Endpoint
```
GET /api/invoices
```

### المصادقة
✅ مطلوبة (`apiAuth`)

### Request Headers
```
Authorization: Bearer <TOKEN>
Accept: application/json
```

### Query Parameters
- `car_num` (اختياري): البحث الجزئي في أرقام السيارات

### Examples
```
GET /api/invoices
GET /api/invoices?car_num=123
GET /api/invoices?car_num=أ ب
```

### Business Logic
- يتم جلب جميع فواتير الحارس الحالي
- إذا تم إرسال `car_num`: يتم البحث الجزئي (LIKE) في أرقام السيارات
- يتم ترتيبها حسب `id` تنازلياً
- Pagination: 50 عنصر لكل صفحة

### Response (Success - 200)
```json
{
  "data": [
    {
      "invoice_id": 1,
      "customer_name": "أحمد محمد",
      "car_num": "123 أ ب ج",
      "status": "completed",
      "car_status": "complete"
    },
    {
      "invoice_id": 2,
      "customer_name": "سارة أحمد",
      "car_num": "456 د ه و",
      "status": "active",
      "car_status": "active"
    }
  ],
  "message": "تم جلب الفواتير بنجاح"
}
```

---

## 9. مسح الفاتورة (Scan)

### Endpoint
```
GET /api/invoices/scan/{invoice}    (مع مصادقة)
GET /p/{invoice}                     (بدون مصادقة - عام)
```

### المصادقة
- `/api/invoices/scan/{invoice}`: ✅ مطلوبة
- `/p/{invoice}`: ❌ غير مطلوبة (عام)

### Route Parameters
- `invoice`: رقم الفاتورة (integer)

### Request Headers
```
Authorization: Bearer <TOKEN>  (فقط للـ API)
Accept: application/json       (للحصول على JSON)
```

### Query Parameters
- `json=1`: للحصول على استجابة JSON (للـ public route)

### Response Format
- إذا كان `Accept: application/json` أو `?json=1`: JSON
- وإلا: HTML view (صفحة عامة)

### Response (Success - 200) - JSON
```json
{
  "data": {
    "invoice_id": 1,
    "customer_name": "أحمد محمد",
    "car_num": "123 أ ب ج",
    "pricing_type": "fixed",
    "amount": 50.00,
    "status": "completed",
    "has_qr_code": true,
    "qr_code": "<svg>...</svg>",
    "document_url": "http://example.com/uploads/invoices/invoice_1.pdf"
  },
  "message": "تم مسح الفاتورة بنجاح"
}
```

### Response (Success - 200) - HTML
يعرض صفحة HTML عامة مع تفاصيل الفاتورة وإمكانية طلب السيارة.

### Response (Error - 404)
```json
{
  "data": null,
  "message": "الفاتورة غير موجودة"
}
```

---

## 10. طلب السيارة (Request Car)

### Endpoint
```
POST /p/{invoice}/request  (Public - بدون مصادقة)
```

### المصادقة
❌ غير مطلوبة (عام)

### Route Parameters
- `invoice`: رقم الفاتورة (integer)

### Request Headers
```
Content-Type: application/json
Accept: application/json
```

### Request Body
لا يوجد (فارغ)

### Business Logic
1. يتم التحقق من عدم وجود طلب سابق (منع التكرار)
2. يتم إنشاء إشعار للحارس المسؤول
3. يتم إرسال إشعار FCM للحرساء
4. يتم تغيير `car_status` إلى `"pending"`

### Response (Success - 200)
```json
{
  "data": {
    "invoice_id": 1,
    "status": "requested"
  },
  "message": "تم إرسال طلب السيارة"
}
```

### Response (Success - 200) - طلب مسبق
```json
{
  "data": {
    "invoice_id": 1,
    "status": "requested"
  },
  "message": "تم إرسال طلب السيارة مسبقًا"
}
```

### Response (Error - 404)
```json
{
  "data": null,
  "message": "الفاتورة غير موجودة"
}
```

---

## InvoiceResource - هيكل الاستجابة

جميع استجابات API الفواتير تستخدم `InvoiceResource` لتنسيق البيانات.

### الحقول الأساسية

| الحقل | النوع | الوصف |
|------|------|-------|
| `invoice_id` | integer | رقم الفاتورة |
| `customer_name` | string\|null | اسم العميل |
| `car_num` | string | رقم السيارة |
| `car_model` | string\|null | موديل السيارة |
| `pricing_type` | string | نوع التسعير: `"fixed"` أو `"hourly"` |
| `amount` | float\|null | المبلغ (يعتمد على `show_prices`) |
| `final_amount` | float\|null | المبلغ النهائي (يعتمد على `show_prices`) |
| `hourly_rate` | float\|null | سعر الساعة (يعتمد على `show_prices`) |
| `hours` | float | عدد الساعات |
| `start_time` | datetime | وقت البداية |
| `end_time` | datetime\|null | وقت النهاية |
| `start_timestamp` | integer\|null | وقت البداية (بالميلي ثانية) |
| `end_timestamp` | integer\|null | وقت النهاية (بالميلي ثانية) |
| `duration_hours` | float | المدة بالساعات |
| `has_qr_code` | boolean | هل يوجد QR Code |
| `status` | string | حالة الفاتورة: `"active"` أو `"completed"` |
| `car_status` | string | حالة السيارة: `"active"` أو `"pending"` أو `"complete"` |
| `status_label` | string | تسمية الحالة بالعربية |
| `requested` | boolean | هل تم طلب السيارة |
| `warden_name` | string | اسم الحارس |
| `daily_date` | datetime\|null | تاريخ اليومية |

### الحقول المشروطة

#### QR Code
```json
{
  "qr_code": "<svg>...</svg>"  // موجود فقط إذا كان has_qr_code = true
}
```

#### Document URL
```json
{
  "document_url": "http://example.com/uploads/invoices/invoice_1.pdf"  // موجود فقط إذا كان document موجود
}
```

### إخفاء الأسعار
إذا كان `show_prices = false` في إعدادات النظام:
- `amount` → `null`
- `final_amount` → `null`
- `hourly_rate` → `null`

---

## ملاحظات مهمة

### 1. حساب المدة
- يتم حساب المدة بالدقائق ثم تحويلها لساعات
- الصيغة: `round(minutes / 60, 2)`
- حد أدنى: 0.25 ساعة (15 دقيقة)
- للفواتير النشطة بالساعة: `duration_hours = 0` حتى يتم إنهاؤها

### 2. حساب المبلغ النهائي
- **Fixed**: `final_amount = amount`
- **Hourly**: `final_amount = hourly_rate × duration_hours` (بعد الإنهاء)

### 3. حالات الفواتير

#### `status` (حالة الفاتورة):
- `"active"`: فاتورة نشطة (لم يتم إنهاؤها)
- `"completed"`: فاتورة مكتملة (تم إنهاؤها)

#### `car_status` (حالة السيارة):
- `"active"`: السيارة موجودة في الموقف
- `"pending"`: تم طلب إحضار السيارة
- `"complete"`: تم استلام السيارة

### 4. Pagination
جميع قوائم الفواتير تستخدم pagination بـ **50 عنصر لكل صفحة**.

### 5. العلاقات
- `warden`: الحارس المسؤول عن الفاتورة
- `daily`: اليومية المرتبطة بالفاتورة

### 6. تحديث الرصيد
- يتم تحديث رصيد اليومية النشطة تلقائياً عند:
  - دفع فاتورة ثابتة
  - إنهاء فاتورة بالساعة
  - استلام سيارة (pickup)

### 7. إنشاء PDF
- يتم إنشاء PDF تلقائياً عند:
  - إنهاء الفاتورة (`complete`)
  - استلام السيارة (`pickup`)
- المسار: `uploads/invoices/invoice_{id}_{action}_{timestamp}.pdf`

### 8. QR Code
- يتم إنشاء QR Code تلقائياً عند إنشاء الفاتورة إذا كان `barcode_enabled = true`
- يحتوي على رابط: `https://your-domain.com/p/{invoice_id}`
- يمكن للعميل مسحه لرؤية تفاصيل الفاتورة وطلب السيارة

### 9. منع التكرار
- لا يمكن إنشاء فاتورة جديدة لسيارة موجودة في فاتورة نشطة
- الفاتورة النشطة: `end_time = null` و `car_status != 'complete'`

### 10. أكواد الاستجابة
- **200**: نجح الطلب
- **401**: غير مصرح (مشكلة في المصادقة)
- **404**: الفاتورة غير موجودة
- **422**: خطأ في التحقق من البيانات أو في Business Logic
- **500**: خطأ في الخادم

---

## أمثلة على الاستخدام

### مثال 1: إنشاء فاتورة ثابتة مدفوعة
```bash
curl -X POST "https://api.example.com/api/invoices/store" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "customer_name": "أحمد محمد",
    "car_num": "123 أ ب ج",
    "car_model": "مرسيدس",
    "amount": 50.00
  }'
```

### مثال 2: إنشاء فاتورة بالساعة
```bash
curl -X POST "https://api.example.com/api/invoices/store" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "customer_name": "سارة أحمد",
    "car_num": "456 د ه و",
    "car_model": "تويوتا"
  }'
```

### مثال 3: إنهاء فاتورة بالساعة
```bash
curl -X POST "https://api.example.com/api/invoices/complete" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "invoice_id": 1,
    "amount": 200.00
  }'
```

### مثال 4: دفع فاتورة ثابتة
```bash
curl -X POST "https://api.example.com/api/invoices/1/pay" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "amount": 50.00
  }'
```

### مثال 5: جلب الفواتير النشطة
```bash
curl -X GET "https://api.example.com/api/invoices/active" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Accept: application/json"
```

### مثال 6: البحث في الفواتير
```bash
curl -X GET "https://api.example.com/api/invoices?car_num=123" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Accept: application/json"
```

---

## خاتمة

هذا التوثيق يغطي جميع APIs الخاصة بالفواتير في النظام. إذا كان لديك أي أسئلة أو تحتاج إلى توضيحات إضافية، يرجى الرجوع إلى الكود المصدري أو التواصل مع فريق التطوير.

**آخر تحديث**: 2024

