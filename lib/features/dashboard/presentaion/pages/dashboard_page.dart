import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexorait_education_app/core/enums/scan_type.dart';

import '../../../../core/storage/session_storage.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/printer_service.dart';
import '../../../auth/data/models/user_model.dart';
import '../bloc/mobile_dashboard/mobile_dashboard_bloc.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String? _token;
  UserModel? _user;
  bool _showPrinterBanner = false;

  bool _loadingSession = true;

  @override
  void initState() {
    super.initState();

    _loadSession();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      context.read<MobileDashboardBloc>().add(GetMobileDashboardEvent());

      await _checkPrinterStatus();
    });
  }

  Future<void> _checkPrinterStatus() async {
    final printerService = PrinterService();

    if (printerService.isConnected) {
      if (mounted) {
        setState(() {
          _showPrinterBanner = false;
        });
      }
      return;
    }

    final connected = await printerService.autoReconnect();

    if (!mounted) return;

    setState(() {
      _showPrinterBanner = !connected;
    });

    if (!connected) {
      _showPrinterSuggestionDialog();
    }
  }

  Future<void> _loadSession() async {
    final token = await SessionStorage.getToken();

    final user = await SessionStorage.getUser();

    if (!mounted) return;

    setState(() {
      _token = token;
      _user = user;
      _loadingSession = false;
    });
  }

  Future<void> _refreshDashboard() async {
    context.read<MobileDashboardBloc>().add(GetMobileDashboardEvent());

    await _loadSession();
  }

  Future<void> _logout() async {
    await SessionStorage.clear();

    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  String _money(dynamic value) {
    if (value == null) return '-';

    final text = value.toString();

    if (text.trim().isEmpty) {
      return '-';
    }

    return text;
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return 'Good Morning 👋';
    }

    if (hour < 17) {
      return 'Good Afternoon ☀️';
    }

    return 'Good Evening 🌙';
  }

  void _showPrinterSuggestionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
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
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.print_rounded,
                    size: 48,
                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'Printer Not Connected',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.dark,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  'No printer is currently connected.\n\n'
                  'Connect your Bluetooth printer now to print payment receipts and reports instantly.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    height: 1.5,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 24),

                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: Colors.orange.shade700,
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'You can continue using the app without a printer.',
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () async {
                          await Navigator.pushNamed(
                            context,
                            '/print_test_screen',
                          );

                          await _checkPrinterStatus();
                        },
                        child: const Text('Connect'),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/print_test_screen');
                        },
                        icon: const Icon(Icons.bluetooth_rounded),
                        label: const Text(
                          'Connect',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
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

  @override
  Widget build(BuildContext context) {
    final userName = _user?.name ?? 'Guest User';

    final userEmail = _user?.email ?? 'No Email';

    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.background,

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,

        onPressed: () {
          Navigator.pushNamed(
            context,
            '/qr-scan',
            arguments: {'type': ScanType.student},
          );
        },

        icon: const Icon(Icons.qr_code_scanner_rounded, color: Colors.white),

        label: const Text(
          'Search Student',

          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),

      appBar: AppBar(
        elevation: 0,

        backgroundColor: AppColors.primary,

        title: const Text(
          'Dashboard',

          style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white),
        ),

        iconTheme: const IconThemeData(color: Colors.white),

        actions: [
          IconButton(
            onPressed: _refreshDashboard,

            icon: const Icon(Icons.refresh_rounded),
          ),

          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/print_test_screen');
            },
            icon: Icon(Icons.print_rounded),
          ),
          IconButton(
            onPressed: () {},

            icon: Stack(
              children: [
                const Icon(Icons.notifications_rounded),

                Positioned(
                  right: 0,
                  top: 0,

                  child: Container(
                    width: 10,
                    height: 10,

                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),
        ],
      ),

      drawer: Drawer(
        child: Column(
          children: [
            // =========================
            // HEADER
            // =========================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                top: 60,
                left: 20,
                right: 20,
                bottom: 24,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primary, Color(0xff1D4ED8)],
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.white,
                    child: Text(
                      userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.dark,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          userEmail,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // =========================
            // SCROLLABLE CONTENT (ListView)
            // =========================
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const SizedBox(height: 8),

                  // SECTION 1: STUDENT MANAGEMENT
                  _sectionHeader('STUDENT MANAGEMENT', Icons.people_rounded),

                  _drawerTile(
                    icon: Icons.person_add_alt_1_rounded,
                    title: 'Create Student',
                    onTap: () {
                      Navigator.pushNamed(context, '/create_student');
                    },
                  ),

                  _drawerTile(
                    icon: Icons.image_outlined,
                    title: 'Capture Image',
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/image_capture',
                        arguments: {'registered': false},
                      );
                    },
                  ),

                  _drawerTile(
                    icon: Icons.people_alt_rounded,
                    title: 'Students',
                    onTap: () {
                      Navigator.pushNamed(context, '/students');
                    },
                  ),

                  _drawerTile(
                    icon: Icons.school_rounded,
                    title: 'Student Images',
                    onTap: () {
                      Navigator.pushNamed(context, '/student_image_page');
                    },
                  ),

                  const Divider(height: 24, thickness: 1),

                  // SECTION 2: CLASS & ATTENDANCE
                  _sectionHeader('CLASS & ATTENDANCE', Icons.class_rounded),

                  _drawerTile(
                    icon: Icons.payments_rounded,
                    title: 'Add Class',
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/qr-scan',
                        arguments: {'type': ScanType.classes},
                      );
                    },
                  ),

                  _drawerTile(
                    icon: Icons.class_outlined,
                    title: 'Class Schedule',
                    onTap: () {
                      Navigator.pushNamed(context, '/class_ongoing');
                    },
                  ),

                  _drawerTile(
                    icon: Icons.fact_check_rounded,
                    title: 'Attendance',
                    onTap: () {
                      Navigator.pushNamed(context, '/today-class');
                    },
                  ),

                  const Divider(height: 24, thickness: 1),

                  // SECTION 3: FINANCIAL
                  _sectionHeader('FINANCIAL', Icons.attach_money_rounded),

                  _drawerTile(
                    icon: Icons.payments_rounded,
                    title: 'Payment',
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/qr-scan',
                        arguments: {'type': ScanType.payment},
                      );
                    },
                  ),

                  _drawerTile(
                    icon: Icons.monetization_on_outlined,
                    title: 'Today Payments',
                    onTap: () {
                      Navigator.pushNamed(context, '/today-payment');
                    },
                  ),

                  _drawerTile(
                    icon: Icons.monetization_on_outlined,
                    title: 'Admission',
                    onTap: () {
                      Navigator.pushNamed(context, '/admission-payment');
                    },
                  ),

                  const Divider(height: 24, thickness: 1),

                  // SECTION 4: OTHER
                  _sectionHeader('OTHER', Icons.more_horiz_rounded),

                  _drawerTile(
                    icon: Icons.menu_book_rounded,
                    title: 'Student Tute',
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/qr-scan',
                        arguments: {'type': ScanType.tute},
                      );
                    },
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),

            // =========================
            // FOOTER: LOGOUT (Always at bottom)
            // =========================
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _drawerTile(
                  icon: Icons.logout_rounded,
                  title: 'Logout',
                  color: AppColors.danger,
                  onTap: _logout,
                ),
              ),
            ),
          ],
        ),
      ),

      // Helper method for section headers
      body: _loadingSession
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator.adaptive(
              onRefresh: _refreshDashboard,

              child: BlocBuilder<MobileDashboardBloc, MobileDashboardState>(
                builder: (context, state) {
                  // =========================
                  // LOADING
                  // =========================

                  if (state is MobileDashboardLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // =========================
                  // ERROR
                  // =========================

                  if (state is MobileDashboardError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),

                        child: Container(
                          padding: const EdgeInsets.all(24),

                          decoration: BoxDecoration(
                            color: Colors.white,

                            borderRadius: BorderRadius.circular(30),

                            boxShadow: AppColors.softShadow,
                          ),

                          child: Column(
                            mainAxisSize: MainAxisSize.min,

                            children: [
                              const Icon(
                                Icons.error_outline_rounded,

                                size: 70,

                                color: AppColors.danger,
                              ),

                              const SizedBox(height: 14),

                              Text(
                                state.message,

                                textAlign: TextAlign.center,

                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  // =========================
                  // EMPTY
                  // =========================

                  if (state is! MobileDashboardLoaded) {
                    return const Center(child: Text('No dashboard data'));
                  }

                  final dashboard = state.dashboard.data;

                  return ListView(
                    padding: const EdgeInsets.all(20),

                    children: [
                      if (_showPrinterBanner) ...[
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.orange.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.print_disabled_rounded,
                                color: Colors.orange,
                              ),
                              const SizedBox(width: 12),

                              const Expanded(
                                child: Text(
                                  'Printer not connected. Connect now to print receipts instantly.',
                                ),
                              ),

                              TextButton(
                                onPressed: () async {
                                  await Navigator.pushNamed(
                                    context,
                                    '/print_test_screen',
                                  );

                                  await _checkPrinterStatus();
                                },
                                child: const Text('Connect'),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),
                      ],
                      // =========================
                      // HERO CARD
                      // =========================
                      _heroCard(
                        userName: userName,

                        userEmail: userEmail,

                        smsBalance: _money(
                          dashboard.smsBalance.data.currentBalance,
                        ),

                        tokenActive: _token != null,
                      ),

                      const SizedBox(height: 20),

                      // =========================
                      // MINI STATS
                      // =========================
                      Row(
                        children: [
                          Expanded(
                            child: _miniStat(
                              title: 'Revenue',

                              value:
                                  'LKR ${_money(dashboard.todayPaymentCollection)}',

                              icon: Icons.payments_rounded,

                              color: AppColors.success,
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: _miniStat(
                              title: 'Today Classes',

                              value: dashboard.todayClassCount.toString(),

                              icon: Icons.today_rounded,

                              color: AppColors.warning,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // =========================
                      // QUICK ACTIONS
                      // =========================
                      const Text(
                        'Quick Actions',

                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.dark,
                        ),
                      ),

                      const SizedBox(height: 18),

                      GridView.count(
                        shrinkWrap: true,

                        physics: const NeverScrollableScrollPhysics(),

                        crossAxisCount: width > 900
                            ? 4
                            : width > 600
                            ? 3
                            : 2,

                        crossAxisSpacing: 14,

                        mainAxisSpacing: 14,

                        childAspectRatio: 1.0,

                        children: [
                          _QuickActionCard(
                            icon: Icons.person_add_alt_1_rounded,

                            label: 'Add Student',

                            color: AppColors.primary,

                            onTap: () {
                              Navigator.pushNamed(context, '/create_student');
                            },
                          ),

                          _QuickActionCard(
                            icon: Icons.payments_rounded,

                            label: 'Payment',

                            color: AppColors.success,

                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/qr-scan',

                                arguments: {'type': ScanType.payment},
                              );
                            },
                          ),

                          _QuickActionCard(
                            icon: Icons.class_rounded,

                            label: 'Add Class',

                            color: AppColors.secondary,

                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/qr-scan',

                                arguments: {'type': ScanType.classes},
                              );
                            },
                          ),

                          _QuickActionCard(
                            icon: Icons.menu_book_rounded,

                            label: 'Student Tute',

                            color: AppColors.info,

                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/qr-scan',

                                arguments: {'type': ScanType.tute},
                              );
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // =========================
                      // OVERVIEW
                      // =========================
                      const Text(
                        'Overview',

                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.dark,
                        ),
                      ),

                      const SizedBox(height: 18),

                      GridView.builder(
                        shrinkWrap: true,

                        physics: const NeverScrollableScrollPhysics(),

                        itemCount: 6,

                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: width > 900
                              ? 4
                              : width > 600
                              ? 3
                              : 2,

                          crossAxisSpacing: 12,

                          mainAxisSpacing: 12,

                          childAspectRatio: 1.05,
                        ),

                        itemBuilder: (context, index) {
                          final items = [
                            (
                              'Students',
                              dashboard.totalStudent.toString(),
                              Icons.people_alt_rounded,
                              AppColors.primary,
                            ),

                            (
                              'Teachers',
                              dashboard.totalTeacher.toString(),
                              Icons.school_rounded,
                              AppColors.info,
                            ),

                            (
                              'Classes',
                              dashboard.totalClasses.toString(),
                              Icons.class_rounded,
                              AppColors.success,
                            ),

                            (
                              'Today Sessions',
                              dashboard.todayClassCount.toString(),
                              Icons.today_rounded,
                              AppColors.warning,
                            ),

                            (
                              'Temporary',
                              dashboard.temporaryStudentCount.toString(),
                              Icons.qr_code_2_rounded,
                              AppColors.danger,
                            ),

                            (
                              'Permanent',
                              dashboard.permanentStudentCount.toString(),
                              Icons.verified_rounded,
                              AppColors.secondary,
                            ),
                          ];

                          final item = items[index];

                          return _StatCard(
                            title: item.$1,

                            value: item.$2,

                            icon: item.$3,

                            color: item.$4,
                          );
                        },
                      ),

                      const SizedBox(height: 24),
                    ],
                  );
                },
              ),
            ),
    );
  }

  Widget _sectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primaryDark),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryDark,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // HERO CARD
  // =========================

  Widget _heroCard({
    required String userName,
    required String userEmail,
    required String smsBalance,
    required bool tokenActive,
  }) {
    return Container(
      padding: const EdgeInsets.all(28),

      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xff2563EB), Color(0xff1D4ED8), Color(0xff1E40AF)],
        ),

        borderRadius: BorderRadius.circular(34),

        boxShadow: [
          BoxShadow(
            color: const Color(0xff2563EB).withOpacity(.25),

            blurRadius: 30,

            offset: const Offset(0, 14),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            _getGreeting(),

            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            userName,

            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(userEmail, style: const TextStyle(color: Colors.white70)),

          const SizedBox(height: 18),

          Wrap(
            spacing: 10,
            runSpacing: 10,

            children: [
              _heroBadge(
                icon: Icons.verified_user_rounded,

                text: tokenActive ? 'Session Active' : 'No Session',
              ),

              _heroBadge(
                icon: Icons.sms_rounded,

                text: 'SMS Balance: $smsBalance',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _heroBadge({required IconData icon, required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.10),

        borderRadius: BorderRadius.circular(16),

        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          Icon(icon, color: Colors.white, size: 18),

          const SizedBox(width: 8),

          Text(
            text,

            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniStat({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(24),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),

            blurRadius: 18,

            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Container(
            padding: const EdgeInsets.all(10),

            decoration: BoxDecoration(
              color: color.withOpacity(.10),

              borderRadius: BorderRadius.circular(14),
            ),

            child: Icon(icon, color: color),
          ),

          const SizedBox(height: 14),

          Text(
            value,

            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.dark,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            title,

            style: TextStyle(
              color: Colors.grey.shade600,

              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = AppColors.secondary,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),

      child: ListTile(
        leading: Icon(icon, color: color),

        title: Text(
          title,

          style: TextStyle(color: color, fontWeight: FontWeight.w600),
        ),

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

        onTap: onTap,
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,

      child: InkWell(
        onTap: onTap,

        borderRadius: BorderRadius.circular(26),

        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(.12), color.withOpacity(.03)],
            ),

            borderRadius: BorderRadius.circular(26),

            border: Border.all(color: color.withOpacity(.12)),
          ),

          child: Padding(
            padding: const EdgeInsets.all(18),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Icon(icon, color: color, size: 34),

                const SizedBox(height: 14),

                Text(
                  label,

                  textAlign: TextAlign.center,

                  style: const TextStyle(
                    fontWeight: FontWeight.w700,

                    color: AppColors.dark,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(20),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),

            blurRadius: 18,

            offset: const Offset(0, 8),
          ),
        ],

        border: Border.all(color: Colors.grey.withOpacity(0.08)),
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Container(
            width: 46,
            height: 46,

            decoration: BoxDecoration(
              color: color.withOpacity(0.12),

              shape: BoxShape.circle,
            ),

            child: Icon(icon, color: color, size: 24),
          ),

          const SizedBox(height: 12),

          Text(
            value,

            textAlign: TextAlign.center,

            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,

              color: AppColors.dark,

              height: 1.0,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            title,

            textAlign: TextAlign.center,

            maxLines: 2,

            overflow: TextOverflow.ellipsis,

            style: TextStyle(
              fontSize: 13,

              fontWeight: FontWeight.w600,

              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
