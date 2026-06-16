import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/printer_service.dart';
import '../../../admission/presentaion/bloc/admission/admission_bloc.dart';
import '../../../students/presentaion/pages/create_student_page.dart';
import '../../../students/presentaion/widgets/admission_dialog.dart';
import '../../../students/presentaion/widgets/admission_receipt_print.dart';
import '../../data/model/payment/admission_payment_model.dart';
import '../../data/model/payment/admission_unpaid_student_model.dart';
import '../../data/model/store/admission_payment_request_model.dart';

class AdmissionPaymentPage extends StatefulWidget {
  const AdmissionPaymentPage({super.key});

  @override
  State<AdmissionPaymentPage> createState() => _AdmissionPaymentPageState();
}

class _AdmissionPaymentPageState extends State<AdmissionPaymentPage> {
  final PrinterService _printerService = PrinterService();
  int? _selectedAdmissionId;
  bool _isReprinting = false;

  // Search controller and state
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<AdmissionUnpaidStudentModel> _filteredUnpaidStudents = [];

  @override
  void initState() {
    super.initState();
    context.read<AdmissionBloc>().add(FetchAdmissionPaymentDataEvent());
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  void _filterUnpaidStudents(List<AdmissionUnpaidStudentModel> students) {
    if (_searchQuery.isEmpty) {
      _filteredUnpaidStudents = students;
    } else {
      _filteredUnpaidStudents = students.where((student) {
        return student.name.toLowerCase().contains(_searchQuery) ||
            student.customId.toLowerCase().contains(_searchQuery) ||
            student.guardianMobile.contains(_searchQuery) ||
            student.grade.toString().contains(_searchQuery);
      }).toList();
    }
  }

  Future<void> _reprintReceipt(AdmissionPaymentModel payment) async {
    setState(() {
      _isReprinting = true;
    });

    try {
      if (_printerService.isConnected) {
        await AdmissionReceiptPrint.printReceipt(
          printerService: _printerService,
          instituteName: 'Minipalasa Education Center',
          receiptNumber: payment.receiptNumber,
          studentName: payment.studentName,
          studentId: payment.studentCode,
          admissionName: payment.admissionName,
          amount: double.parse(payment.amount),
          paymentMethod: payment.paymentMethod,
          paidAt: payment.paidAt,
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
      } else {
        // Show printer connection dialog
        _showPrinterConnectionDialog();
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
          _isReprinting = false;
        });
      }
    }
  }

