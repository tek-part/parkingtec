import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parkingtec/core/routing/routes.dart';
import 'package:parkingtec/features/auth/presentation/pages/login_page.dart';
import 'package:parkingtec/features/daily/presentation/pages/start_daily_page.dart';
import 'package:parkingtec/features/daily/presentation/pages/terminate_daily_page.dart';
import 'package:parkingtec/features/home/presentation/pages/home_page.dart';
import 'package:parkingtec/features/lot_details/presentation/pages/lot_details_page.dart';
import 'package:parkingtec/features/receipts/presentation/pages/history_page.dart';
import 'package:parkingtec/features/receipts/presentation/pages/receipt_page.dart';
import 'package:parkingtec/features/session/presentation/pages/active_session_page.dart';
import 'package:parkingtec/features/session/presentation/pages/end_session_page.dart';
import 'package:parkingtec/features/session/presentation/pages/session_created_page.dart';
import 'package:parkingtec/features/splash/presentation/pages/splash_page.dart';
import 'package:parkingtec/features/vehicle/presentation/pages/vehicle_entry_page.dart';
import 'package:parkingtec/features/config/presentation/pages/config_page.dart';
import 'package:parkingtec/features/invoice/presentation/pages/invoice_details_page.dart';
import 'package:parkingtec/features/invoice/presentation/pages/invoice_list_page.dart';
import 'package:parkingtec/features/printing/presentation/pages/printer_settings_page.dart';
import 'package:parkingtec/features/settings/presentation/pages/settings_page.dart';

class AppRouter {
  static GoRouter createRouter() {
    return GoRouter(
      restorationScopeId: 'router',
      initialLocation: Routes.splash,
      routes: <RouteBase>[
        GoRoute(
          path: Routes.splash,
          builder: (BuildContext context, GoRouterState state) =>
              const SplashPage(),
        ),
        GoRoute(
          path: Routes.login,
          builder: (BuildContext context, GoRouterState state) =>
              const LoginPage(),
        ),
        GoRoute(
          path: Routes.home,
          builder: (BuildContext context, GoRouterState state) =>
              const HomePage(),
        ),
        GoRoute(
          path: '/lot/:id',
          builder: (BuildContext context, GoRouterState state) =>
              LotDetailsPage(lotId: state.pathParameters['id'] ?? ''),
        ),
        GoRoute(
          path: Routes.vehicle,
          builder: (BuildContext context, GoRouterState state) =>
              VehicleEntryPage(lotId: state.uri.queryParameters['lotId']),
        ),
        GoRoute(
          path: '/session/created/:id',
          builder: (BuildContext context, GoRouterState state) =>
              SessionCreatedPage(sessionId: state.pathParameters['id'] ?? ''),
        ),
        GoRoute(
          path: '/session/active/:id',
          builder: (BuildContext context, GoRouterState state) =>
              ActiveSessionPage(sessionId: state.pathParameters['id'] ?? ''),
        ),
        GoRoute(
          path: '/session/end/:id',
          builder: (BuildContext context, GoRouterState state) =>
              EndSessionPage(sessionId: state.pathParameters['id'] ?? ''),
        ),
        GoRoute(
          path: '/receipt/:id',
          builder: (BuildContext context, GoRouterState state) =>
              ReceiptPage(receiptId: state.pathParameters['id'] ?? ''),
        ),
        GoRoute(
          path: Routes.history,
          builder: (BuildContext context, GoRouterState state) =>
              const HistoryPage(),
        ),
        GoRoute(
          path: Routes.dailyTerminate,
          builder: (BuildContext context, GoRouterState state) =>
              const TerminateDailyPage(),
        ),
        GoRoute(
          path: Routes.dailyStart,
          builder: (BuildContext context, GoRouterState state) =>
              const StartDailyPage(),
        ),
        GoRoute(
          path: Routes.config,
          builder: (BuildContext context, GoRouterState state) =>
              const ConfigPage(),
        ),
        GoRoute(
          path: Routes.settings,
          builder: (BuildContext context, GoRouterState state) {
            // Get initialTab from extra or query parameter
            final extra = state.extra as Map<String, dynamic>?;
            final initialTab = extra?['initialTab'] as int? ??
                (state.uri.queryParameters['tab'] != null
                    ? int.tryParse(state.uri.queryParameters['tab']!)
                    : null);
            return SettingsPage(initialTab: initialTab);
          },
        ),
        GoRoute(
          path: Routes.invoices,
          builder: (BuildContext context, GoRouterState state) =>
              const InvoiceListPage(),
        ),
        GoRoute(
          path: '/invoices/:id',
          builder: (BuildContext context, GoRouterState state) {
            final id = int.tryParse(state.pathParameters['id'] ?? '');
            if (id == null) {
              return const InvoiceListPage();
            }
            return InvoiceDetailsPage(invoiceId: id);
          },
        ),
        GoRoute(
          path: Routes.printerSettings,
          builder: (BuildContext context, GoRouterState state) =>
              const PrinterSettingsPage(),
        ),
      ],
    );
  }
}
