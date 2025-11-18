// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ar locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ar';

  static String m0(amount) => "سيتم إنهاء الجلسة اليومية برصيد ${amount}";

  static String m1(error) => "فشل تسجيل الدخول: ${error}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "active": MessageLookupByLibrary.simpleMessage("نشطة"),
    "activeInvoices": MessageLookupByLibrary.simpleMessage("الفواتير النشطة"),
    "additionalOptions": MessageLookupByLibrary.simpleMessage("خيارات إضافية"),
    "allInvoices": MessageLookupByLibrary.simpleMessage("جميع الفواتير"),
    "amount": MessageLookupByLibrary.simpleMessage("المبلغ"),
    "amountMismatch": MessageLookupByLibrary.simpleMessage(
      "المبلغ المدخل لا يطابق المبلغ المطلوب",
    ),
    "amountRequired": MessageLookupByLibrary.simpleMessage("المبلغ مطلوب"),
    "appConfig": MessageLookupByLibrary.simpleMessage("إعدادات التطبيق"),
    "appSubtitle": MessageLookupByLibrary.simpleMessage("حلول الإيقاف الذكية"),
    "appTitle": MessageLookupByLibrary.simpleMessage("الوافي باركن"),
    "areYouSureLogout": MessageLookupByLibrary.simpleMessage(
      "هل أنت متأكد من تسجيل الخروج؟",
    ),
    "areYouSureYouWantToLogout": MessageLookupByLibrary.simpleMessage(
      "هل أنت متأكد من أنك تريد تسجيل الخروج؟",
    ),
    "areYouSureYouWantToTerminateTheDaily":
        MessageLookupByLibrary.simpleMessage(
          "هل أنت متأكد من أنك تريد إنهاء اليومية؟",
        ),
    "barcodeEnabled": MessageLookupByLibrary.simpleMessage("تفعيل الباركود"),
    "cancel": MessageLookupByLibrary.simpleMessage("إلغاء"),
    "carColor": MessageLookupByLibrary.simpleMessage("لون السيارة"),
    "carModel": MessageLookupByLibrary.simpleMessage("موديل السيارة"),
    "carNumber": MessageLookupByLibrary.simpleMessage("رقم السيارة"),
    "carRequested": MessageLookupByLibrary.simpleMessage("تم طلب السيارة"),
    "clear": MessageLookupByLibrary.simpleMessage("مسح"),
    "clearHistory": MessageLookupByLibrary.simpleMessage("مسح التاريخ"),
    "clearHistoryConfirmation": MessageLookupByLibrary.simpleMessage(
      "هل أنت متأكد من أنك تريد مسح جميع الفواتير؟",
    ),
    "clearSearch": MessageLookupByLibrary.simpleMessage("مسح البحث"),
    "completeInvoice": MessageLookupByLibrary.simpleMessage("إكمال الفاتورة"),
    "completed": MessageLookupByLibrary.simpleMessage("مكتملة"),
    "configError": MessageLookupByLibrary.simpleMessage(
      "حدث خطأ في تحميل الإعدادات",
    ),
    "configLoading": MessageLookupByLibrary.simpleMessage(
      "جاري تحميل الإعدادات...",
    ),
    "confirm": MessageLookupByLibrary.simpleMessage("تأكيد"),
    "confirmEndSession": MessageLookupByLibrary.simpleMessage(
      "تأكيد إنهاء الجلسة",
    ),
    "confirmLogout": MessageLookupByLibrary.simpleMessage("تأكيد تسجيل الخروج"),
    "create": MessageLookupByLibrary.simpleMessage("إنشاء"),
    "createInvoice": MessageLookupByLibrary.simpleMessage("إنشاء فاتورة"),
    "currency": MessageLookupByLibrary.simpleMessage("جنيه"),
    "currencySymbol": MessageLookupByLibrary.simpleMessage("رمز العملة"),
    "currentAmount": MessageLookupByLibrary.simpleMessage("المبلغ الحالي"),
    "customerName": MessageLookupByLibrary.simpleMessage("اسم العميل"),
    "dailyAlreadyOpen": MessageLookupByLibrary.simpleMessage(
      "هناك يومية مفتوحة بالفعل",
    ),
    "dailyStartedSuccess": MessageLookupByLibrary.simpleMessage(
      "تم بدء اليومية بنجاح",
    ),
    "dailyTerminatedSuccess": MessageLookupByLibrary.simpleMessage(
      "تم إنهاء اليومية بنجاح",
    ),
    "date": MessageLookupByLibrary.simpleMessage("التاريخ"),
    "defaultFixedPrice": MessageLookupByLibrary.simpleMessage(
      "السعر الثابت الافتراضي",
    ),
    "defaultHourlyRate": MessageLookupByLibrary.simpleMessage(
      "سعر الساعة الافتراضي",
    ),
    "disabled": MessageLookupByLibrary.simpleMessage("معطل"),
    "done": MessageLookupByLibrary.simpleMessage("تم"),
    "duration": MessageLookupByLibrary.simpleMessage("المدة"),
    "enabled": MessageLookupByLibrary.simpleMessage("مفعل"),
    "endBalance": MessageLookupByLibrary.simpleMessage("رصيد النهاية"),
    "endBalanceDescription": MessageLookupByLibrary.simpleMessage(
      "أدخل الرصيد النهائي لعملياتك اليومية",
    ),
    "endBalanceRequired": MessageLookupByLibrary.simpleMessage(
      "رصيد النهاية مطلوب",
    ),
    "endInvoice": MessageLookupByLibrary.simpleMessage("إنهاء الفاتورة"),
    "endSession": MessageLookupByLibrary.simpleMessage("إنهاء الجلسة"),
    "endSessionConfirmationMessage": m0,
    "endSessionDialogTitle": MessageLookupByLibrary.simpleMessage(
      "إنهاء الجلسة اليومية",
    ),
    "endSessionSuccess": MessageLookupByLibrary.simpleMessage(
      "تم إنهاء الجلسة بنجاح",
    ),
    "endTime": MessageLookupByLibrary.simpleMessage("وقت النهاية"),
    "endYourDailyShift": MessageLookupByLibrary.simpleMessage(
      "إنهاء ورديتك اليومية",
    ),
    "endingSession": MessageLookupByLibrary.simpleMessage(
      "جاري إنهاء الجلسة النشطة...",
    ),
    "enterAnyNotes": MessageLookupByLibrary.simpleMessage("أدخل أي ملاحظات..."),
    "enterCarNumber": MessageLookupByLibrary.simpleMessage("أدخل رقم السيارة"),
    "enterEndBalance": MessageLookupByLibrary.simpleMessage(
      "أدخل الرصيد النهائي",
    ),
    "enterNotes": MessageLookupByLibrary.simpleMessage(
      "أدخل ملاحظات (اختياري)",
    ),
    "error": MessageLookupByLibrary.simpleMessage("خطأ"),
    "errorTerminatingDaily": MessageLookupByLibrary.simpleMessage(
      "خطأ في إنهاء الوردية",
    ),
    "fieldRequired": MessageLookupByLibrary.simpleMessage("هذا الحقل مطلوب"),
    "finalAmount": MessageLookupByLibrary.simpleMessage("المبلغ النهائي"),
    "findParking": MessageLookupByLibrary.simpleMessage("البحث عن موقف"),
    "fixedPricing": MessageLookupByLibrary.simpleMessage("ثابت"),
    "history": MessageLookupByLibrary.simpleMessage("التاريخ"),
    "historyCleared": MessageLookupByLibrary.simpleMessage("تم مسح التاريخ"),
    "hourlyPricing": MessageLookupByLibrary.simpleMessage("بالساعة"),
    "hourlyRate": MessageLookupByLibrary.simpleMessage("سعر الساعة"),
    "hours": MessageLookupByLibrary.simpleMessage("ساعات"),
    "invalidAmount": MessageLookupByLibrary.simpleMessage("مبلغ غير صحيح"),
    "invalidAmountFormat": MessageLookupByLibrary.simpleMessage(
      "يرجى إدخال مبلغ صالح",
    ),
    "invalidEndBalance": MessageLookupByLibrary.simpleMessage(
      "يرجى إدخال رصيد نهاية صالح",
    ),
    "invalidQrCode": MessageLookupByLibrary.simpleMessage("QR Code غير صحيح"),
    "invalidStartBalance": MessageLookupByLibrary.simpleMessage(
      "يرجى إدخال رصيد بداية صالح",
    ),
    "invoiceCompleted": MessageLookupByLibrary.simpleMessage(
      "تم إكمال الفاتورة بنجاح",
    ),
    "invoiceCompletedError": MessageLookupByLibrary.simpleMessage(
      "خطأ في إكمال الفاتورة",
    ),
    "invoiceCreatedSuccess": MessageLookupByLibrary.simpleMessage(
      "تم إنشاء الفاتورة بنجاح",
    ),
    "invoiceDataNotAvailable": MessageLookupByLibrary.simpleMessage(
      "بيانات الإيصال غير متوفرة",
    ),
    "invoiceDetails": MessageLookupByLibrary.simpleMessage("تفاصيل الفاتورة"),
    "invoiceError": MessageLookupByLibrary.simpleMessage(
      "خطأ في تحميل الفواتير",
    ),
    "invoiceHistory": MessageLookupByLibrary.simpleMessage("تاريخ الفواتير"),
    "invoiceId": MessageLookupByLibrary.simpleMessage("رقم الفاتورة"),
    "invoiceNotFound": MessageLookupByLibrary.simpleMessage(
      "الفاتورة غير موجودة",
    ),
    "invoicePaid": MessageLookupByLibrary.simpleMessage(
      "تم دفع الفاتورة بنجاح",
    ),
    "invoicePaidError": MessageLookupByLibrary.simpleMessage(
      "خطأ في دفع الفاتورة",
    ),
    "invoicePickedUp": MessageLookupByLibrary.simpleMessage(
      "تم استلام السيارة بنجاح",
    ),
    "invoicePickedUpError": MessageLookupByLibrary.simpleMessage(
      "خطأ في استلام السيارة",
    ),
    "invoicePrintedSuccess": MessageLookupByLibrary.simpleMessage(
      "تم طباعة الفاتورة بنجاح",
    ),
    "invoiceRemoved": MessageLookupByLibrary.simpleMessage("تم إزالة الفاتورة"),
    "invoiceStatus": MessageLookupByLibrary.simpleMessage("حالة الفاتورة"),
    "invoices": MessageLookupByLibrary.simpleMessage("الفواتير"),
    "loading": MessageLookupByLibrary.simpleMessage("جاري التحميل..."),
    "loadingInvoices": MessageLookupByLibrary.simpleMessage(
      "جاري تحميل الفواتير...",
    ),
    "loginButton": MessageLookupByLibrary.simpleMessage("تسجيل الدخول"),
    "loginFailed": m1,
    "loginTitle": MessageLookupByLibrary.simpleMessage("تسجيل الدخول"),
    "logout": MessageLookupByLibrary.simpleMessage("تسجيل الخروج"),
    "logoutConfirmation": MessageLookupByLibrary.simpleMessage(
      "تأكيد تسجيل الخروج",
    ),
    "logoutError": MessageLookupByLibrary.simpleMessage(
      "حدث خطأ أثناء تسجيل الخروج",
    ),
    "logoutSuccess": MessageLookupByLibrary.simpleMessage(
      "تم تسجيل الخروج بنجاح",
    ),
    "logoutWarning": MessageLookupByLibrary.simpleMessage(
      "هذا الإجراء سينهي جلستك الحالية وسيسجل خروجك من التطبيق.",
    ),
    "moreOptions": MessageLookupByLibrary.simpleMessage("خيارات إضافية"),
    "moreOptionsSubtitle": MessageLookupByLibrary.simpleMessage(
      "Native، معاينة، مشاركة، والمزيد",
    ),
    "mustTerminateDailyBeforeLogout": MessageLookupByLibrary.simpleMessage(
      "يجب إنهاء الوردية قبل تسجيل الخروج",
    ),
    "noActiveInvoices": MessageLookupByLibrary.simpleMessage(
      "لا توجد فواتير نشطة",
    ),
    "noConfigFound": MessageLookupByLibrary.simpleMessage(
      "لم يتم العثور على الإعدادات",
    ),
    "noInvoices": MessageLookupByLibrary.simpleMessage("لا توجد فواتير"),
    "noInvoicesFound": MessageLookupByLibrary.simpleMessage(
      "لم يتم العثور على فواتير",
    ),
    "noPendingInvoices": MessageLookupByLibrary.simpleMessage(
      "لا توجد فواتير قيد الإحضار",
    ),
    "notes": MessageLookupByLibrary.simpleMessage("ملاحظات"),
    "notesDescription": MessageLookupByLibrary.simpleMessage(
      "أضف أي ملاحظات أو تعليقات إضافية (اختياري)",
    ),
    "notesOptional": MessageLookupByLibrary.simpleMessage("ملاحظات (اختياري)"),
    "openInBrowser": MessageLookupByLibrary.simpleMessage("فتح في المتصفح"),
    "openInBrowserSubtitle": MessageLookupByLibrary.simpleMessage(
      "عرض في المتصفح الخارجي",
    ),
    "optionalField": MessageLookupByLibrary.simpleMessage("هذا الحقل اختياري"),
    "paid": MessageLookupByLibrary.simpleMessage("مدفوعة"),
    "password": MessageLookupByLibrary.simpleMessage("كلمة المرور"),
    "payInvoice": MessageLookupByLibrary.simpleMessage("دفع الفاتورة"),
    "pending": MessageLookupByLibrary.simpleMessage("قيد الإحضار"),
    "pendingInvoices": MessageLookupByLibrary.simpleMessage(
      "الفواتير قيد الإحضار",
    ),
    "phoneNumber": MessageLookupByLibrary.simpleMessage("رقم الهاتف"),
    "pickupInvoice": MessageLookupByLibrary.simpleMessage("استلام السيارة"),
    "pleaseEnterEndBalance": MessageLookupByLibrary.simpleMessage(
      "يرجى إدخال الرصيد النهائي",
    ),
    "pleaseEnterPassword": MessageLookupByLibrary.simpleMessage(
      "يرجى إدخال كلمة المرور",
    ),
    "pleaseEnterPhone": MessageLookupByLibrary.simpleMessage(
      "يرجى إدخال رقم الهاتف",
    ),
    "pleaseEnterPhoneNumber": MessageLookupByLibrary.simpleMessage(
      "يرجى إدخال رقم الهاتف",
    ),
    "pleaseEnterValidAmount": MessageLookupByLibrary.simpleMessage(
      "يرجى إدخال مبلغ صالح",
    ),
    "previewPdf": MessageLookupByLibrary.simpleMessage("معاينة PDF"),
    "previewPdfSubtitle": MessageLookupByLibrary.simpleMessage(
      "فتح في عارض PDF",
    ),
    "pricingType": MessageLookupByLibrary.simpleMessage("نوع التسعير"),
    "print": MessageLookupByLibrary.simpleMessage("طباعة"),
    "printError": MessageLookupByLibrary.simpleMessage("خطأ في الطباعة"),
    "printFailed": MessageLookupByLibrary.simpleMessage("فشلت الطباعة"),
    "printInvoice": MessageLookupByLibrary.simpleMessage("طباعة الفاتورة"),
    "printNative": MessageLookupByLibrary.simpleMessage("طباعة Native"),
    "printNativeOnSunmi": MessageLookupByLibrary.simpleMessage(
      "طباعة Native على Sunmi",
    ),
    "printNativeOnSunmiSubtitle": MessageLookupByLibrary.simpleMessage(
      "طباعة إيصال مباشر بدون PDF",
    ),
    "printOptions": MessageLookupByLibrary.simpleMessage("خيارات الطباعة"),
    "printPdf": MessageLookupByLibrary.simpleMessage("طباعة PDF"),
    "printPdfOnSunmi": MessageLookupByLibrary.simpleMessage(
      "طباعة PDF على Sunmi",
    ),
    "printPdfOnSunmiSubtitle": MessageLookupByLibrary.simpleMessage(
      "طباعة PDF مباشرة على الطابعة الحرارية",
    ),
    "printPreview": MessageLookupByLibrary.simpleMessage("معاينة الطباعة"),
    "printSuccessful": MessageLookupByLibrary.simpleMessage(
      "تم الطباعة بنجاح!",
    ),
    "printing": MessageLookupByLibrary.simpleMessage("جاري الطباعة..."),
    "processingLogout": MessageLookupByLibrary.simpleMessage(
      "جاري معالجة تسجيل الخروج...",
    ),
    "profile": MessageLookupByLibrary.simpleMessage("الملف الشخصي"),
    "pullToRefresh": MessageLookupByLibrary.simpleMessage("اسحب للتحديث"),
    "qrCode": MessageLookupByLibrary.simpleMessage("QR Code"),
    "qrCodeRequired": MessageLookupByLibrary.simpleMessage(
      "QR Code مطلوب لإنهاء هذه الفاتورة",
    ),
    "refresh": MessageLookupByLibrary.simpleMessage("تحديث"),
    "remove": MessageLookupByLibrary.simpleMessage("إزالة"),
    "requestCar": MessageLookupByLibrary.simpleMessage("طلب السيارة"),
    "requiredField": MessageLookupByLibrary.simpleMessage("هذا الحقل مطلوب"),
    "retry": MessageLookupByLibrary.simpleMessage("إعادة المحاولة"),
    "save": MessageLookupByLibrary.simpleMessage("حفظ"),
    "scanQrCode": MessageLookupByLibrary.simpleMessage("مسح QR Code"),
    "scanQrCodeInstructions": MessageLookupByLibrary.simpleMessage(
      "ضع QR Code داخل الإطار لمسحه",
    ),
    "scanQrToComplete": MessageLookupByLibrary.simpleMessage(
      "يجب مسح QR Code لإنهاء الفاتورة",
    ),
    "search": MessageLookupByLibrary.simpleMessage("بحث"),
    "searchByCarNumber": MessageLookupByLibrary.simpleMessage(
      "البحث برقم السيارة",
    ),
    "sessionEndError": MessageLookupByLibrary.simpleMessage(
      "خطأ في إنهاء الجلسة النشطة",
    ),
    "settings": MessageLookupByLibrary.simpleMessage("الإعدادات"),
    "share": MessageLookupByLibrary.simpleMessage("مشاركة"),
    "shareSubtitle": MessageLookupByLibrary.simpleMessage(
      "مشاركة عبر التطبيقات الأخرى",
    ),
    "showPrices": MessageLookupByLibrary.simpleMessage("إظهار الأسعار"),
    "signIn": MessageLookupByLibrary.simpleMessage("تسجيل الدخول"),
    "signInToContinue": MessageLookupByLibrary.simpleMessage(
      "تسجيل الدخول للمتابعة",
    ),
    "simpleLogout": MessageLookupByLibrary.simpleMessage("تسجيل الخروج"),
    "startBalance": MessageLookupByLibrary.simpleMessage("رصيد البداية"),
    "startBalanceRequired": MessageLookupByLibrary.simpleMessage(
      "رصيد البداية مطلوب",
    ),
    "startDaily": MessageLookupByLibrary.simpleMessage("بدء اليومية"),
    "startDailySession": MessageLookupByLibrary.simpleMessage(
      "بدء جلسة اليومية",
    ),
    "startSession": MessageLookupByLibrary.simpleMessage("بدء الجلسة"),
    "startTime": MessageLookupByLibrary.simpleMessage("وقت البداية"),
    "success": MessageLookupByLibrary.simpleMessage("نجح"),
    "systemName": MessageLookupByLibrary.simpleMessage("اسم النظام"),
    "terminate": MessageLookupByLibrary.simpleMessage("إنهاء اليومية"),
    "terminateDaily": MessageLookupByLibrary.simpleMessage("إنهاء اليومية"),
    "terminateDailyAndLogout": MessageLookupByLibrary.simpleMessage(
      "إنهاء الوردية والخروج",
    ),
    "timeElapsed": MessageLookupByLibrary.simpleMessage("الوقت المنقضي"),
    "unpaid": MessageLookupByLibrary.simpleMessage("غير مدفوعة"),
    "userNotAuthenticated": MessageLookupByLibrary.simpleMessage(
      "المستخدم غير مصرح له",
    ),
    "viewDetails": MessageLookupByLibrary.simpleMessage("عرض التفاصيل"),
    "welcomeBack": MessageLookupByLibrary.simpleMessage("مرحبا بعودتك"),
  };
}
