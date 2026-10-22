import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/printer_service.dart';
import '../../data/models/today_payments/today_payment_item_model.dart';
import '../../data/models/today_payments/today_payments_request_model.dart';
import '../bloc/mark_payment/mark_payment_bloc.dart';
import 'utils/payment_receipt_print.dart';
import '../../../../../core/utils/app_datetime.dart';
import '../../../../../core/constants/app_config.dart';

class TodayPaymentPage extends StatefulWidget {
  const TodayPaymentPage({super.key});

  @override
  State<TodayPaymentPage> createState() => _TodayPaymentPageState();
}

class _TodayPaymentPageState extends State<TodayPaymentPage> {
  DateTime _selectedDate = DateTime.now();

  final PrinterService _printerService = PrinterService();

  String _reprintingId = '';

  /// Payment ID based expanded state.
  final Set<int> _expandedItems = {};

  @override
  void initState() {
    super.initState();

    _loadPayments();

    _checkPrinterStatus();
  }

  /*
  |--------------------------------------------------------------------------
  | Load Payments
  |--------------------------------------------------------------------------
  */

  void _loadPayments() {
    if (!mounted) return;

    context.read<MarkPaymentBloc>().add(
      TodayPaymentsRequested(
        requestModel: TodayPaymentsRequestModel(date: _selectedDate),
      ),
    );
  }

  /*
  |--------------------------------------------------------------------------
  | Printer
  |--------------------------------------------------------------------------
  */

  Future<void> _checkPrinterStatus() async {
    await _printerService.autoReconnect();

    if (mounted) {
      setState(() {});
    }
  }

