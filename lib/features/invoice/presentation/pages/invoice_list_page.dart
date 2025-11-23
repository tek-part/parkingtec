import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:parkingtec/core/routing/routes.dart';
import 'package:parkingtec/core/theme/app_colors.dart';
import 'package:parkingtec/core/widgets/back_button_widget.dart';
import 'package:parkingtec/core/widgets/qr_scanner_widget.dart';
import 'package:parkingtec/features/invoice/presentation/pages/create_invoice_dialog.dart';
import 'package:parkingtec/features/invoice/presentation/states/active_invoices_state.dart';
import 'package:parkingtec/features/invoice/presentation/states/all_invoices_state.dart';
import 'package:parkingtec/features/invoice/presentation/states/pending_invoices_state.dart';
import 'package:parkingtec/features/invoice/presentation/widgets/invoice_list_widget.dart';
import 'package:parkingtec/features/invoice/providers/invoice_providers.dart';
import 'package:parkingtec/generated/l10n.dart';

/// Invoice List Page
/// Displays all invoices with tabs for All, Active, and Pending
class InvoiceListPage extends ConsumerStatefulWidget {
  const InvoiceListPage({super.key});

  @override
  ConsumerState<InvoiceListPage> createState() => _InvoiceListPageState();
}

class _InvoiceListPageState extends ConsumerState<InvoiceListPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Load first tab data immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(allInvoicesControllerProvider.notifier).loadAllInvoices();
      }
    });

    // Listen for errors ONCE (not in build)
    ref.listenManual<AllInvoicesState>(allInvoicesControllerProvider, (
      previous,
      next,
    ) {
      next.maybeWhen(
        error: (failure) => _showError(failure.message),
        orElse: () {},
      );
    });

    ref.listenManual<ActiveInvoicesState>(activeInvoicesControllerProvider, (
      previous,
      next,
    ) {
      next.maybeWhen(
        error: (failure) => _showError(failure.message),
        orElse: () {},
      );
    });

    ref.listenManual<PendingInvoicesState>(pendingInvoicesControllerProvider, (
      previous,
      next,
    ) {
      next.maybeWhen(
        error: (failure) => _showError(failure.message),
        orElse: () {},
      );
    });
  }

  void _onTabChanged() {
    // Only handle when tab change is complete (not during animation)
    if (!_tabController.indexIsChanging && mounted) {
      final currentIndex = _tabController.index;

      // Check if data needs to be loaded for the selected tab
      switch (currentIndex) {
        case 0: // All Invoices
          final state = ref.read(allInvoicesControllerProvider);
          state.maybeWhen(
            initial: () {
              // Auto-load if no data exists
              ref
                  .read(allInvoicesControllerProvider.notifier)
                  .loadAllInvoices();
            },
            error: (_) {
              // Auto-retry on error
              ref
                  .read(allInvoicesControllerProvider.notifier)
                  .loadAllInvoices();
            },
            orElse: () {},
          );
          break;

        case 1: // Active Invoices
          final state = ref.read(activeInvoicesControllerProvider);
          state.maybeWhen(
            initial: () {
              // Auto-load if no data exists
              ref
                  .read(activeInvoicesControllerProvider.notifier)
                  .loadActiveInvoices();
            },
            error: (_) {
              // Auto-retry on error
              ref
                  .read(activeInvoicesControllerProvider.notifier)
                  .loadActiveInvoices();
            },
            orElse: () {},
          );
          break;

        case 2: // Pending Invoices
          final state = ref.read(pendingInvoicesControllerProvider);
          state.maybeWhen(
            initial: () {
              // Auto-load if no data exists
              ref
                  .read(pendingInvoicesControllerProvider.notifier)
                  .loadPendingInvoices();
            },
            error: (_) {
              // Auto-retry on error
              ref
                  .read(pendingInvoicesControllerProvider.notifier)
                  .loadPendingInvoices();
            },
            orElse: () {},
          );
          break;
      }
    }
  }

  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(color: Colors.white)),
        backgroundColor: AppColors.error,
      ),
    );
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      final idx = _tabController.index;
      if (query.isEmpty) {
        _clearSearch(idx);
      } else {
        _search(idx, query);
      }
    });
  }

  void _search(int idx, String query) {
    switch (idx) {
      case 0:
        ref
            .read(allInvoicesControllerProvider.notifier)
            .searchInLoadedInvoices(query);
        break;
      case 1:
        ref
            .read(activeInvoicesControllerProvider.notifier)
            .searchInLoadedInvoices(query);
        break;
      case 2:
        ref
            .read(pendingInvoicesControllerProvider.notifier)
            .searchInLoadedInvoices(query);
        break;
    }
  }

  void _clearSearch(int idx) {
    switch (idx) {
      case 0:
        ref.read(allInvoicesControllerProvider.notifier).clearSearch();
        break;
      case 1:
        ref.read(activeInvoicesControllerProvider.notifier).clearSearch();
        break;
      case 2:
        ref.read(pendingInvoicesControllerProvider.notifier).clearSearch();
        break;
    }
  }

  void _showCreateInvoiceDialog() {
    showDialog(
      context: context,
      builder: (context) => const CreateInvoiceDialog(),
    );
  }

  void _showQrScanner() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QrScannerWidget(
          onScanSuccess: (invoiceId) {
            Navigator.pop(context);
            context.push(Routes.invoiceDetails(invoiceId));
          },
          onScanError: (error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  error,
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: AppColors.error,
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: AppBar(
        leading: const BackButtonWidget(),
        title: Text(
          S.of(context).invoices,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.primaryX(context),
          ),
        ),
        backgroundColor: AppColors.background(context),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primaryX(context),
          unselectedLabelColor: AppColors.textSecondary(context),
          indicatorColor: AppColors.primaryX(context),
          tabs: [
            Tab(text: S.of(context).allInvoices),
            Tab(text: S.of(context).activeInvoices),
            Tab(text: S.of(context).pendingInvoices),
          ],
        ),
        actionsIconTheme: IconThemeData(
          color: AppColors.primaryX(context),
          size: 24.sp,
        ),
        actions: [
          // QR Scanner Button
          IconButton(
            icon: Icon(
              Icons.qr_code_scanner,
              color: AppColors.primaryX(context),
              size: 24.sp,
            ),
            onPressed: _showQrScanner,
            tooltip: S.of(context).scanQrCode,
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isTablet = constraints.maxWidth > 600;
          final maxWidth = isTablet ? 1200.w : double.infinity;

          return Column(
            children: [
              // Search Bar with maxWidth constraint for tablets
              Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: S.of(context).searchByCarNumber,
                        prefixIcon: Icon(
                          Icons.search,
                          color: AppColors.textSecondary(context),
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  color: AppColors.textSecondary(context),
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                  _onSearchChanged('');
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(
                            color: AppColors.border(context),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                      ),
                      onChanged: _onSearchChanged,
                    ),
                  ),
                ),
              ),

              // Tab Content
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxWidth),
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        AllInvoicesTab(isTablet: isTablet),
                        ActiveInvoicesTab(isTablet: isTablet),
                        PendingInvoicesTab(isTablet: isTablet),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: RepaintBoundary(
        child: FloatingActionButton(
          onPressed: _showCreateInvoiceDialog,
          backgroundColor: AppColors.backgroundX(context),
          child: Icon(Icons.add, color: AppColors.background(context)),
        ),
      ),
    );
  }
}

