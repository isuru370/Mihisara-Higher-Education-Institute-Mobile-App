import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/session/logout_helper.dart';

class TeacherProfilePage extends StatelessWidget {
  const TeacherProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 30),
          child: Column(
            children: [
              _buildHeader(),

              _buildProfileCard(),

              _buildQuickStats(),

              _buildSection(
                title: 'Personal Information',
                icon: Icons.person_outline_rounded,
                children: [
                  _infoRow(
                    icon: Icons.badge_outlined,
                    label: 'Teacher ID',
                    value: 'TCH001',
                  ),
                  _infoRow(
                    icon: Icons.email_outlined,
                    label: 'Email',
                    value: 'teacher@example.com',
                  ),
                  _infoRow(
                    icon: Icons.phone_outlined,
                    label: 'Mobile',
                    value: '077 123 4567',
                  ),
                  _infoRow(
                    icon: Icons.credit_card_outlined,
                    label: 'NIC',
                    value: '199512345678',
                  ),
                  _infoRow(
                    icon: Icons.cake_outlined,
                    label: 'Birthday',
                    value: '15 March 1995',
                  ),
                  _infoRow(
                    icon: Icons.wc_outlined,
                    label: 'Gender',
                    value: 'Male',
                    showDivider: false,
                  ),
                ],
              ),

              _buildSection(
                title: 'Contact Address',
                icon: Icons.location_on_outlined,
                children: [
                  _infoRow(
                    icon: Icons.home_outlined,
                    label: 'Address',
                    value: 'No. 25, Main Street,\nKalutara, Sri Lanka',
                    showDivider: false,
                  ),
                ],
              ),

              _buildSection(
                title: 'Professional Information',
                icon: Icons.school_outlined,
                children: [
                  _infoRow(
                    icon: Icons.workspace_premium_outlined,
                    label: 'Education',
                    value: 'BSc in Mathematics',
                  ),
                  _infoRow(
                    icon: Icons.work_history_outlined,
                    label: 'Experience',
                    value: '8 Years Experience',
                    showDivider: false,
                  ),
                ],
              ),

              _buildSection(
                title: 'Bank Information',
                icon: Icons.account_balance_outlined,
                children: [
                  _infoRow(
                    icon: Icons.account_balance_outlined,
                    label: 'Bank',
                    value: 'Bank of Ceylon',
                  ),
                  _infoRow(
                    icon: Icons.account_box_outlined,
                    label: 'Account Number',
                    value: '**** **** 4567',
                  ),
                  _infoRow(
                    icon: Icons.location_city_outlined,
                    label: 'Branch',
                    value: 'Kalutara Branch',
                    showDivider: false,
                  ),
                ],
              ),

              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppColors.paddingLarge,
        20,
        AppColors.paddingLarge,
        18,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Account',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'My Profile',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppColors.radiusMedium,
              border: Border.all(color: AppColors.border),
            ),
            child: IconButton(
              onPressed: () {
                // TODO: Open edit profile
              },
              icon: const Icon(
                Icons.edit_outlined,
                color: AppColors.primary,
                size: 21,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PROFILE CARD
  // ============================================================

  Widget _buildProfileCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppColors.paddingLarge),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: AppColors.radiusLarge,
          boxShadow: AppColors.mediumShadow,
        ),
        child: Row(
          children: [
            // Profile Avatar
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Center(
                child: Text(
                  'AF',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Achintha Isuru Fernando',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 5),

                  const Text(
                    'Mathematics Teacher',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.14),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.circle, size: 7, color: Colors.white),
                        SizedBox(width: 6),
                        Text(
                          'Active Teacher',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
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
      ),
    );
  }

  // ============================================================
  // QUICK STATS
  // ============================================================

  Widget _buildQuickStats() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppColors.paddingLarge,
        16,
        AppColors.paddingLarge,
        8,
      ),
      child: Row(
        children: [
          Expanded(
            child: _statCard(
              icon: Icons.menu_book_rounded,
              value: '04',
              label: 'Classes',
              color: AppColors.primary,
              background: AppColors.primaryLight,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: _statCard(
              icon: Icons.groups_rounded,
              value: '185',
              label: 'Students',
              color: AppColors.info,
              background: AppColors.infoLight,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: _statCard(
              icon: Icons.workspace_premium_rounded,
              value: '08',
              label: 'Years',
              color: AppColors.success,
              background: AppColors.successLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
    required Color background,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppColors.radiusMedium,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, size: 18, color: color),
          ),

          const SizedBox(height: 8),

          Text(
            value,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 2),

          Text(
            label,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w500,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SECTION
  // ============================================================

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppColors.paddingLarge,
        18,
        AppColors.paddingLarge,
        0,
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppColors.radiusMedium,
          border: Border.all(color: AppColors.border),
          boxShadow: AppColors.softShadow,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 15, 16, 13),
              child: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Icon(icon, size: 18, color: AppColors.primary),
                  ),

                  const SizedBox(width: 10),

                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, color: AppColors.divider),

            ...children,
          ],
        ),
      ),
    );
  }

  // ============================================================
  // INFO ROW
  // ============================================================

  Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 19, color: AppColors.iconSecondary),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textMuted,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        if (showDivider)
          const Padding(
            padding: EdgeInsets.only(left: 47),
            child: Divider(height: 1, color: AppColors.divider),
          ),
      ],
    );
  }

  // ============================================================
  // ACTION BUTTONS
  // ============================================================

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppColors.paddingLarge,
        20,
        AppColors.paddingLarge,
        0,
      ),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton.icon(
              onPressed: () {
                // TODO: Change password
              },
              icon: const Icon(Icons.lock_outline_rounded, size: 19),
              label: const Text(
                'Change Password',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.border),
                backgroundColor: AppColors.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: AppColors.radiusMedium,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton.icon(
              onPressed: () => confirmLogout(context),
              icon: const Icon(Icons.logout_rounded, size: 19),
              label: const Text(
                'Logout',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.danger,
                side: const BorderSide(color: AppColors.dangerLight),
                backgroundColor: AppColors.dangerLight,
                shape: RoundedRectangleBorder(
                  borderRadius: AppColors.radiusMedium,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