  /*
  |--------------------------------------------------------------------------
  | Date Picker
  |--------------------------------------------------------------------------
  */

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked == null) return;

    setState(() {
      _selectedDate = picked;
      _expandedItems.clear();
    });

    _loadPayments();
  }

  /*
  |--------------------------------------------------------------------------
  | Expand / Collapse
  |--------------------------------------------------------------------------
  */

  void _toggleExpanded(int paymentId) {
    setState(() {
      if (_expandedItems.contains(paymentId)) {
        _expandedItems.remove(paymentId);
      } else {
        _expandedItems.add(paymentId);
      }
    });
  }

  /*
  |--------------------------------------------------------------------------
  | Reprint Receipt
  |--------------------------------------------------------------------------
  */

  Future<void> _reprintReceipt(TodayPaymentItemModel item) async {
    final receiptNumber = item.receiptNumber;

    if (receiptNumber.isEmpty) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('No receipt number found'),
          backgroundColor: AppColors.danger,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

      return;
    }

    setState(() {
      _reprintingId = receiptNumber;
    });

    try {
      if (!_printerService.isConnected) {
        await _showPrinterConnectionDialog();
        return;
      }

      // ============================================================
      // BUILD RECEIPT DETAILS
      // ============================================================

      final classDetail = ReceiptClassDetail(
        className: item.studentClass.className,
        grade: item.grade.name,
        teacherName: item.teacher.name,
        categoryName: item.category.name,
        feeOptionName: item.feeOption.name,
        classFee: item.feeOption.fee,
        receiptNumber: item.receiptNumber,
      );

      // ============================================================
      // PRINT RECEIPT
      // ============================================================

      await PaymentReceiptPrint.printReceipt(
        printerService: _printerService,
        instituteName: AppConfig.instituteName,
        studentName: item.student.initialName,
        studentId: item.student.qrCode,
        paymentMonth: item.paymentMonth,
        paymentMethod: item.paymentMethod,
        classes: [classDetail],
      );

      if (!mounted) return;

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
    } catch (e) {
      if (!mounted) return;

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
    } finally {
      if (!mounted) return;

      setState(() {
        _reprintingId = '';
      });
    }
  }

  /*
  |--------------------------------------------------------------------------
  | Printer Connection Dialog
  |--------------------------------------------------------------------------
  */

  Future<void> _showPrinterConnectionDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
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
                        onPressed: () {
                          Navigator.pop(context);
                        },
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

                          Navigator.pushNamed(
                            context,
                            '/print_test_screen',
                          ).then((_) {
                            _checkPrinterStatus();
                          });
                        },
                        child: const Text('Connect Printer'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /*
  |--------------------------------------------------------------------------
  | Build
  |--------------------------------------------------------------------------
  */

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
              /*
              |--------------------------------------------------------------------------
              | Printer Warning
              |--------------------------------------------------------------------------
              */
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

                          if (mounted) {
                            setState(() {});
                          }
                        },
                        child: const Text(
                          'Connect',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),

              /*
              |--------------------------------------------------------------------------
              | Date Header
              |--------------------------------------------------------------------------
              */
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

              /*
              |--------------------------------------------------------------------------
              | Payment List
              |--------------------------------------------------------------------------
              */
              Expanded(
                child: BlocBuilder<MarkPaymentBloc, MarkPaymentState>(
                  builder: (context, state) {
                    /*
                    |--------------------------------------------------------------------------
                    | Loading
                    |--------------------------------------------------------------------------
                    */

                    if (state is TodayPaymentsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    /*
                    |--------------------------------------------------------------------------
                    | Error
                    |--------------------------------------------------------------------------
                    */

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

                    /*
                    |--------------------------------------------------------------------------
                    | Loaded
                    |--------------------------------------------------------------------------
                    */

                    if (state is TodayPaymentsLoaded) {
                      final payments = state.response.data;

                      /*
                      |--------------------------------------------------------------------------
                      | Empty
                      |--------------------------------------------------------------------------
                      */

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

                      /*
                      |--------------------------------------------------------------------------
                      | Payment List
                      |--------------------------------------------------------------------------
                      */

                      return ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        itemCount: payments.length,
                        itemBuilder: (context, index) {
                          final item = payments[index];

                          return _buildPaymentItem(item);
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

  /*
  |--------------------------------------------------------------------------
  | Payment Item
  |--------------------------------------------------------------------------
  */

  Widget _buildPaymentItem(TodayPaymentItemModel item) {
    final student = item.student;

    final studentClass = item.studentClass;

    final hasImage = student.imgUrl != null && student.imgUrl!.isNotEmpty;

    final isExpanded = _expandedItems.contains(item.paymentId);

    final isReprinting = _reprintingId == item.receiptNumber;

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
          /*
          |--------------------------------------------------------------------------
          | Header
          |--------------------------------------------------------------------------
          */
          InkWell(
            onTap: () {
              _toggleExpanded(item.paymentId);
            },

            borderRadius: BorderRadius.circular(30),

            child: Padding(
              padding: const EdgeInsets.all(18),

              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /*
                      |--------------------------------------------------------------------------
                      | Student Avatar
                      |--------------------------------------------------------------------------
                      */
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: AppColors.primary.withOpacity(.10),

                        backgroundImage: hasImage
                            ? NetworkImage(student.imgUrl!)
                            : null,

                        child: !hasImage
                            ? const Icon(Icons.person, color: AppColors.primary)
                            : null,
                      ),

                      const SizedBox(width: 14),

                      /*
                      |--------------------------------------------------------------------------
                      | Student Details
                      |--------------------------------------------------------------------------
                      */
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              student.initialName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              student.qrCode,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),

                            const SizedBox(height: 2),

                            Text(
                              student.guardianMobile,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),

                      /*
                      |--------------------------------------------------------------------------
                      | Payment Amount / Receipt
                      |--------------------------------------------------------------------------
                      */
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'LKR ${item.amount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.green,
                              fontWeight: FontWeight.w800,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              /*
                              |--------------------------------------------------------------------------
                              | Receipt Number
                              |--------------------------------------------------------------------------
                              */
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(.10),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  item.receiptNumber.isEmpty
                                      ? '-'
                                      : item.receiptNumber,
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 11,
                                  ),
                                ),
                              ),

                              const SizedBox(width: 8),

                              /*
                              |--------------------------------------------------------------------------
                              | Reprint
                              |--------------------------------------------------------------------------
                              */
                              Tooltip(
                                message: 'Reprint Receipt',

                                child: InkWell(
                                  onTap: isReprinting
                                      ? null
                                      : () {
                                          _reprintReceipt(item);
                                        },

                                  borderRadius: BorderRadius.circular(12),

                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: isReprinting
                                        ? const SizedBox(
                                            width: 18,
                                            height: 18,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: AppColors.primary,
                                            ),
                                          )
                                        : const Icon(
                                            Icons.receipt_long_rounded,
                                            size: 18,
                                            color: AppColors.primary,
                                          ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(width: 8),

                      /*
                      |--------------------------------------------------------------------------
                      | Expand Icon
                      |--------------------------------------------------------------------------
                      */
                      Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        color: Colors.grey.shade600,
                        size: 24,
                      ),
                    ],
                  ),

                  /*
                  |--------------------------------------------------------------------------
                  | Class Summary
                  |--------------------------------------------------------------------------
                  */
                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.all(12),

                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                    ),

                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                studentClass.className,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),

                              const SizedBox(height: 3),

                              Text(
                                '${item.grade.name} • ${item.teacher.name}',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),

                          decoration: BoxDecoration(
                            color: AppColors.warning.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),

                          child: Text(
                            item.category.name,
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

          /*
          |--------------------------------------------------------------------------
          | Expanded Details
          |--------------------------------------------------------------------------
          */
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),

            crossFadeState: isExpanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,

            firstChild: Container(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),

              child: Column(
                children: [
                  const Divider(height: 1),

                  const SizedBox(height: 16),

                  /*
                  |--------------------------------------------------------------------------
                  | Payment Details
                  |--------------------------------------------------------------------------
                  */
                  Container(
                    padding: const EdgeInsets.all(16),

                    decoration: BoxDecoration(
                      color: const Color(0xfff8fafc),
                      borderRadius: BorderRadius.circular(22),
                    ),

                    child: Column(
                      children: [
                        _infoRow('Receipt Number', item.receiptNumber),

                        _infoRow(
                          'Payment Amount',
                          'LKR ${item.amount.toStringAsFixed(2)}',
                        ),

                        if (item.discountAmount > 0)
                          _infoRow(
                            'Discount',
                            'LKR ${item.discountAmount.toStringAsFixed(2)}',
                          ),

                        _infoRow(
                          'Payment Method',
                          _formatPaymentMethod(item.paymentMethod),
                        ),

                        _infoRow(
                          'Payment Month',
                          _formatPaymentMonth(item.paymentMonth),
                        ),

                        _infoRow('Paid At', _formatPaidAt(item.paidAt)),

                        _infoRow('Status', item.status),

                        if (item.referenceNumber != null &&
                            item.referenceNumber!.isNotEmpty)
                          _infoRow('Reference', item.referenceNumber!),

                        if (item.markMethod != null &&
                            item.markMethod!.isNotEmpty)
                          _infoRow('Mark Method', item.markMethod!),

                        if (item.note != null && item.note!.isNotEmpty)
                          _infoRow('Note', item.note!),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  /*
                  |--------------------------------------------------------------------------
                  | Student Details
                  |--------------------------------------------------------------------------
                  */
                  Container(
                    padding: const EdgeInsets.all(16),

                    decoration: BoxDecoration(
                      color: const Color(0xfff8fafc),
                      borderRadius: BorderRadius.circular(22),
                    ),

                    child: Column(
                      children: [
                        _sectionTitle('Student Details', Icons.person_rounded),

                        const SizedBox(height: 12),

                        _infoRow('Name', student.initialName),

                        _infoRow('Custom ID', student.qrCode),

                        _infoRow('Mobile', student.mobile),

                        _infoRow('Guardian Mobile', student.guardianMobile),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  /*
                  |--------------------------------------------------------------------------
                  | Class Details
                  |--------------------------------------------------------------------------
                  */
                  Container(
                    padding: const EdgeInsets.all(16),

                    decoration: BoxDecoration(
                      color: const Color(0xfff8fafc),
                      borderRadius: BorderRadius.circular(22),
                    ),

                    child: Column(
                      children: [
                        _sectionTitle('Class Details', Icons.school_rounded),

                        const SizedBox(height: 12),

                        _infoRow('Class', studentClass.className),

                        _infoRow('Category', item.category.name),

                        _infoRow('Grade', item.grade.name),

                        _infoRow('Teacher', item.teacher.name),

                        if (item.teacher.customId.isNotEmpty)
                          _infoRow('Teacher ID', item.teacher.customId),

                        _infoRow('Fee Option', item.feeOption.name),

                        _infoRow(
                          'Fee',
                          'LKR ${item.feeOption.fee.toStringAsFixed(2)}',
                        ),

                        _infoRow(
                          'Free Card',
                          item.enrollment.isFreeCard ? 'Yes' : 'No',
                        ),

                        _infoRow(
                          'Final Fee',
                          'LKR ${item.enrollment.finalFee.toStringAsFixed(2)}',
                        ),

                        _infoRow(
                          'Balance',
                          'LKR ${item.enrollment.balance.toStringAsFixed(2)}',
                        ),

                        if (item.enrollment.paymentStatus != null)
                          _infoRow(
                            'Payment Status',
                            item.enrollment.paymentStatus ?? '',
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
  }

  /*
  |--------------------------------------------------------------------------
  | Section Title
  |--------------------------------------------------------------------------
  */

  Widget _sectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),

        const SizedBox(width: 8),

        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
        ),
      ],
    );
  }

  /*
  |--------------------------------------------------------------------------
  | Info Row
  |--------------------------------------------------------------------------
  */

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

  /*
  |--------------------------------------------------------------------------
  | Payment Method Formatter
  |--------------------------------------------------------------------------
  */

  String _formatPaymentMethod(String value) {
    if (value.isEmpty) {
      return '-';
    }

    return value
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) {
          if (word.isEmpty) return word;

          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
  }

  /*
  |--------------------------------------------------------------------------
  | Payment Month Formatter
  |--------------------------------------------------------------------------
  */

  String _formatPaymentMonth(String value) {
    if (value.isEmpty) {
      return '-';
    }

    try {
      final date = AppDateTime.tryParseServer(value)!;

      return DateFormat('yyyy / MM').format(date);
    } catch (_) {
      if (value.length >= 7) {
        return '${value.substring(0, 4)} / '
            '${value.substring(5, 7)}';
      }

      return value;
    }
  }

  /*
  |--------------------------------------------------------------------------
  | Paid At Formatter
  |--------------------------------------------------------------------------
  */

  String _formatPaidAt(String value) {
    if (value.isEmpty) {
      return '-';
    }

    try {
      final date = AppDateTime.tryParseServer(value)!;

      return DateFormat('yyyy-MM-dd HH:mm').format(date);
    } catch (_) {
      return value;
    }
  }
}