/// All Invoices Tab
/// Isolated widget that watches only its provider
class AllInvoicesTab extends ConsumerStatefulWidget {
  final bool isTablet;

  const AllInvoicesTab({super.key, required this.isTablet});

  @override
  ConsumerState<AllInvoicesTab> createState() => _AllInvoicesTabState();
}

class _AllInvoicesTabState extends ConsumerState<AllInvoicesTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final state = ref.watch(allInvoicesControllerProvider);

    return state.when(
      initial: () => _buildEmptyState(context, S.of(context).noInvoices),
      loading: () => _buildLoadingState(context),
      loaded: (invoices, _) => InvoiceListWidget(
        invoices: invoices,
        onRefresh: () {
          ref.read(allInvoicesControllerProvider.notifier).loadAllInvoices();
        },
        onLoadRequested: () {
          ref.read(allInvoicesControllerProvider.notifier).loadAllInvoices();
        },
        emptyMessage: S.of(context).noInvoices,
        isTablet: widget.isTablet,
      ),
      error: (failure) => _buildErrorState(context, failure.message),
    );
  }

  Widget _buildEmptyState(BuildContext context, String emptyMessage) {
    return InvoiceListWidget(
      invoices: const [],
      onLoadRequested: () {
        ref.read(allInvoicesControllerProvider.notifier).loadAllInvoices();
      },
      emptyMessage: emptyMessage,
      isTablet: widget.isTablet,
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          SizedBox(height: 16.h),
          Text(
            S.of(context).loadingInvoices,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String errorMessage) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64.w, color: AppColors.error),
            SizedBox(height: 16.h),
            Text(
              errorMessage,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: AppColors.error),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: () {
                ref
                    .read(allInvoicesControllerProvider.notifier)
                    .loadAllInvoices();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: Text(S.of(context).retry),
            ),
          ],
        ),
      ),
    );
  }
}

