import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/payment_history/payment_history_request_model.dart';
import '../bloc/mark_payment/mark_payment_bloc.dart';

class PaymentHistoryViewPage extends StatefulWidget {
  final int studentId;
  final int enrollmentId;

  const PaymentHistoryViewPage({
    super.key,
    required this.studentId,
    required this.enrollmentId,
  });

  @override
  State<PaymentHistoryViewPage> createState() => _PaymentHistoryViewPageState();
}

class _PaymentHistoryViewPageState extends State<PaymentHistoryViewPage> {
  @override
  void initState() {
    super.initState();

    context.read<MarkPaymentBloc>().add(
      PaymentHistoryRequested(
        requestModel: PaymentHistoryRequestModel(
          studentId: widget.studentId,
          enrollmentId: widget.enrollmentId,
        ),
      ),
    );
  }

  String _formatDate(String value) {
    try {
      return DateFormat(
        'yyyy-MM-dd hh:mm a',
      ).format(DateTime.parse(value).toLocal());
    } catch (_) {
      return value;
    }
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
          'Payment History',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),

      body: BlocBuilder<MarkPaymentBloc, MarkPaymentState>(
        builder: (context, state) {
          // =========================
          // LOADING
          // =========================

          if (state is PaymentHistoryLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // =========================
          // ERROR
          // =========================

          if (state is PaymentHistoryError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),

                child: Container(
                  padding: const EdgeInsets.all(28),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: AppColors.softShadow,
                  ),

                  child: Column(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        size: 80,
                        color: Colors.red.shade400,
                      ),

                      const SizedBox(height: 16),

                      const Text(
                        'Something went wrong',

                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        state.message,

                        textAlign: TextAlign.center,

                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          // =========================
          // SUCCESS
          // =========================

          if (state is PaymentHistoryLoaded) {
            final monthlyView = state.response.data;

            final totalPaid = monthlyView.fold<double>(
              0,
              (sum, month) => sum + month.totalAmount,
            );

            final totalDiscount = monthlyView.fold<double>(
              0,
              (sum, month) => sum + month.totalDiscountAmount,
            );

            final totalPayments = monthlyView.fold<int>(
              0,
              (sum, month) => sum + month.count,
            );

            // =========================
            // EMPTY STATE
            // =========================

            if (monthlyView.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),

                  child: Container(
                    padding: const EdgeInsets.all(30),

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: AppColors.softShadow,
                    ),

                    child: Column(
                      mainAxisSize: MainAxisSize.min,

                      children: [
                        Icon(
                          Icons.history_toggle_off_rounded,
                          size: 90,
                          color: Colors.grey.shade400,
                        ),

                        const SizedBox(height: 18),

                        Text(
                          'No Payment History',

                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Colors.grey.shade800,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          'This student has no recorded payments yet.',

                          textAlign: TextAlign.center,

                          style: TextStyle(
                            color: Colors.grey.shade600,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            return Column(
              children: [
                // =========================
                // HERO SECTION
                // =========================
                Container(
                  margin: const EdgeInsets.all(16),

                  padding: const EdgeInsets.all(22),

                  decoration: BoxDecoration(
                    gradient: AppColors.heroGradient,

                    borderRadius: BorderRadius.circular(32),

                    boxShadow: AppColors.largeShadow,
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Row(
                        children: [
                          Container(
                            height: 62,
                            width: 62,

                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(.14),

                              borderRadius: BorderRadius.circular(18),
                            ),

                            child: const Icon(
                              Icons.receipt_long_rounded,
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
                                  'Payment Analytics',

                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),

                                const SizedBox(height: 6),

                                Text(
                                  '$totalPayments Payments Recorded',

                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 22),

                      Row(
                        children: [
                          Expanded(
                            child: _heroSummaryCard(
                              title: 'Total Paid',
                              value: 'LKR ${totalPaid.toStringAsFixed(2)}',
                              icon: Icons.payments_rounded,
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: _heroSummaryCard(
                              title: 'Discount',
                              value: 'LKR ${totalDiscount.toStringAsFixed(2)}',
                              icon: Icons.discount_rounded,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // =========================
                // MONTH LIST
                // =========================
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),

                    itemCount: monthlyView.length,

                    separatorBuilder: (_, __) => const SizedBox(height: 14),

                    itemBuilder: (context, index) {
                      final month = monthlyView[index];

                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,

                          borderRadius: BorderRadius.circular(30),

                          border: Border.all(color: AppColors.border),

                          boxShadow: AppColors.softShadow,
                        ),

                        child: Theme(
                          data: Theme.of(
                            context,
                          ).copyWith(dividerColor: Colors.transparent),

                          child: ExpansionTile(
                            tilePadding: const EdgeInsets.all(20),

                            childrenPadding: const EdgeInsets.fromLTRB(
                              20,
                              0,
                              20,
                              20,
                            ),

                            title: Text(
                              month.monthName.isNotEmpty
                                  ? month.monthName
                                  : month.month,

                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: AppColors.dark,
                              ),
                            ),

                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 8),

                              child: Wrap(
                                spacing: 10,
                                runSpacing: 10,

                                children: [
                                  _miniBadge(
                                    Icons.payments_rounded,
                                    'LKR ${month.totalAmount.toStringAsFixed(2)}',
                                    Colors.green,
                                  ),

                                  _miniBadge(
                                    Icons.discount_rounded,
                                    'LKR ${month.totalDiscountAmount.toStringAsFixed(2)}',
                                    Colors.orange,
                                  ),

                                  _miniBadge(
                                    Icons.receipt_long_rounded,
                                    '${month.count} Payments',
                                    AppColors.primary,
                                  ),
                                ],
                              ),
                            ),

                            children: month.payments.map((payment) {
                              return Container(
                                margin: const EdgeInsets.only(top: 14),

                                padding: const EdgeInsets.all(16),

                                decoration: BoxDecoration(
                                  color: const Color(0xfff8fafc),

                                  borderRadius: BorderRadius.circular(22),

                                  border: Border.all(color: AppColors.border),
                                ),

                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 46,
                                          width: 46,

                                          decoration: BoxDecoration(
                                            color: AppColors.primary
                                                .withOpacity(.10),

                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                          ),

                                          child: const Icon(
                                            Icons.payments_rounded,
                                            color: AppColors.primary,
                                          ),
                                        ),

                                        const SizedBox(width: 14),

                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,

                                            children: [
                                              Text(
                                                payment.receiptNumber,

                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 15,
                                                ),
                                              ),

                                              const SizedBox(height: 4),

                                              Text(
                                                _formatDate(payment.paidAt),

                                                style: TextStyle(
                                                  color: Colors.grey.shade600,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        Text(
                                          'LKR ${payment.amount.toStringAsFixed(2)}',

                                          style: const TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 17,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 16),

                                    Row(
                                      children: [
                                        Expanded(
                                          child: _detailBox(
                                            'Method',
                                            payment.markMethod,
                                          ),
                                        ),

                                        const SizedBox(width: 10),

                                        Expanded(
                                          child: _detailBox(
                                            'Discount',
                                            'LKR ${payment.discountAmount.toStringAsFixed(2)}',
                                          ),
                                        ),
                                      ],
                                    ),

                                    if (payment.note.isNotEmpty) ...[
                                      const SizedBox(height: 12),

                                      Container(
                                        width: double.infinity,

                                        padding: const EdgeInsets.all(14),

                                        decoration: BoxDecoration(
                                          color: Colors.white,

                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),

                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,

                                          children: [
                                            Text(
                                              'Payment Note',

                                              style: TextStyle(
                                                color: Colors.grey.shade700,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),

                                            const SizedBox(height: 6),

                                            Text(
                                              payment.note,

                                              style: TextStyle(
                                                color: Colors.grey.shade700,
                                                height: 1.4,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _heroSummaryCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.12),

        borderRadius: BorderRadius.circular(22),

        border: Border.all(color: Colors.white.withOpacity(.12)),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Icon(icon, color: Colors.white, size: 22),

          const SizedBox(height: 14),

          Text(
            value,

            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            title,

            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniBadge(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),

      decoration: BoxDecoration(
        color: color.withOpacity(.10),

        borderRadius: BorderRadius.circular(999),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          Icon(icon, size: 14, color: color),

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

  Widget _detailBox(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(16),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            title,

            style: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            value,

            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.dark,
            ),
          ),
        ],
      ),
    );
  }
}
