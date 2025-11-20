import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parkingtec/core/theme/app_colors.dart';
import 'package:parkingtec/core/utils/currency_formatter.dart';
import 'package:parkingtec/features/config/providers/config_providers.dart';
import 'package:parkingtec/features/invoice/data/models/requests/create_invoice_request.dart';
import 'package:parkingtec/features/invoice/presentation/states/create_invoice_state.dart';
import 'package:parkingtec/features/invoice/providers/invoice_providers.dart';
import 'package:parkingtec/features/printing/presentation/widgets/dialogs/printer_not_connected_dialog.dart';
import 'package:parkingtec/features/printing/utils/printer_connection_helper.dart';
import 'package:parkingtec/generated/l10n.dart';

class CreateInvoiceDialog extends ConsumerStatefulWidget {
  const CreateInvoiceDialog({super.key});

  @override
  ConsumerState<CreateInvoiceDialog> createState() =>
      _CreateInvoiceDialogState();
}

class _CreateInvoiceDialogState extends ConsumerState<CreateInvoiceDialog>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _carNumController = TextEditingController();
  final _customerNameController = TextEditingController();
  final _carModelController = TextEditingController();
  final _amountController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  bool _invoiceCreated = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    // Initialize amount with default fixed price if available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final defaultFixedPrice = ref.read(defaultFixedPriceProvider);
      final isFixed = ref.read(isFixedPricingProvider);
      if (isFixed && defaultFixedPrice != null && mounted) {
        _amountController.text = defaultFixedPrice.toStringAsFixed(2);
      }
    });
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _carNumController.dispose();
    _customerNameController.dispose();
    _carModelController.dispose();
    _amountController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final createInvoiceState = ref.watch(createInvoiceControllerProvider);
    final isLoading = createInvoiceState.maybeWhen(
      loading: () => true,
      orElse: () => false,
    );
    final error = createInvoiceState.maybeWhen(
      error: (failure) => failure.message,
      orElse: () => null,
    );
    final isFixedPricing = ref.watch(isFixedPricingProvider);
    final currencySymbol = ref.watch(currencySymbolProvider);
    final defaultFixedPrice = ref.watch(defaultFixedPriceProvider);

    // Listen for success
    ref.listen<CreateInvoiceState>(createInvoiceControllerProvider, (
      previous,
      next,
    ) {
      // Check if invoice was created successfully
      if (!_invoiceCreated && mounted) {
        next.maybeWhen(
          success: (invoice) {
            _invoiceCreated = true;
            // Use a post-frame callback to ensure the dialog closes after the state update
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted && Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      S.of(context).invoiceCreatedSuccess,
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: AppColors.success,
                  ),
                );
              }
            });
          },
          orElse: () {},
        );
      }
    });

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Container(
                  padding: EdgeInsets.all(24.w),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          S.of(context).createInvoice,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary(context),
                              ),
                        ),
                        SizedBox(height: 24.h),

                        // Car Number Field (Required)
                        TextFormField(
                          controller: _carNumController,
                          decoration: InputDecoration(
                            labelText: S.of(context).carNumber,
                            hintText: S.of(context).enterCarNumber,
                            prefixIcon: const Icon(Icons.directions_car),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(
                                color: AppColors.primary,
                                width: 2,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return S.of(context).carNumberRequired;
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.h),

                        // Customer Name Field (Optional)
                        TextFormField(
                          controller: _customerNameController,
                          decoration: InputDecoration(
                            labelText: S.of(context).customerName,
                            hintText: S.of(context).customerNameOptional,
                            prefixIcon: const Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(
                                color: AppColors.primary,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),

                        // Car Model Field (Optional)
                        TextFormField(
                          controller: _carModelController,
                          decoration: InputDecoration(
                            labelText: S.of(context).carModel,
                            hintText: S.of(context).carModelOptional,
                            prefixIcon: const Icon(Icons.car_repair),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(
                                color: AppColors.primary,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),

                        // Amount Field (only for fixed pricing)
                        if (isFixedPricing) ...[
                          TextFormField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText:
                                  '${S.of(context).amount} ${currencySymbol != null ? "($currencySymbol)" : ""}',
                              hintText: defaultFixedPrice != null
                                  ? CurrencyFormatter.formatAmount(
                                      defaultFixedPrice,
                                      null,
                                      currencySymbol,
                                    )
                                  : null,
                              prefixIcon: const Icon(Icons.attach_money),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: BorderSide(
                                  color: AppColors.primary,
                                  width: 2,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return S.of(context).pleaseEnterValidAmount;
                              }
                              if (double.tryParse(value) == null) {
                                return S.of(context).pleaseEnterValidAmount;
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.h),
                        ] else ...[
                          // For hourly pricing, show info message
                          Container(
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(
                                color: AppColors.primary.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: AppColors.primary,
                                  size: 20.w,
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Text(
                                    S.of(context).amountWillBeCalculated,
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: AppColors.textSecondary(
                                            context,
                                          ),
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16.h),
                        ],

                        // Error Message
                        if (error != null)
                          Container(
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: AppColors.error.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(color: AppColors.error),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.error,
                                  color: AppColors.error,
                                  size: 20.w,
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Text(
                                    error,
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(color: AppColors.error),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        SizedBox(height: 16.h),

                        // Buttons
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: isLoading
                                    ? null
                                    : () => Navigator.of(context).pop(),
                                child: Text(S.of(context).cancel),
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: isLoading
                                    ? null
                                    : _handleCreateInvoice,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                ),
                                child: isLoading
                                    ? SizedBox(
                                        width: 20.w,
                                        height: 20.w,
                                        child: const CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      )
                                    : Text(S.of(context).create),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _handleCreateInvoice() async {
    if (!_formKey.currentState!.validate()) return;

    // Check printer connection before creating invoice
    final isConnected = PrinterConnectionHelper.isPrinterConnected(ref);

    if (!isConnected) {
      // Show printer not connected dialog
      if (!mounted) return;
      final result = await PrinterNotConnectedDialog.show(context);

      if (!mounted) return;
      if (result == null) {
        // User navigated to settings, cancel creation
        return;
      } else if (result == false) {
        // User cancelled, do nothing
        return;
      }
      // result == true: User chose to continue without printing
      // Proceed with creation (printing will be skipped in controller)
    }

    final isFixedPricing = ref.read(isFixedPricingProvider);
    double? amount;

    // For fixed pricing, get amount from field
    // For hourly pricing, amount will be null (calculated later)
    if (isFixedPricing) {
      amount = double.tryParse(_amountController.text);
      if (amount == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              S.of(context).pleaseEnterValidAmount,
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }
    }

    final request = CreateInvoiceRequest(
      carNum: _carNumController.text.trim(),
      carModel: _carModelController.text.trim().isEmpty
          ? null
          : _carModelController.text.trim(),
      customerName: _customerNameController.text.trim().isEmpty
          ? null
          : _customerNameController.text.trim(),
      amount: amount,
    );

    // Pass skipPrinting flag if printer is not connected
    await ref
        .read(createInvoiceControllerProvider.notifier)
        .createInvoice(request, skipPrinting: !isConnected);
  }
}