/// Active Invoices Tab
/// Isolated widget that watches only its provider
class ActiveInvoicesTab extends ConsumerStatefulWidget {
  final bool isTablet;

  const ActiveInvoicesTab({super.key, required this.isTablet});

  @override
  ConsumerState<ActiveInvoicesTab> createState() => _ActiveInvoicesTabState();
}

class _ActiveInvoicesTabState extends ConsumerState<ActiveInvoicesTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final state = ref.watch(activeInvoicesControllerProvider);

    return state.when(
      initial: () => _buildEmptyState(context, S.of(context).noActiveInvoices),
      loading: () => _buildLoadingState(context),
      loaded: (invoices, _) => InvoiceListWidget(
        invoices: invoices,
        onRefresh: () {
          ref
              .read(activeInvoicesControllerProvider.notifier)
              .loadActiveInvoices();
        },
        onLoadRequested: () {
          ref
              .read(activeInvoicesControllerProvider.notifier)
              .loadActiveInvoices();
        },
        emptyMessage: S.of(context).noActiveInvoices,
        isTablet: widget.isTablet,
      ),
      error: (failure) => _buildErrorState(context, failure.message),
    );
  }

  Widget _buildEmptyState(BuildContext context, String emptyMessage) {
    return InvoiceListWidget(
      invoices: const [],
      onLoadRequested: () {
        ref
            .read(activeInvoicesControllerProvider.notifier)
            .loadActiveInvoices();
      },
      emptyMessage: emptyMessage,
      isTablet: widget.isTablet,
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          SizedBox(height: 16.h),
          Text(
            S.of(context).loadingInvoices,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String errorMessage) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64.w, color: AppColors.error),
            SizedBox(height: 16.h),
            Text(
              errorMessage,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: AppColors.error),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: () {
                ref
                    .read(activeInvoicesControllerProvider.notifier)
                    .loadActiveInvoices();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: Text(S.of(context).retry),
            ),
          ],
        ),
      ),
    );
  }
}

/// Pending Invoices Tab
/// Isolated widget that watches only its provider
class PendingInvoicesTab extends ConsumerStatefulWidget {
  final bool isTablet;

  const PendingInvoicesTab({super.key, required this.isTablet});

  @override
  ConsumerState<PendingInvoicesTab> createState() => _PendingInvoicesTabState();
}

class _PendingInvoicesTabState extends ConsumerState<PendingInvoicesTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final state = ref.watch(pendingInvoicesControllerProvider);

    return state.when(
      initial: () => _buildEmptyState(context, S.of(context).noPendingInvoices),
      loading: () => _buildLoadingState(context),
      loaded: (invoices, _) => InvoiceListWidget(
        invoices: invoices,
        onRefresh: () {
          ref
              .read(pendingInvoicesControllerProvider.notifier)
              .loadPendingInvoices();
        },
        onLoadRequested: () {
          ref
              .read(pendingInvoicesControllerProvider.notifier)
              .loadPendingInvoices();
        },
        emptyMessage: S.of(context).noPendingInvoices,
        isTablet: widget.isTablet,
      ),
      error: (failure) => _buildErrorState(context, failure.message),
    );
  }

  Widget _buildEmptyState(BuildContext context, String emptyMessage) {
    return InvoiceListWidget(
      invoices: const [],
      onLoadRequested: () {
        ref
            .read(pendingInvoicesControllerProvider.notifier)
            .loadPendingInvoices();
      },
      emptyMessage: emptyMessage,
      isTablet: widget.isTablet,
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          SizedBox(height: 16.h),
          Text(
            S.of(context).loadingInvoices,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String errorMessage) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64.w, color: AppColors.error),
            SizedBox(height: 16.h),
            Text(
              errorMessage,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: AppColors.error),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: () {
                ref
                    .read(pendingInvoicesControllerProvider.notifier)
                    .loadPendingInvoices();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: Text(S.of(context).retry),
            ),
          ],
        ),
      ),
    );
  }
}
