import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/model/fetch_tute/fetch_tute_request_model.dart';
import '../../data/model/fetch_tute/student_tute_model.dart';
import '../bloc/tute/tute_bloc.dart';

class TuteViewPage extends StatefulWidget {
  final int studentId;
  final int enrollmentId;

  const TuteViewPage({
    super.key,
    required this.studentId,
    required this.enrollmentId,
  });

  @override
  State<TuteViewPage> createState() => _TuteViewPageState();
}

class _TuteViewPageState extends State<TuteViewPage> {
  @override
  void initState() {
    super.initState();

    context.read<TuteBloc>().add(
      LoadAllTuteEvent(
        fetchStudentTuteRequestModel: FetchStudentTuteRequestModel(
          studentId: widget.studentId,
          enrollmentId: widget.enrollmentId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TuteBloc, TuteState>(
      listener: (context, state) {
        if (state is TuteError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },

      child: Scaffold(
        backgroundColor: AppColors.background,

        appBar: AppBar(
          elevation: 0,
          centerTitle: true,

          backgroundColor: AppColors.primary,

          foregroundColor: Colors.white,

          title: const Text(
            'Tute History',

            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),

        body: BlocBuilder<TuteBloc, TuteState>(
          builder: (context, state) {
            // =========================
            // LOADING
            // =========================

            if (state is TuteLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            // =========================
            // ERROR
            // =========================

            if (state is TuteError) {
              return _buildErrorState(state.message);
            }

            // =========================
            // SUCCESS
            // =========================

            if (state is TuteLoaded) {
              final tutes = state.tutes;

              final issuedCount = tutes.where((e) => e.isIssued).length;

              final pendingCount = tutes.where((e) => !e.isIssued).length;

              // =========================
              // EMPTY
              // =========================

              if (tutes.isEmpty) {
                return _buildEmptyState();
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
                              width: 62,
                              height: 62,

                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(.14),

                                borderRadius: BorderRadius.circular(18),
                              ),

                              child: const Icon(
                                Icons.menu_book_rounded,

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
                                    'Student Tute Analytics',

                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  const SizedBox(height: 6),

                                  Text(
                                    '${tutes.length} Tute Records',

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
                              child: _heroCard(
                                title: 'Issued',

                                value: '$issuedCount',

                                icon: Icons.check_circle_rounded,

                                color: Colors.greenAccent,
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: _heroCard(
                                title: 'Pending',

                                value: '$pendingCount',

                                icon: Icons.schedule_rounded,

                                color: Colors.orangeAccent,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // =========================
                  // LIST
                  // =========================
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),

                      itemCount: tutes.length,

                      separatorBuilder: (_, __) => const SizedBox(height: 14),

                      itemBuilder: (context, index) {
                        final tute = tutes[index];

                        return _buildTuteCard(tute);
                      },
                    ),
                  ),
                ],
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  // =========================
  // TUTE CARD
  // =========================

  Widget _buildTuteCard(StudentTuteModel tute) {
    final issuedMonthText = tute.issuedMonth != null
        ? DateFormat('MMMM yyyy').format(DateTime.parse(tute.issuedMonth!))
        : 'Not Selected';

    final issuedAtText = tute.issuedAt != null
        ? DateFormat(
            'yyyy-MM-dd hh:mm a',
          ).format(DateTime.parse(tute.issuedAt!))
        : '-';

    final createdAtText = tute.createdAt != null
        ? DateFormat(
            'yyyy-MM-dd hh:mm a',
          ).format(DateTime.parse(tute.createdAt!))
        : '-';

    final statusColor = tute.isIssued ? Colors.green : Colors.orange;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(30),

        border: Border.all(color: AppColors.border),

        boxShadow: AppColors.softShadow,
      ),

      child: Padding(
        padding: const EdgeInsets.all(18),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // =========================
            // HEADER
            // =========================
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Container(
                  width: 58,
                  height: 58,

                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(.12),

                    borderRadius: BorderRadius.circular(18),
                  ),

                  child: Icon(
                    tute.isIssued
                        ? Icons.menu_book_rounded
                        : Icons.schedule_rounded,

                    color: statusColor,

                    size: 28,
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        issuedMonthText,

                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        'Created: $createdAtText',

                        style: TextStyle(
                          color: Colors.grey.shade600,

                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 8),

                      _badge(
                        icon: Icons.calendar_month_rounded,

                        text: issuedMonthText,

                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),

                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(.12),

                    borderRadius: BorderRadius.circular(999),
                  ),

                  child: Text(
                    tute.isIssued ? 'ISSUED' : 'PENDING',

                    style: TextStyle(
                      color: statusColor,

                      fontWeight: FontWeight.w800,

                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),

            // =========================
            // DETAILS
            // =========================
            const SizedBox(height: 18),

            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: const Color(0xfff8fafc),

                borderRadius: BorderRadius.circular(22),

                border: Border.all(color: AppColors.border),
              ),

              child: Column(
                children: [
                  _detailRow('Issued At', issuedAtText),

                  _detailRow('Issued By', tute.issuedBy?.name ?? '-'),

                  if (tute.note != null && tute.note!.isNotEmpty)
                    _detailRow('Note', tute.note!),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // HERO CARD
  // =========================

  Widget _heroCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.12),

        borderRadius: BorderRadius.circular(22),

        border: Border.all(color: Colors.white.withOpacity(.12)),
      ),

      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,

            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.10),

              borderRadius: BorderRadius.circular(14),
            ),

            child: Icon(icon, color: color, size: 22),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  value,

                  style: const TextStyle(
                    color: Colors.white,

                    fontWeight: FontWeight.w800,

                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 3),

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
          ),
        ],
      ),
    );
  }

  // =========================
  // BADGE
  // =========================

  Widget _badge({
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

  // =========================
  // DETAIL ROW
  // =========================

  Widget _detailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Expanded(
            child: Text(
              title,

              style: TextStyle(
                color: Colors.grey.shade600,

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

  // =========================
  // EMPTY
  // =========================

  Widget _buildEmptyState() {
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
                Icons.menu_book_rounded,
                size: 90,
                color: Colors.grey.shade400,
              ),

              const SizedBox(height: 18),

              Text(
                'No Tute History',

                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.grey.shade800,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'No tute records found for this student.',

                textAlign: TextAlign.center,

                style: TextStyle(color: Colors.grey.shade600, height: 1.4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================
  // ERROR
  // =========================

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),

        child: Container(
          padding: const EdgeInsets.all(28),

          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius: BorderRadius.circular(30),

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

                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),

              const SizedBox(height: 8),

              Text(
                message,

                textAlign: TextAlign.center,

                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
