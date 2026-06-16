import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/printer_service.dart';
import '../../data/models/today_payments/today_payments_request_model.dart';
import '../bloc/mark_payment/mark_payment_bloc.dart';
import 'utils/payment_receipt_print.dart';

class TodayPaymentPage extends StatefulWidget {
  const TodayPaymentPage({super.key});

  @override
  State<TodayPaymentPage> createState() => _TodayPaymentPageState();
}

class _TodayPaymentPageState extends State<TodayPaymentPage> {
  DateTime _selectedDate = DateTime.now();
  final PrinterService _printerService = PrinterService();
  String _reprintingId = '';

  // Track expanded/collapsed state for each payment
  final Set<int> _expandedItems = {};

  @override
  void initState() {
    super.initState();
    _loadPayments();
    _checkPrinterStatus();
  }

  void _loadPayments() {
    if (!mounted) return;

    context.read<MarkPaymentBloc>().add(
      TodayPaymentsRequested(
        requestModel: TodayPaymentsRequestModel(date: _selectedDate),
      ),
    );
  }

  Future<void> _checkPrinterStatus() async {
    await _printerService.autoReconnect();
    if (mounted) setState(() {});
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
      _loadPayments();
    }
  }

  void _toggleExpanded(int paymentId) {
    setState(() {
      if (_expandedItems.contains(paymentId)) {
        _expandedItems.remove(paymentId);
      } else {
        _expandedItems.add(paymentId);
      }
    });
  }

  Future<void> _reprintReceipt(dynamic paymentItem) async {
    setState(() {
      _reprintingId = paymentItem.payment.receiptNumber;
    });

    try {
      if (!_printerService.isConnected) {
        await _showPrinterConnectionDialog();
        return;
      }

      // Parse amount safely - handle String to double conversion
      double amount = 0.0;
      if (paymentItem.payment.amount is String) {
        amount = double.tryParse(paymentItem.payment.amount) ?? 0.0;
      } else if (paymentItem.payment.amount is num) {
        amount = (paymentItem.payment.amount as num).toDouble();
      }

      // Create a single payment item for reprint (as a list with one item)
      final paymentItemsList = [
        PaymentReceiptItem(
          className: paymentItem.studentClass.className,
          subject: paymentItem.studentClass.subject.subjectName,
          categoryName:
              paymentItem.studentClass.category?.categoryName ?? "N/A",
          grade: 'Grade ${paymentItem.studentClass.grade.gradeName}',
          teacherInitials: paymentItem.studentClass.teacher.initials,
          amount: amount,
        ),
      ];

      await PaymentReceiptPrint.printBulkReceipt(
        printerService: _printerService,
        instituteName: 'Minipalasa Education Centre',
        studentName: paymentItem.student.initialName,
        studentId: paymentItem.student.customId,
        paymentMonth: paymentItem.payment.paymentMonth != null
            ? DateFormat('yyyy-MM').format(paymentItem.payment.paymentMonth!)
            : '',
        items: paymentItemsList,
        totalFee: amount,
        discountAmount: 0.0,
        payableTotal: amount,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Receipt reprinted successfully'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Reprint failed: $e'),
            backgroundColor: AppColors.danger,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _reprintingId = '';
        });
      }
    }
  }

  Future<void> _showPrinterConnectionDialog() async {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.print_disabled_rounded,
                  size: 40,
                  color: AppColors.warning,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Printer Not Connected',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              Text(
                'Please connect your Bluetooth printer to print receipts.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/print_test_screen').then(
                          (_) {
                            _checkPrinterStatus();
                          },
                        );
                      },
                      child: const Text('Connect Printer'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text(
          'Today Payments',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            onPressed: _checkPrinterStatus,
            icon: const Icon(Icons.print_rounded),
            tooltip: 'Check Printer',
          ),
        ],
      ),
      body: SizedBox.expand(
        child: SafeArea(
          child: Column(
            children: [
              // Printer Warning Banner
              if (!_printerService.isConnected)
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.print_disabled_rounded,
                        color: Colors.orange.shade700,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Printer not connected. Receipts will not be printed.',
                          style: TextStyle(
                            color: Colors.orange.shade800,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          await Navigator.pushNamed(
                            context,
                            '/print_test_screen',
                          );
                          await _checkPrinterStatus();
                          setState(() {});
                        },
                        child: const Text(
                          'Connect',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),

              // Date Selection Header
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: AppColors.heroGradient,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: AppColors.largeShadow,
                ),
                child: Row(
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.payments_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Selected Date',
                            style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            DateFormat('yyyy-MM-dd').format(_selectedDate),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        minWidth: 120,
                        maxWidth: 140,
                        minHeight: 44,
                      ),
                      child: ElevatedButton.icon(
                        onPressed: _pickDate,
                        icon: const Icon(
                          Icons.calendar_month_rounded,
                          size: 18,
                        ),
                        label: const Text('Change'),
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Payment List with Expand/Collapse
              Expanded(
                child: BlocBuilder<MarkPaymentBloc, MarkPaymentState>(
                  builder: (context, state) {
                    if (state is TodayPaymentsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is TodayPaymentsError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline_rounded,
                                color: Colors.red,
                                size: 70,
                              ),
                              const SizedBox(height: 14),
                              Text(
                                state.message,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    if (state is TodayPaymentsLoaded) {
                      final payments = state.response.data;

                      if (payments.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.payments_outlined,
                                size: 90,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 14),
                              Text(
                                'No Payments Found',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'There are no payments for this date.',
                                style: TextStyle(color: Colors.grey.shade500),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        itemCount: payments.length,
                        itemBuilder: (context, index) {
                          final item = payments[index];
                          final hasImage =
                              item.student.imgUrl != null &&
                              item.student.imgUrl!.isNotEmpty;
                          final isReprinting =
                              _reprintingId == item.payment.receiptNumber;
                          final isExpanded = _expandedItems.contains(index);

                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: AppColors.border),
                              boxShadow: AppColors.softShadow,
                            ),
                            child: Column(
                              children: [
                                // Header Section (Always visible)
                                InkWell(
                                  onTap: () => _toggleExpanded(index),
                                  borderRadius: BorderRadius.circular(30),
                                  child: Padding(
                                    padding: const EdgeInsets.all(18),
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Student Avatar
                                            CircleAvatar(
                                              radius: 30,
                                              backgroundColor: AppColors.primary
                                                  .withOpacity(.10),
                                              backgroundImage: hasImage
                                                  ? NetworkImage(
                                                      item.student.imgUrl!,
                                                    )
                                                  : null,
                                              child: !hasImage
                                                  ? const Icon(
                                                      Icons.person,
                                                      color: AppColors.primary,
                                                    )
                                                  : null,
                                            ),
                                            const SizedBox(width: 14),

                                            // Student Info
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    item.student.initialName,
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    item.student.customId,
                                                    style: TextStyle(
                                                      color:
                                                          Colors.grey.shade600,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    item.student.guardianMobile,
                                                    style: TextStyle(
                                                      color:
                                                          Colors.grey.shade600,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            // Amount and Receipt
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  'LKR ${item.payment.amount}',
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.green,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 5,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: AppColors.primary
                                                            .withOpacity(.10),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              999,
                                                            ),
                                                      ),
                                                      child: Text(
                                                        item
                                                            .payment
                                                            .receiptNumber,
                                                        style: const TextStyle(
                                                          color:
                                                              AppColors.primary,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 11,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    // Reprint Button
                                                    Tooltip(
                                                      message:
                                                          'Reprint Receipt',
                                                      child: InkWell(
                                                        onTap: isReprinting
                                                            ? null
                                                            : () =>
                                                                  _reprintReceipt(
                                                                    item,
                                                                  ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets.all(
                                                                8,
                                                              ),
                                                          decoration: BoxDecoration(
                                                            color: AppColors
                                                                .primary
                                                                .withOpacity(
                                                                  0.1,
                                                                ),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  12,
                                                                ),
                                                          ),
                                                          child: isReprinting
                                                              ? const SizedBox(
                                                                  width: 18,
                                                                  height: 18,
                                                                  child: CircularProgressIndicator(
                                                                    strokeWidth:
                                                                        2,
                                                                    color: AppColors
                                                                        .primary,
                                                                  ),
                                                                )
                                                              : const Icon(
                                                                  Icons
                                                                      .receipt_long_rounded,
                                                                  size: 18,
                                                                  color: AppColors
                                                                      .primary,
                                                                ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(width: 8),
                                            // Expand/Collapse Icon
                                            Icon(
                                              isExpanded
                                                  ? Icons
                                                        .keyboard_arrow_up_rounded
                                                  : Icons
                                                        .keyboard_arrow_down_rounded,
                                              color: Colors.grey.shade600,
                                              size: 24,
                                            ),
                                          ],
                                        ),

                                        // Class Info Summary (Always visible)
                                        const SizedBox(height: 12),
                                        Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary
                                                .withOpacity(0.05),
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      item
                                                          .studentClass
                                                          .className,
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 2),
                                                    Text(
                                                      item
                                                          .studentClass
                                                          .subject
                                                          .subjectName,
                                                      style: TextStyle(
                                                        color: Colors
                                                            .grey
                                                            .shade600,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 4,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: AppColors.warning
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  item
                                                          .studentClass
                                                          .category
                                                          ?.categoryName ??
                                                      'N/A',
                                                  style: TextStyle(
                                                    color: AppColors.warning,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 11,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // Expanded Details Section
                                AnimatedCrossFade(
                                  duration: const Duration(milliseconds: 300),
                                  crossFadeState: isExpanded
                                      ? CrossFadeState.showFirst
                                      : CrossFadeState.showSecond,
                                  firstChild: Container(
                                    padding: const EdgeInsets.fromLTRB(
                                      18,
                                      0,
                                      18,
                                      18,
                                    ),
                                    child: Column(
                                      children: [
                                        const Divider(height: 1),
                                        const SizedBox(height: 16),
                                        Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: const Color(0xfff8fafc),
                                            borderRadius: BorderRadius.circular(
                                              22,
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              _infoRow(
                                                'Class',
                                                item.studentClass.className,
                                              ),
                                              _infoRow(
                                                'Category',
                                                item
                                                        .studentClass
                                                        .category
                                                        ?.categoryName ??
                                                    'N/A',
                                              ),
                                              _infoRow(
                                                'Grade',
                                                item
                                                    .studentClass
                                                    .grade
                                                    .gradeName,
                                              ),
                                              _infoRow(
                                                'Subject',
                                                item
                                                    .studentClass
                                                    .subject
                                                    .subjectName,
                                              ),
                                              _infoRow(
                                                'Teacher',
                                                item
                                                    .studentClass
                                                    .teacher
                                                    .initials,
                                              ),
                                              _infoRow(
                                                'Receipt No',
                                                item.payment.receiptNumber,
                                              ),
                                              _infoRow(
                                                'Method',
                                                item.payment.markMethod,
                                              ),
                                              _infoRow(
                                                'Paid Month',
                                                DateFormat('yyyy-MM').format(
                                                  item.payment.paymentMonth ??
                                                      DateTime.now(),
                                                ),
                                              ),
                                              _infoRow(
                                                'Paid At',
                                                DateFormat(
                                                  'yyyy-MM-dd hh:mm a',
                                                ).format(
                                                  item.payment.paidAt ??
                                                      DateTime.now(),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  secondChild: const SizedBox.shrink(),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.dark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
