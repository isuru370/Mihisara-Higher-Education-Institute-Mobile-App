import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/printer_service.dart';
import '../../../qr/data/model/read_payment/read_student_class_payment_model.dart';
import '../../../qr/presentation/bloc/read_payment/read_payment_bloc.dart';
import '../../data/models/mark_payment_request_model.dart';
import '../bloc/mark_payment/mark_payment_bloc.dart';
import 'utils/payment_discount_calculator.dart';
import 'utils/payment_receipt_print.dart';

class PaymentPage extends StatefulWidget {
  final String? markMethod;
  final ReadPaymentLoaded paymentState;

  const PaymentPage({super.key, required this.paymentState, this.markMethod});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final PrinterService _printerService = PrinterService();
  final Set<int> _selectedenrollmentIds = <int>{};
  DateTime _selectedPaymentDate = DateTime.now();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final response = widget.paymentState.response;
    final data = response.data;

    if (data == null) {
      return const Scaffold(body: Center(child: Text('No student data found')));
    }

    return BlocListener<MarkPaymentBloc, MarkPaymentState>(
      listener: (context, state) async {
        if (!mounted) return;

        if (state is MarkPaymentLoading) {
          setState(() {
            _isSubmitting = true;
          });
        } else if (state is MarkPaymentLoaded) {

          await Future.delayed(const Duration(seconds: 3));

          setState(() {
            _isSubmitting = false;
            _selectedenrollmentIds.clear();
          });

          try {
            final receipt = state.response.receipt;
            final student = state.response.student;

            await PaymentReceiptPrint.printBulkReceipt(
              printerService: _printerService,
              instituteName: 'Minipalasa Education Centre',
              studentName: student.name,
              studentId: student.customId,
              paymentMonth: receipt.paymentMonth,
              items: receipt.items.map((item) {
                return PaymentReceiptItem(
                  className: item.className,
                  subject: item.subject,
                  categoryName: item.categoryName,
                  grade: item.grade,
                  teacherInitials: item.teacher,
                  amount: item.amount,
                );
              }).toList(),
              totalFee: receipt.totalFee,
              discountAmount: receipt.discountAmount,
              payableTotal: receipt.payableTotal,
            );

            context.read<MarkPaymentBloc>().add(const ResetMarkPayment());

          } catch (e) {
            if (!mounted) return;

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.orange,
                content: Text('Receipt print failed: $e'),
              ),
            );

            return;
          }

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.green,
              content: Text('Payments saved successfully'),
            ),
          );

          Future.delayed(const Duration(milliseconds: 900), () {
            if (!mounted) return;
            Navigator.pop(context);
          });
        } else if (state is MarkPaymentError) {
          setState(() {
            _isSubmitting = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(backgroundColor: Colors.red, content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text(
            'Student Payments',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: SafeArea(
          child: Column(
            children: [
              // STUDENT HEADER
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppColors.heroGradient,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: AppColors.largeShadow,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 34,
                      backgroundColor: Colors.white,
                      backgroundImage:
                          data.student.imgUrl != null &&
                              data.student.imgUrl!.isNotEmpty
                          ? NetworkImage(data.student.imgUrl!)
                          : null,
                      child:
                          data.student.imgUrl == null ||
                              data.student.imgUrl!.isEmpty
                          ? const Icon(
                              Icons.person_rounded,
                              size: 32,
                              color: AppColors.primary,
                            )
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.student.initialName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Student ID: ${data.student.customId}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Mobile: ${data.student.guardianMobile}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: data.classes.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.payments_outlined,
                              size: 80,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 14),
                            Text(
                              'No Classes Available',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'This student has no active class enrollments.',
                              style: TextStyle(color: Colors.grey.shade500),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        itemCount: data.classes.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final payment = data.classes[index];
                          final latestPayment = payment.lastPayment;
                          final isSelected = _selectedenrollmentIds.contains(
                            payment.enrollmentId,
                          );

                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.border,
                                width: isSelected ? 2 : 1,
                              ),
                              boxShadow: AppColors.softShadow,
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(28),
                              onTap: payment.isFreeCard
                                  ? null
                                  : () {
                                      setState(() {
                                        if (isSelected) {
                                          _selectedenrollmentIds.remove(
                                            payment.enrollmentId,
                                          );
                                        } else {
                                          _selectedenrollmentIds.add(
                                            payment.enrollmentId,
                                          );
                                        }
                                      });
                                    },
                              child: Padding(
                                padding: const EdgeInsets.all(18),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                payment.className,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w800,
                                                  color: AppColors.dark,
                                                ),
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                payment.subject,
                                                style: TextStyle(
                                                  color: Colors.grey.shade600,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Checkbox(
                                          value: isSelected,
                                          activeColor: AppColors.primary,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                          onChanged: payment.isFreeCard
                                              ? null
                                              : (value) {
                                                  setState(() {
                                                    if (value == true) {
                                                      _selectedenrollmentIds
                                                          .add(
                                                            payment
                                                                .enrollmentId,
                                                          );
                                                    } else {
                                                      _selectedenrollmentIds
                                                          .remove(
                                                            payment
                                                                .enrollmentId,
                                                          );
                                                    }
                                                  });
                                                },
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Wrap(
                                      spacing: 2,
                                      runSpacing: 2,
                                      children: [
                                        _premiumBadge(
                                          icon: Icons.category_rounded,
                                          text: payment.categoryName,
                                          color: Colors.orange,
                                        ),
                                        _premiumBadge(
                                          icon: Icons.school_rounded,
                                          text: 'Grade ${payment.grade}',
                                          color: Colors.purple,
                                        ),
                                        _premiumBadge(
                                          icon: Icons.payments_rounded,
                                          text: payment.isFreeCard
                                              ? 'Free Card'
                                              : 'LKR ${payment.finalFee}',
                                          color: Colors.blue,
                                        ),
                                        _premiumBadge(
                                          icon: Icons.person_rounded,
                                          text: payment.teacherInitials,
                                          color: Colors.green,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 18),
                                    if (!payment.isFreeCard)
                                      latestPayment != null
                                          ? Container(
                                              width: double.infinity,
                                              padding: const EdgeInsets.all(14),
                                              decoration: BoxDecoration(
                                                color: const Color(0xfff8fafc),
                                                borderRadius:
                                                    BorderRadius.circular(18),
                                                border: Border.all(
                                                  color: AppColors.border,
                                                ),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'Latest Payment',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    'Amount: LKR ${latestPayment.amount}',
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    'Month: ${latestPayment.paymentMonth}',
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Text(
                                              'No payments made yet.',
                                              style: TextStyle(
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),

              Container(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                decoration: const BoxDecoration(color: Colors.white),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isSubmitting || _selectedenrollmentIds.isEmpty
                        ? null
                        : () => _showPayDialog(data.classes),
                    icon: _isSubmitting
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.payments_rounded),
                    label: Text(
                      _isSubmitting
                          ? 'Processing...'
                          : 'Pay ${_selectedenrollmentIds.length} Selected Class(es)',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showPayDialog(
    List<ReadStudentClassPaymentModel> classes,
  ) async {
    final selectedPayments = classes
        .where((item) => _selectedenrollmentIds.contains(item.enrollmentId))
        .where((item) => item.isFreeCard == false)
        .toList();

    if (selectedPayments.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one payable class'),
        ),
      );
      return;
    }

    DateTime tempSelectedDate = _selectedPaymentDate;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final discount = PaymentDiscountCalculator.calculate(
              selectedPayments: selectedPayments,
              minimumClassesForDiscount: 5,
              discountRate: 0.10,
            );

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              titlePadding: EdgeInsets.zero,
              contentPadding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
              actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              title: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
                child: const Text(
                  'Confirm Payment',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _dialogSummaryRow(
                      'Selected Classes',
                      discount.selectedCount.toString(),
                    ),
                    _dialogSummaryRow(
                      'Total Fee',
                      'LKR ${discount.totalFee.toStringAsFixed(2)}',
                    ),
                    _dialogSummaryRow(
                      'Discount',
                      discount.discountApplied
                          ? 'LKR ${discount.discountAmount.toStringAsFixed(2)}'
                          : 'LKR 0.00 (Need 5 or more classes)',
                    ),
                    _dialogSummaryRow(
                      'Payable',
                      'LKR ${discount.payableTotal.toStringAsFixed(2)}',
                      bold: true,
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () async {
                        final picked = await showMonthYearPicker(
                          context: dialogContext,
                          initialDate: tempSelectedDate,
                          firstDate: DateTime.now().subtract(
                            const Duration(days: 365 * 5),
                          ),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365 * 5),
                          ),
                        );

                        if (picked != null) {
                          setDialogState(() {
                            tempSelectedDate = picked;
                          });
                        }
                      },
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Payment Month',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          DateFormat('yyyy-MM').format(tempSelectedDate),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Discount applies only when 5 or more classes are selected.',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: _isSubmitting
                      ? null
                      : () {
                          setState(() {
                            _selectedPaymentDate = tempSelectedDate;
                          });

                          Navigator.pop(dialogContext);
                          _submitBulkPayments(classes);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text('Pay Now'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _submitBulkPayments(List<ReadStudentClassPaymentModel> classes) {
    final selectedPayments = classes
        .where((item) => _selectedenrollmentIds.contains(item.enrollmentId))
        .where((item) => item.isFreeCard == false)
        .toList();

    if (selectedPayments.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one payable class'),
        ),
      );
      return;
    }

    final discount = PaymentDiscountCalculator.calculate(
      selectedPayments: selectedPayments,
      minimumClassesForDiscount: 5,
      discountRate: 0.10,
    );

    final studentId = widget.paymentState.response.data!.student.id;

    final request = MarkPaymentRequestModel(
      payments: selectedPayments.map((item) {
        final finalAmount =
            item.finalFee.toDouble() - discount.perClassDiscount;

        return MarkPaymentItemModel(
          studentId: studentId,
          studentClassEnrollmentId: item.enrollmentId,
          amount: finalAmount,
          discountAmount: discount.perClassDiscount,
          paymentMonth: DateFormat('yyyy-MM').format(_selectedPaymentDate),
          paidAt: DateTime.now(),
          markMethod: widget.markMethod ?? 'manual_web',
          note:
              'Student Name ${widget.paymentState.response.data!.student.initialName} | ${item.className} | ${item.categoryName} | Teacher ${item.teacherInitials} | Bulk payment ${discount.discountApplied ? 'with 10% discount' : 'without discount'}',
        );
      }).toList(),
    );

    context.read<MarkPaymentBloc>().add(
      MarkPaymentRequested(requestModel: request),
    );
  }

  Widget _premiumBadge({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _dialogSummaryRow(String title, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            value,
            style: TextStyle(
              fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
