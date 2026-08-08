import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_datetime.dart';
import '../../../attendance/data/models/atendance_request_model.dart';
import '../../../attendance/presentaion/bloc/attendance/attendance_bloc.dart';
import '../../data/model/scan_attendance_new/scan_attendance_response_model.dart';
import '../bloc/read_payment/read_payment_bloc.dart';
import '../bloc/scan_attendance/scan_attendance_bloc.dart';

class AttendanceQrScannerPage extends StatefulWidget {
  const AttendanceQrScannerPage({super.key});

  @override
  State<AttendanceQrScannerPage> createState() =>
      _AttendanceQrScannerPageState();
}

class _AttendanceQrScannerPageState extends State<AttendanceQrScannerPage>
    with SingleTickerProviderStateMixin {
  //---------------------------------------
  // Camera Controller
  //---------------------------------------

  final MobileScannerController _scannerController = MobileScannerController(
    autoStart: false,
    detectionSpeed: DetectionSpeed.noDuplicates,
  );

  //---------------------------------------
  // Animation Controller for BottomSheet
  //---------------------------------------

  late AnimationController _slideController;
  late Animation<double> _slideAnimation;

  //---------------------------------------
  // States
  //---------------------------------------

  bool _hasPermission = false;
  bool _isScanning = false;
  bool _isMarkingAttendance = false;
  bool _attendanceSuccess = false;
  bool _isPaymentProcessing = false;
  bool _isBottomSheetVisible = false;

  //---------------------------------------
  // Data
  //---------------------------------------

  ScanAttendanceResponseModel? _scanResponse;
  String? _errorMessage;

  //---------------------------------------
  // Manual Input
  //---------------------------------------

  final TextEditingController _studentCodeController = TextEditingController();
  final FocusNode _studentCodeFocusNode = FocusNode();
  bool _isManualInputMode = false;

  //---------------------------------------
  // Lifecycle
  //---------------------------------------

  @override
  void initState() {
    super.initState();

    // Animation Controller
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _slideAnimation =
        Tween<double>(
          begin: 1.0, // hidden (below screen)
          end: 0.0, // visible
        ).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _requestPermission();
  }

  @override
  void dispose() {
    _scannerController.dispose();
    _slideController.dispose();
    _studentCodeController.dispose();
    _studentCodeFocusNode.dispose();
    super.dispose();
  }

  //---------------------------------------
  // Permission & Scanner Controls
  //---------------------------------------

  Future<void> _requestPermission() async {
    final status = await Permission.camera.request();

    if (!mounted) return;

    setState(() {
      _hasPermission = status.isGranted;
    });

    if (_hasPermission) {
      await _startScanner();
    }
  }

  Future<void> _startScanner() async {
    try {
      await _scannerController.start();
    } catch (_) {}
  }

  //---------------------------------------
  // QR Scan Handler
  //---------------------------------------

  Future<void> _onScan(String qr) async {
    if (_isScanning) return;

    final value = qr.trim();
    if (value.isEmpty) return;

    _processStudentCode(value);
  }

  //---------------------------------------
  // Manual Input Handler
  //---------------------------------------

  void _onManualSubmit() {
    final code = _studentCodeController.text.trim();
    if (code.isEmpty) {
      setState(() {
        _errorMessage = "Please enter a student code";
      });
      return;
    }

    // Hide keyboard
    _studentCodeFocusNode.unfocus();

    _processStudentCode(code);
  }

  void _processStudentCode(String code) {
    setState(() {
      _isScanning = true;
      _isMarkingAttendance = true;
      _attendanceSuccess = false;
      _errorMessage = null;
      _isManualInputMode = false;
    });

    context.read<ScanAttendanceBloc>().add(
      ScanAttendanceRequested(qrCode: code),
    );
  }

  //---------------------------------------
  // Auto Mark Attendance - SIMPLIFIED
  //---------------------------------------

  void _markAttendance() {
    final data = _scanResponse?.data;
    if (data == null) return;

    // Always show student details in BottomSheet
    setState(() {
      _attendanceSuccess = true;
      _isMarkingAttendance = false;
      _isScanning = false;
      _errorMessage = null;
    });

    _showBottomSheet();

    // Always try to mark - backend handles duplicates
    context.read<AttendanceBloc>().add(
      MarkAttendanceRequested(
        request: AttendanceRequestModel(
          studentId: data.student.id,
          classScheduleId: data.schedule.id,
          studentClassId: data.enrollment.studentClassId,
          classCategoryFeeId: data.enrollment.classCategoryFeeId,
          markMethod: "qr_mobile",
          markTute: false,
          note:
              "Student : ${data.student.initialName} | "
              "Grade : ${data.student.grade.gradeName} | "
              "Class : ${data.schedule.studentClass.className} | "
              "Category : ${data.schedule.studentClass.category}",
        ),
      ),
    );
  }

  //---------------------------------------
  // Open Payment
  //---------------------------------------

  void _openPayment() {
    final studentCode = _scanResponse?.data?.student.studentCode;
    if (studentCode == null) return;

    setState(() => _isPaymentProcessing = true);

    context.read<ReadPaymentBloc>().add(ReadPaymentRequested(studentCode));
  }

  //---------------------------------------
  // Show BottomSheet with Animation
  //---------------------------------------

  void _showBottomSheet() {
    if (!_isBottomSheetVisible) {
      setState(() {
        _isBottomSheetVisible = true;
      });
      _slideController.forward();
    }
  }

  //---------------------------------------
  // Toggle Manual Input Mode
  //---------------------------------------

  void _toggleManualInputMode() {
    setState(() {
      _isManualInputMode = !_isManualInputMode;
      if (_isManualInputMode) {
        _studentCodeController.clear();
        _errorMessage = null;
        // Focus on text field after a short delay
        Future.delayed(const Duration(milliseconds: 100), () {
          _studentCodeFocusNode.requestFocus();
        });
      } else {
        _studentCodeFocusNode.unfocus();
      }
    });
  }

  //---------------------------------------
  // Build
  //---------------------------------------

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        //----------------------------------
        // Scan Attendance Listener
        //----------------------------------
        BlocListener<ScanAttendanceBloc, ScanAttendanceState>(
          listener: (context, state) {
            if (state is ScanAttendanceLoading) {
              setState(() => _isMarkingAttendance = true);
            }

            if (state is ScanAttendanceSuccess) {
              setState(() {
                _scanResponse = state.response;
                _errorMessage = null;
                _isScanning = false;
              });
              _markAttendance();
            }

            if (state is ScanAttendanceFailure) {
              setState(() {
                _isMarkingAttendance = false;
                _isScanning = false;
                _errorMessage = state.message;
              });
            }
          },
        ),

        //----------------------------------
        // Attendance Listener
        //----------------------------------
        BlocListener<AttendanceBloc, AttendanceState>(
          listener: (context, state) {
            if (state is AttendanceLoading) {
              setState(() => _isMarkingAttendance = true);
            }

            if (state is AttendanceSuccess) {
              // Just update loading state - keep showing student data
              setState(() {
                _isMarkingAttendance = false;
                _isScanning = false;
              });
            }

            if (state is AttendanceError) {
              // Silently handle error - keep showing student data
              setState(() {
                _isMarkingAttendance = false;
                _isScanning = false;
                _errorMessage = null; // Don't show error
              });
            }
          },
        ),

        //----------------------------------
        // Read Payment Listener
        //----------------------------------
        BlocListener<ReadPaymentBloc, ReadPaymentState>(
          listener: (context, state) {
            if (state is ReadPaymentLoading) {
              setState(() => _isPaymentProcessing = true);
            }

            if (state is ReadPaymentLoaded) {
              setState(() => _isPaymentProcessing = false);
              Navigator.pushNamed(
                context,
                '/payment-details',
                arguments: {
                  'paymentState': state, // 'paymentState' use කරන්න
                  'mark_method': 'qr_mobile',
                },
              ).then((_) {
                setState(() {
                  _isScanning = false;
                });
              });
            }

            if (state is ReadPaymentError) {
              setState(() {
                _isPaymentProcessing = false;
                _errorMessage = state.message;
              });
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Attendance Scanner"),
          centerTitle: true,
          elevation: 0,
          foregroundColor: AppColors.dark,
          actions: [
            IconButton(
              icon: Icon(
                _isManualInputMode ? Icons.qr_code_scanner : Icons.edit,
                color: _isManualInputMode
                    ? AppColors.primary
                    : AppColors.textMuted,
              ),
              onPressed: _toggleManualInputMode,
              tooltip: _isManualInputMode
                  ? "Switch to QR Scan"
                  : "Enter Student Code",
            ),
          ],
        ),
        body: Stack(
          children: [
            //====================================
            // Camera View (50%)
            //====================================
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: MediaQuery.of(context).size.height * 0.50,
              child: _hasPermission
                  ? Stack(
                      children: [
                        // Hide camera when in manual input mode
                        if (!_isManualInputMode)
                          MobileScanner(
                            controller: _scannerController,
                            onDetect: (capture) {
                              final barcode = capture.barcodes.first.rawValue;
                              if (barcode != null) {
                                _onScan(barcode);
                              }
                            },
                          )
                        else
                          Container(
                            color: Colors.black87,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.edit,
                                    size: 60,
                                    color: Colors.white70,
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    "Manual Entry Mode",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    "Enter student code below",
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        _buildScannerOverlay(),
                        // Scanner Status
                        Positioned(
                          bottom: 40,
                          left: 0,
                          right: 0,
                          child: _buildScannerStatus(),
                        ),
                      ],
                    )
                  : _buildPermissionDenied(),
            ),

            //====================================
            // BottomSheet (50%) - Persistent with Animation
            //====================================
            AnimatedBuilder(
              animation: _slideAnimation,
              builder: (context, child) {
                return Positioned(
                  top:
                      MediaQuery.of(context).size.height * 0.50 +
                      (MediaQuery.of(context).size.height *
                          0.50 *
                          _slideAnimation.value),
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                      boxShadow: AppColors.mediumShadow,
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                      child: _buildBottomSheetContent(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  //---------------------------------------
  // Permission Denied View
  //---------------------------------------

  Widget _buildPermissionDenied() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.camera_alt, size: 60, color: AppColors.textMuted),
          SizedBox(height: 16),
          Text(
            "Camera Permission Required",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            "Please grant camera permission to scan QR codes.",
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  //---------------------------------------
  // Scanner Overlay
  //---------------------------------------

  Widget _buildScannerOverlay() {
    // Don't show overlay in manual mode
    if (_isManualInputMode) return const SizedBox.shrink();

    return IgnorePointer(
      child: Center(
        child: Container(
          width: 220,
          height: 220,
          decoration: BoxDecoration(
            border: Border.all(
              color: _attendanceSuccess ? AppColors.success : AppColors.primary,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Center(
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(
                  color:
                      (_attendanceSuccess
                              ? AppColors.success
                              : AppColors.primary)
                          .withOpacity(0.4),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //---------------------------------------
  // Scanner Status
  //---------------------------------------

  Widget _buildScannerStatus() {
    if (_isMarkingAttendance) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 12),
            Text(
              "Processing...",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      );
    }

    if (_attendanceSuccess) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.success.withOpacity(0.9),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.check_circle, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text(
              "✓ Attendance Marked",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      );
    }

    if (_isManualInputMode) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.8),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.edit, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text(
              "Enter Student Code",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(30),
      ),
      child: const Text(
        "Scan Student QR Code",
        style: TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }

  //---------------------------------------
  // BottomSheet Content
  //---------------------------------------

  Widget _buildBottomSheetContent() {
    // Loading State
    if (_isMarkingAttendance) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              "Marking Attendance...",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
    }

    // Error State
    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: AppColors.danger, size: 50),
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: AppColors.danger),
              ),
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _errorMessage = null;
                    _isScanning = false;
                    _studentCodeController.clear();
                  });
                },
                icon: const Icon(Icons.refresh),
                label: const Text("Try Again"),
              ),
            ],
          ),
        ),
      );
    }

    // Manual Input Mode - Show Text Field
    if (_isManualInputMode && _scanResponse == null) {
      return _buildManualInputPanel();
    }

    // Empty State (No student scanned yet)
    if (_scanResponse == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.qr_code_scanner, size: 50, color: AppColors.primary),
            SizedBox(height: 12),
            Text(
              "Scan Student QR Card",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.dark,
              ),
            ),
            SizedBox(height: 4),
            Text(
              "Point camera at the student's QR code",
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    // Student Data State
    return _buildStudentPanel();
  }

  //---------------------------------------
  // Manual Input Panel
  //---------------------------------------

  Widget _buildManualInputPanel() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_add, size: 50, color: AppColors.primary),
          const SizedBox(height: 16),
          const Text(
            "Enter Student Code",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.dark,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Type the student's code (e.g. ST001)",
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _studentCodeController,
            focusNode: _studentCodeFocusNode,
            decoration: InputDecoration(
              hintText: "Enter student code...",
              prefixIcon: const Icon(Icons.badge),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.primary, width: 2),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            style: const TextStyle(fontSize: 16),
            textCapitalization: TextCapitalization.characters,
            onSubmitted: (_) => _onManualSubmit(),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _toggleManualInputMode,
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text("Switch to Scanner"),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _onManualSubmit,
                  icon: const Icon(Icons.send),
                  label: const Text("Submit"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //---------------------------------------
  // Student Panel
  //---------------------------------------

  Widget _buildStudentPanel() {
    final data = _scanResponse!.data!;
    final student = data.student;
    final schedule = data.schedule;
    final enrollment = data.enrollment;
    final attendance = data.attendance;
    final payment = data.lastPayment;
    final classInfo = schedule.studentClass;

    // Check if student has paid for current month
    final isPaid = payment != null && payment.status == "PAID";

    // Payment month label
    final paymentMonthLabel = payment != null
        ? payment.paymentMonth
        : AppDateTime.getShortMonthName(DateTime.now());

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //====================================
          // Header: Success Badge + Free Card Chip
          //====================================
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Success Badge - Always Green
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.successLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.check_circle,
                      color: AppColors.success,
                      size: 16,
                    ),
                    SizedBox(width: 6),
                    Text(
                      "Attendance Marked",
                      style: TextStyle(
                        color: AppColors.success,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              // Free Card Chip
              if (enrollment.isFreeCard)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.warning, AppColors.primary],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.credit_card, color: Colors.white, size: 14),
                      SizedBox(width: 4),
                      Text(
                        "FREE CARD",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          const SizedBox(height: 12),

          //====================================
          // Student Info
          //====================================
          Row(
            children: [
              _studentImage(student.imgUrl),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.initialName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.dark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "ID: ${student.studentCode}  •  Grade: ${student.grade.gradeName}",
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "${classInfo.className} • ${classInfo.subject}",
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          //====================================
          // Summary Cards - Horizontal
          //====================================
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                // Payment Status - GREEN if PAID
                _SummaryCard(
                  title: "Payment",
                  value: isPaid ? "PAID" : "UNPAID",
                  icon: isPaid ? Icons.check_circle : Icons.payment,
                  color: isPaid ? AppColors.success : AppColors.danger,
                  isPaid: isPaid,
                ),

                // Payment Month
                _SummaryCard(
                  title: "Month",
                  value: paymentMonthLabel,
                  icon: Icons.calendar_month,
                  color: AppColors.info,
                  isPaid: false,
                ),

                // Fee Amount
                _SummaryCard(
                  title: "Fee",
                  value: "Rs.${enrollment.finalFee}",
                  icon: Icons.payments,
                  color: AppColors.primary,
                  isPaid: false,
                ),

                // Attendance
                _SummaryCard(
                  title: "Attendance",
                  value: "${attendance.presentCount}/${attendance.totalCount}",
                  icon: Icons.fact_check,
                  color: AppColors.secondary,
                  isPaid: false,
                ),

                // Percentage
                _SummaryCard(
                  title: "Percentage",
                  value: "${attendance.attendancePercentage}%",
                  icon: Icons.percent,
                  color: AppColors.warning,
                  isPaid: false,
                ),

                // Class Time
                _SummaryCard(
                  title: "Class Time",
                  value: "${schedule.startTime} - ${schedule.endTime}",
                  icon: Icons.access_time,
                  color: AppColors.info,
                  isPaid: false,
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          //====================================
          // Payment Button - Always Visible
          //====================================
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: _isPaymentProcessing ? null : _openPayment,
              icon: _isPaymentProcessing
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Icon(
                      isPaid ? Icons.check_circle : Icons.payments,
                      color: Colors.white,
                    ),
              label: _isPaymentProcessing
                  ? const Text("Loading...")
                  : Text(
                      isPaid ? "Payment Completed ✅" : "Collect Payment",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
              style: ElevatedButton.styleFrom(
                backgroundColor: isPaid ? AppColors.success : AppColors.primary,
                foregroundColor: Colors.white,
                disabledBackgroundColor: isPaid
                    ? AppColors.success
                    : AppColors.primary,
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

  //---------------------------------------
  // Helper Widgets
  //---------------------------------------

  Widget _studentImage(String imageUrl) {
    return CircleAvatar(
      radius: 34,
      backgroundColor: AppColors.surfaceSecondary,
      backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
      child: imageUrl.isEmpty
          ? const Icon(Icons.person, size: 34, color: AppColors.textMuted)
          : null,
    );
  }
}

//============================================================
// Summary Card Widget
//============================================================

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final bool isPaid;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.isPaid = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isPaid ? AppColors.successLight : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            color: Colors.black.withOpacity(0.06),
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isPaid ? AppColors.success : color.withOpacity(0.15),
          width: isPaid ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: (isPaid ? AppColors.success : color).withOpacity(
              0.12,
            ),
            child: Icon(
              icon,
              color: isPaid ? AppColors.success : color,
              size: 16,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: isPaid ? AppColors.success : color,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
