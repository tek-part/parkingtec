import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parkingtec/core/theme/app_colors.dart';
import 'package:parkingtec/core/widgets/back_button_widget.dart';
import 'package:parkingtec/generated/l10n.dart';
import 'tabs/printer_settings_tab.dart';
import 'tabs/app_settings_tab.dart';
import 'tabs/app_config_tab.dart';

class SettingsPage extends ConsumerStatefulWidget {
  final int? initialTab;

  const SettingsPage({super.key, this.initialTab});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    final initialIndex = widget.initialTab ?? 0;
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: initialIndex.clamp(0, 2),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: AppBar(
        leading: const BackButtonWidget(),
        title: Text(
          S.of(context).settings,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.primaryX(context),
          ),
        ),
        backgroundColor: AppColors.background(context),
        foregroundColor: AppColors.primaryX(context),
        elevation: 0,
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primaryX(context),
          labelColor: AppColors.backgroundX(context),
          unselectedLabelColor: AppColors.textSecondary(context),
          tabs: [
            Tab(
              icon: Icon(Icons.print, color: AppColors.primaryX(context)),
              text: S.of(context).printerSettings,
            ),
            Tab(
              icon: Icon(Icons.settings, color: AppColors.primaryX(context)),
              text: S.of(context).appSettings,
            ),
            Tab(
              icon: Icon(Icons.tune, color: AppColors.primaryX(context)),
              text: S.of(context).appConfig,
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          PrinterSettingsTab(),
          AppSettingsTab(),
          AppConfigTab(),
        ],
      ),
    );
  }
}
