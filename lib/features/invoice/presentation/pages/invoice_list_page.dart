import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:parkingtec/core/routing/routes.dart';
import 'package:parkingtec/core/theme/app_colors.dart';
import 'package:parkingtec/core/widgets/back_button_widget.dart';
import 'package:parkingtec/core/widgets/qr_scanner_widget.dart';
import 'package:parkingtec/features/invoice/data/models/invoice.dart';
import 'package:parkingtec/features/invoice/presentation/pages/create_invoice_dialog.dart';
import 'package:parkingtec/features/invoice/presentation/states/invoice_state.dart';
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

    // Load all invoice lists on init only if state is initial
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentState = ref.read(invoiceControllerProvider);
      // Only load if state is initial (not already loaded)
      if (currentState.maybeWhen(
        initial: () => true,
        orElse: () => false,
      )) {
        ref.read(invoiceControllerProvider.notifier).loadAllInvoiceLists();
      }
    });
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      // Check if data is already loaded before reloading
      final currentState = ref.read(invoiceControllerProvider);
      final hasData = currentState.maybeWhen(
        loaded: (all, active, pending, _, __) {
          switch (_tabController.index) {
            case 0:
              return all.isNotEmpty;
            case 1:
              return active.isNotEmpty;
            case 2:
              return pending.isNotEmpty;
            default:
              return false;
          }
        },
        orElse: () => false,
      );

      // Only reload if no data exists for current tab
      if (!hasData) {
        final controller = ref.read(invoiceControllerProvider.notifier);
        switch (_tabController.index) {
          case 0:
            controller.loadAllInvoices();
            break;
          case 1:
            controller.loadActiveInvoices();
            break;
          case 2:
            controller.loadPendingInvoices();
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
    final controller = ref.read(invoiceControllerProvider.notifier);
    if (query.isEmpty) {
      // Reload current tab
      switch (_tabController.index) {
        case 0:
          controller.loadAllInvoices();
          break;
        case 1:
          controller.loadActiveInvoices();
          break;
        case 2:
          controller.loadPendingInvoices();
          break;
      }
    } else {
      // Search in all invoices
      controller.searchInvoices(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    final invoiceState = ref.watch(invoiceControllerProvider);

    // Listen for errors
    ref.listen<InvoiceState>(invoiceControllerProvider, (previous, next) {
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
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary(context),
          indicatorColor: AppColors.primary,
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
          // Create Invoice Button
          IconButton(
            icon: Icon(
              Icons.add,
              color: AppColors.primaryX(context),
            ),
            onPressed: _showCreateInvoiceDialog,
            tooltip: S.of(context).createInvoice,
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
                    child: invoiceState.when(
                      initial: () => _buildLoadingState(context),
                      loading: () => _buildLoadingState(context),
                      loaded: (all, active, pending, current, query) {
                        // Filter invoices based on current tab
                        List<Invoice> displayedInvoices;
                        String emptyMessage;

                        switch (_tabController.index) {
                          case 0:
                            displayedInvoices = all;
                            emptyMessage = S.of(context).noInvoices;
                            break;
                          case 1:
                            displayedInvoices = active;
                            emptyMessage = S.of(context).noActiveInvoices;
                            break;
                          case 2:
                            displayedInvoices = pending;
                            emptyMessage = S.of(context).noPendingInvoices;
                            break;
                          default:
                            displayedInvoices = all;
                            emptyMessage = S.of(context).noInvoices;
                        }

                        return InvoiceListWidget(
                          invoices: displayedInvoices,
                          onRefresh: () {
                            ref.read(invoiceControllerProvider.notifier).refreshInvoices();
                          },
                          emptyMessage: emptyMessage,
                          isTablet: isTablet,
                        );
                      },
                      error: (failure) => _buildErrorState(context, failure.message),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
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
            Icon(
              Icons.error_outline,
              size: 64.w,
              color: AppColors.error,
            ),
            SizedBox(height: 16.h),
            Text(
              errorMessage,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.error,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: () {
                ref.read(invoiceControllerProvider.notifier).refreshInvoices();
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

