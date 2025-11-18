import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parkingtec/app.dart';
import 'package:parkingtec/core/routing/app_router.dart';
import 'package:parkingtec/core/services/api_service.dart';
import 'package:parkingtec/core/services/fcm_service.dart';

import 'firebase_options.dart';

/// Background message handler
/// This function must be top-level (not a class method)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // Handle background message here
  print('Handling background message: ${message.messageId}');
  print('Message data: ${message.data}');
  print('Message notification: ${message.notification?.title}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize FCM Service for device token
  await FcmService.initialize();

  // Register background message handler
  FcmService.setBackgroundMessageHandler(firebaseMessagingBackgroundHandler);

  // Initialize API Service before app starts
  // This ensures ApiService is ready when providers access it
  await ApiService.getInstance();

  runApp(const ProviderScope(child: TecParkingApp()));
}

class TecParkingApp extends StatelessWidget {
  const TecParkingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? _) {
        final router = AppRouter.createRouter();
        return App(router: router);
      },
    );
  }
}
