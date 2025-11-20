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
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      // Check if data is already loaded before reloading
      bool hasData = false;
      switch (_tabController.index) {
        case 0:
          hasData = ref
              .read(allInvoicesControllerProvider)
              .maybeWhen(
                loaded: (invoices, _) => invoices.isNotEmpty,
                orElse: () => false,
              );
          break;
        case 1:
          hasData = ref
              .read(activeInvoicesControllerProvider)
              .maybeWhen(
                loaded: (invoices, _) => invoices.isNotEmpty,
                orElse: () => false,
              );
          break;
        case 2:
          hasData = ref
              .read(pendingInvoicesControllerProvider)
              .maybeWhen(
                loaded: (invoices, _) => invoices.isNotEmpty,
                orElse: () => false,
              );
          break;
      }

      // Only reload if no data exists for current tab
      if (!hasData) {
        switch (_tabController.index) {
          case 0:
            ref.read(allInvoicesControllerProvider.notifier).loadAllInvoices();
            break;
          case 1:
            ref
                .read(activeInvoicesControllerProvider.notifier)
                .loadActiveInvoices();
            break;
          case 2:
            ref
                .read(pendingInvoicesControllerProvider.notifier)
                .loadPendingInvoices();
            break;
        }
      }
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
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

  void _handleSearch(String query) {
    if (query.isEmpty) {
      // Clear search - show all loaded invoices
      switch (_tabController.index) {
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
    } else {
      // Search in already loaded invoices only
      switch (_tabController.index) {
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
  }

  @override
  Widget build(BuildContext context) {
    // Watch specific controllers based on current tab
    final allInvoicesState = ref.watch(allInvoicesControllerProvider);
    final activeInvoicesState = ref.watch(activeInvoicesControllerProvider);
    final pendingInvoicesState = ref.watch(pendingInvoicesControllerProvider);

    // Listen for errors from all controllers
    ref.listen<AllInvoicesState>(allInvoicesControllerProvider, (
      previous,
      next,
    ) {
      next.maybeWhen(
        error: (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                failure.message,
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: AppColors.error,
            ),
          );
        },
        orElse: () {},
      );
    });

    ref.listen<ActiveInvoicesState>(activeInvoicesControllerProvider, (
      previous,
      next,
    ) {
      next.maybeWhen(
        error: (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                failure.message,
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: AppColors.error,
            ),
          );
        },
        orElse: () {},
      );
    });

    ref.listen<PendingInvoicesState>(pendingInvoicesControllerProvider, (
      previous,
      next,
    ) {
      next.maybeWhen(
        error: (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                failure.message,
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: AppColors.error,
            ),
          );
        },
        orElse: () {},
      );
    });

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
        actions: [
          // QR Scanner Button
          IconButton(
            icon: Icon(
              Icons.qr_code_scanner,
              color: AppColors.primaryX(context),
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
                                  _handleSearch('');
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
                      onChanged: _handleSearch,
                    ),
                  ),
                ),
              ),

              // Tab Content
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxWidth),
                    child: _buildTabContent(
                      context,
                      allInvoicesState,
                      activeInvoicesState,
                      pendingInvoicesState,
                      isTablet,
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

  Widget _buildTabContent(
    BuildContext context,
    AllInvoicesState allInvoicesState,
    ActiveInvoicesState activeInvoicesState,
    PendingInvoicesState pendingInvoicesState,
    bool isTablet,
  ) {
    switch (_tabController.index) {
      case 0:
        return allInvoicesState.when(
          initial: () => _buildEmptyState(context, S.of(context).noInvoices, 0),
          loading: () => _buildLoadingState(context),
          loaded: (invoices, _) => InvoiceListWidget(
            invoices: invoices,
            onRefresh: () {
              ref
                  .read(allInvoicesControllerProvider.notifier)
                  .loadAllInvoices();
            },
            onLoadRequested: () {
              ref
                  .read(allInvoicesControllerProvider.notifier)
                  .loadAllInvoices();
            },
            emptyMessage: S.of(context).noInvoices,
            isTablet: isTablet,
          ),
          error: (failure) => _buildErrorState(context, failure.message, 0),
        );
      case 1:
        return activeInvoicesState.when(
          initial: () =>
              _buildEmptyState(context, S.of(context).noActiveInvoices, 1),
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
            isTablet: isTablet,
          ),
          error: (failure) => _buildErrorState(context, failure.message, 1),
        );
      case 2:
        return pendingInvoicesState.when(
          initial: () =>
              _buildEmptyState(context, S.of(context).noPendingInvoices, 2),
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
            isTablet: isTablet,
          ),
          error: (failure) => _buildErrorState(context, failure.message, 2),
        );
      default:
        return _buildEmptyState(context, S.of(context).noInvoices, 0);
    }
  }

  Widget _buildEmptyState(
    BuildContext context,
    String emptyMessage,
    int tabIndex,
  ) {
    return InvoiceListWidget(
      invoices: const [],
      onLoadRequested: () {
        switch (tabIndex) {
          case 0:
            ref.read(allInvoicesControllerProvider.notifier).loadAllInvoices();
            break;
          case 1:
            ref
                .read(activeInvoicesControllerProvider.notifier)
                .loadActiveInvoices();
            break;
          case 2:
            ref
                .read(pendingInvoicesControllerProvider.notifier)
                .loadPendingInvoices();
            break;
        }
      },
      emptyMessage: emptyMessage,
      isTablet: false,
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

  Widget _buildErrorState(
    BuildContext context,
    String errorMessage,
    int tabIndex,
  ) {
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
                switch (tabIndex) {
                  case 0:
                    ref
                        .read(allInvoicesControllerProvider.notifier)
                        .loadAllInvoices();
                    break;
                  case 1:
                    ref
                        .read(activeInvoicesControllerProvider.notifier)
                        .loadActiveInvoices();
                    break;
                  case 2:
                    ref
                        .read(pendingInvoicesControllerProvider.notifier)
                        .loadPendingInvoices();
                    break;
                }
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