  void _showPrinterConnectionDialog() {
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
                        Navigator.pushNamed(context, '/print_test_screen');
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

  Future<void> _showAdmissionDialog(AdmissionUnpaidStudentModel student) async {
    final result = await showDialog<AdmissionDialogResult>(
      context: context,
      builder: (_) => const AdmissionDialog(),
    );

    if (result == null) return;

    setState(() {
      _selectedAdmissionId = result.admissionId;
    });

    context.read<AdmissionBloc>().add(
      StoreAdmissionPaymentEvent(
        request: AdmissionPaymentRequestModel(
          studentId: student.id,
          admissionId: _selectedAdmissionId!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdmissionBloc, AdmissionState>(
      listener: (context, state) async {
        if (state is AdmissionPaymentStored) {
          final payment = state.response.admissionPayment;
          if (payment == null) return;

          try {
            if (_printerService.isConnected) {
              await AdmissionReceiptPrint.printReceipt(
                printerService: _printerService,
                instituteName: 'Minipalasa Education Center',
                receiptNumber: payment.receiptNumber,
                studentName: state.response.student.initialName,
                studentId: state.response.student.customId.toString(),
                admissionName: payment.admissionName,
                amount: double.parse(payment.amount),
                paymentMethod: payment.paymentMethod,
                paidAt: payment.paidAt,
              );
            }

            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Admission Payment Saved Successfully'),
                  backgroundColor: AppColors.success,
                ),
              );
            }

            context.read<AdmissionBloc>().add(FetchAdmissionPaymentDataEvent());
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Print failed: $e')));
            }
          }
        }
      },
      builder: (context, state) {
        if (state is AdmissionLoading || state is AdmissionPaymentStoring) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              title: const Text('Admission Payments'),
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state is AdmissionPaymentLoaded) {
          final data = state.paymentData;

          // Update filtered students when data changes
          _filterUnpaidStudents(data.unpaidStudents);

          return DefaultTabController(
            length: 2,
            child: Scaffold(
              backgroundColor: AppColors.background,
              appBar: AppBar(
                elevation: 0,
                centerTitle: true,
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                title: const Text(
                  'Admission Payments',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(48),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: TabBar(
                      indicator: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white70,
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                      tabs: const [
                        Tab(text: 'PAID'),
                        Tab(text: 'UNPAID'),
                      ],
                    ),
                  ),
                ),
              ),
              body: Column(
                children: [
                  // SUMMARY CARDS
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _summaryCard(
                            title: 'Total',
                            value: data.summary.totalCount.toString(),
                            icon: Icons.people_rounded,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _summaryCard(
                            title: 'Paid',
                            value: data.summary.paidCount.toString(),
                            icon: Icons.check_circle_rounded,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _summaryCard(
                            title: 'Unpaid',
                            value: data.summary.unpaidCount.toString(),
                            icon: Icons.pending_rounded,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // TAB CONTENT
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildPaidTab(data.paidStudents),
                        _buildUnpaidTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is AdmissionError) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              title: const Text('Admission Payments'),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AdmissionBloc>().add(
                        FetchAdmissionPaymentDataEvent(),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            title: const Text('Admission Payments'),
          ),
          body: const Center(child: Text('No Data Found')),
        );
      },
    );
  }

  Widget _summaryCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withOpacity(0.18)),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaidTab(List<AdmissionPaymentModel> payments) {
    if (payments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No Paid Admissions',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: payments.length,
      itemBuilder: (context, index) {
        final payment = payments[index];
        return _buildPaidCard(payment);
      },
    );
  }

  Widget _buildPaidCard(AdmissionPaymentModel payment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: AppColors.softShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER ROW
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        payment.studentName.isEmpty ? '-' : payment.studentName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        payment.studentCode,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        payment.admissionName,
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            // STATUS CHIP AND REPRINT BUTTON ROW
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _statusChip(
                      text: payment.status.toUpperCase(),
                      color: AppColors.success,
                    ),
                  ],
                ),
                // Reprint Button
                Tooltip(
                  message: 'Reprint Receipt',
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      onPressed: _isReprinting
                          ? null
                          : () => _reprintReceipt(payment),
                      icon: _isReprinting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.primary,
                              ),
                            )
                          : const Icon(
                              Icons.receipt_long_rounded,
                              color: AppColors.primary,
                              size: 22,
                            ),
                      tooltip: 'Reprint Receipt',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            // PAYMENT DETAILS
            Row(
              children: [
                Expanded(
                  child: _paymentCard(
                    title: 'Amount',
                    value: 'LKR ${payment.amount}',
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _paymentCard(
                    title: 'Receipt No',
                    value: payment.receiptNumber,
                    color: AppColors.warning,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Paid Date : ${payment.formattedPaidAt}',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnpaidTab() {
    if (_filteredUnpaidStudents.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _searchQuery.isEmpty
                  ? Icons.pending_actions_outlined
                  : Icons.search_off_rounded,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isEmpty
                  ? 'No Unpaid Admissions'
                  : 'No results found for "$_searchQuery"',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
            ),
            if (_searchQuery.isNotEmpty) ...[
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  _searchController.clear();
                },
                child: const Text('Clear Search'),
              ),
            ],
          ],
        ),
      );
    }

    return Column(
      children: [
        // Search Bar
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: AppColors.softShadow,
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by name, ID, grade or phone...',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: Colors.grey.shade500,
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.close_rounded,
                          color: Colors.grey.shade500,
                        ),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ),
        ),

        // Results count
        if (_filteredUnpaidStudents.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${_filteredUnpaidStudents.length} student${_filteredUnpaidStudents.length != 1 ? 's' : ''} found',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

        // List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _filteredUnpaidStudents.length,
            itemBuilder: (context, index) {
              final student = _filteredUnpaidStudents[index];
              return _buildUnpaidCard(student);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildUnpaidCard(AdmissionUnpaidStudentModel student) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: AppColors.softShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.danger.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: AppColors.danger,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.black87,
                          ),
                          children: _highlightText(student.name, _searchQuery),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        student.customId,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Grade ${student.grade}',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            // CONTACT INFO
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Row(
                children: [
                  Icon(Icons.phone_rounded, size: 18, color: AppColors.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                        children: _highlightText(
                          student.guardianMobile,
                          _searchQuery,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            // PAY BUTTON
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () => _showAdmissionDialog(student),
                child: const Text(
                  'PAY NOW',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to highlight search text
  List<TextSpan> _highlightText(String text, String query) {
    if (query.isEmpty || !text.toLowerCase().contains(query)) {
      return [TextSpan(text: text)];
    }

    final List<TextSpan> spans = [];
    final String lowerText = text.toLowerCase();
    final String lowerQuery = query.toLowerCase();
    int start = 0;
    int index;

    while ((index = lowerText.indexOf(lowerQuery, start)) != -1) {
      if (index > start) {
        spans.add(TextSpan(text: text.substring(start, index)));
      }
      spans.add(
        TextSpan(
          text: text.substring(index, index + query.length),
          style: const TextStyle(
            backgroundColor: AppColors.warning,
            color: Colors.white,
          ),
        ),
      );
      start = index + query.length;
    }

    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start)));
    }

    return spans;
  }

  Widget _statusChip({required String text, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _paymentCard({
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
