import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/model/current_card_model.dart';
import '../../data/model/student_card_model.dart';
import '../../data/model/student_card_response_model.dart';
import '../../data/model/student_mini_model.dart';

class RegisterDetailsPage extends StatelessWidget {
  final String qrCode;
  final StudentCardResponseModel studentCardLoaded;

  const RegisterDetailsPage({
    super.key,
    required this.qrCode,
    required this.studentCardLoaded,
  });

  @override
  Widget build(BuildContext context) {
    final student = studentCardLoaded.student;
    final currentCard = studentCardLoaded.currentCard;
    final cards = studentCardLoaded.cards;
    final message = studentCardLoaded.message;

    // Check if current card is inactive
    final isInactive =
        currentCard?.status.toLowerCase() == 'inactive' ||
        message == 'This card is no longer active.';
    final canReAssign = !isInactive && currentCard != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Details'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              // Share functionality
            },
          ),
        ],
      ),
      body: student == null
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_off_outlined,
                    size: 80,
                    color: AppColors.textMuted,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Student details not found',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Profile Header
                  _buildProfileHeader(student, context, currentCard),

                  const SizedBox(height: 24),

                  // Details Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Warning Banner for Inactive Cards
                        if (isInactive) ...[
                          _buildWarningBanner(message, currentCard),
                        ],

                        // Student Information Section
                        _buildSectionHeader(
                          icon: Icons.info_outline,
                          title: 'Student Information',
                        ),
                        const SizedBox(height: 12),

                        _buildDetailCard(
                          icon: Icons.person_outline,
                          title: 'Student Name',
                          subtitle: student.initialName,
                        ),
                        _buildDetailCard(
                          icon: Icons.school_outlined,
                          title: 'Grade',
                          subtitle: student.grade,
                        ),
                        _buildDetailCard(
                          icon: Icons.phone_outlined,
                          title: 'Guardian Mobile',
                          subtitle: student.guardianMobile,
                          isLast: true,
                        ),

                        const SizedBox(height: 24),

                        // Current Card Information Section
                        _buildSectionHeader(
                          icon: Icons.credit_card_outlined,
                          title: 'Current Card Information',
                        ),
                        const SizedBox(height: 12),

                        if (currentCard != null) ...[
                          _buildDetailCard(
                            icon: Icons.confirmation_number_outlined,
                            title: isInactive
                                ? 'Previous Card Number'
                                : 'Card Number',
                            subtitle: currentCard.cardNumber,
                          ),
                          _buildDetailCard(
                            icon: Icons.qr_code_2_outlined,
                            title: isInactive ? 'Previous QR Code' : 'QR Code',
                            subtitle: currentCard.qrCode,
                            isLast: true,
                          ),
                          if (currentCard.issuedAt != null)
                            _buildDetailCard(
                              icon: Icons.calendar_today_outlined,
                              title: 'Issued At',
                              subtitle: _formatDate(currentCard.issuedAt!),
                              isLast: true,
                            ),
                        ] else ...[
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: const Center(
                              child: Text(
                                'No active card assigned',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],

                        const SizedBox(height: 24),

                        // All Cards Section
                        if (cards.isNotEmpty) ...[
                          _buildSectionHeader(
                            icon: Icons.credit_card_rounded,
                            title: 'All Cards (${cards.length})',
                          ),
                          const SizedBox(height: 12),
                          _buildAllCardsList(cards, currentCard),
                        ],

                        const SizedBox(height: 24),

                        // Action Buttons
                        _buildActionButtons(context),

                        const SizedBox(height: 16),

                        // Danger Zone - Only show if card is active
                        if (canReAssign) ...[
                          _buildDangerZone(context, currentCard),
                        ],

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildWarningBanner(String message, CurrentCardModel? currentCard) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.orange),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 4),
                if (currentCard != null) ...[
                  Text(
                    'Current Card : ${currentCard.qrCode}',
                    style: const TextStyle(color: Colors.black87),
                  ),
                  Text(
                    'Card Number : ${currentCard.cardNumber}',
                    style: const TextStyle(color: Colors.black87, fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllCardsList(
    List<StudentCardModel> cards,
    CurrentCardModel? currentCard,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: cards.length,
        separatorBuilder: (context, index) =>
            Divider(height: 1, color: Colors.grey.shade200),
        itemBuilder: (context, index) {
          final card = cards[index];
          final isCurrent = currentCard != null && card.id == currentCard.id;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                // Status Indicator
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isCurrent ? Colors.green : Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),

                // Card Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            card.cardNumber,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.dark,
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (isCurrent)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.green),
                              ),
                              child: const Text(
                                'ACTIVE',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            )
                          else
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.red),
                              ),
                              child: Text(
                                card.status.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'QR: ${card.qrCode}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),

                // Action Button
                if (isCurrent)
                  const Chip(
                    label: Text(
                      'ACTIVE',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    backgroundColor: Colors.green,
                    labelStyle: TextStyle(color: Colors.white),
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  )
                else if (!isCurrent)
                  const Chip(
                    label: Text(
                      'INACTIVE',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    backgroundColor: Colors.grey,
                    labelStyle: TextStyle(color: Colors.white),
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(
    StudentMiniModel student,
    BuildContext context,
    CurrentCardModel? currentCard,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 8),
          // Profile Avatar
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.4),
                width: 4,
              ),
            ),
            child: CircleAvatar(
              radius: 60,
              backgroundImage:
                  (student.imgUrl != null && student.imgUrl!.isNotEmpty)
                  ? NetworkImage(student.imgUrl!)
                  : null,
              child: (student.imgUrl == null || student.imgUrl!.isEmpty)
                  ? const Icon(Icons.person, size: 60, color: Colors.white70)
                  : null,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            student.initialName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              student.grade,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // QR Code Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: QrImageView(
                    data: qrCode,
                    size: 60,
                    backgroundColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Card QR Code',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        qrCode,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.dark,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (currentCard != null)
                        Text(
                          'Status: ${currentCard.status.toUpperCase()}',
                          style: TextStyle(
                            fontSize: 11,
                            color:
                                currentCard.status.toLowerCase() == 'inactive'
                                ? Colors.red
                                : Colors.green,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({required IconData icon, required String title}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 18),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.dark,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String title,
    required String subtitle,
    bool isLast = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.dark,
                  ),
                ),
              ],
            ),
          ),
          if (!isLast)
            const Icon(
              Icons.chevron_right,
              color: AppColors.textMuted,
              size: 20,
            ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back, size: 18),
            label: const Text('Back'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDangerZone(BuildContext context, CurrentCardModel? currentCard) {
    if (currentCard == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.dangerLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.danger.withOpacity(0.3), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.danger.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.delete_outline,
              color: AppColors.danger,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Re Assign Card',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.danger,
                  ),
                ),
                const Text(
                  'This action cannot be undone',
                  style: TextStyle(fontSize: 12, color: AppColors.danger),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              _showReAssignConfirmation(
                context,
                currentCard as StudentCardModel,
              );
            },
            style: TextButton.styleFrom(
              backgroundColor: AppColors.danger,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            child: const Text('Assign'),
          ),
        ],
      ),
    );
  }

  // Helper Methods
  String _formatDate(String dateTimeStr) {
    try {
      final dateTime = DateTime.parse(dateTimeStr.replaceAll(' ', 'T'));
      return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
    } catch (e) {
      return dateTimeStr;
    }
  }

  void _showReAssignConfirmation(BuildContext context, StudentCardModel card) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Re Assign Card'),
        content: Text(
          'Do you want to reassign this student card?\n\n'
          'Current Card: ${card.cardNumber} (${card.qrCode})',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.pushNamed(
                context,
                '/re-assign',
                arguments: {'oldQrCode': qrCode},
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              foregroundColor: Colors.white,
            ),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }
}
