import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../data/model/scan_attendance_new/attendance_data_model.dart';
import '../../data/model/scan_attendance_new/class_selection_model.dart';
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

  /// HTTP status of the last failed scan (null = server not reached).
  int? _errorStatusCode;

  /// Code of the last scanned student. Kept so we can scan again with the
  /// chosen class when the student has more than one class open.
  String? _pendingCode;

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

  Future<void> _restartScanner() async {
    try {
      // Make sure controller is in a clean state
      try {
        await _scannerController.stop();
      } catch (_) {}

      if (!mounted || _isManualInputMode) return;

      await Future.delayed(const Duration(milliseconds: 150));

      if (!mounted || _isManualInputMode) return;

      await _scannerController.start();
    } catch (e) {
      debugPrint('Scanner restart error: $e');
    }
  }

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
      _pendingCode = code;
      _isScanning = true;
      _isMarkingAttendance = true;
      _attendanceSuccess = false;
      _errorMessage = null;
      _errorStatusCode = null;
    });

    context.read<ScanAttendanceBloc>().add(ScanAttendanceRequested(code: code));
  }

  //---------------------------------------
  // Class Selection (more than one class open)
  //---------------------------------------

  void _selectClass(ClassOptionModel option) {
    final code = _pendingCode;
    if (code == null || option.alreadyMarked) return;

    setState(() {
      _isMarkingAttendance = true;
      _attendanceSuccess = false;
      _errorMessage = null;
      _errorStatusCode = null;
    });

    context.read<ScanAttendanceBloc>().add(
      ScanAttendanceRequested(
        code: code,
        classScheduleId: option.classScheduleId,
      ),
    );
  }

  void _cancelClassSelection() => _resetForNextScan();

  /// Clears the last result/error and gets ready for the next student.
  void _resetForNextScan() {
    setState(() {
      _scanResponse = null;
      _pendingCode = null;
      _errorMessage = null;
      _errorStatusCode = null;
      _isScanning = false;
      _isMarkingAttendance = false;
      _attendanceSuccess = false;
      _studentCodeController.clear();
    });

    if (_isManualInputMode) {
      Future.delayed(const Duration(milliseconds: 150), () {
        if (!mounted) return;
        _studentCodeFocusNode.requestFocus();
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) return;
        await _restartScanner();
      });
    }
  }

  /// "16:30:00" -> "4:30 PM". Returns the input unchanged if it can't parse.
  String _formatTime(String value) {
    final parts = value.split(':');
    if (parts.length < 2) return value;

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return value;

    final period = hour >= 12 ? 'PM' : 'AM';
    final hour12 = hour % 12 == 0 ? 12 : hour % 12;

    return '$hour12:${minute.toString().padLeft(2, '0')} $period';
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

  /// Colour of the bottom sheet border while a marked student is shown:
  /// red = this month unpaid, green = paid, amber = free card.
  /// Null for every other state (loading, error, class choice, empty).
  Color? get _paymentBorderColor {
    final response = _scanResponse;
    final data = response?.data;

    if (_isMarkingAttendance ||
        _errorMessage != null ||
        response == null ||
        response.requiresSelection ||
        data == null) {
      return null;
    }

    return _PaymentStatus.from(data).color;
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
    if (_isManualInputMode) {
      // --------------------------------
      // SWITCH BACK TO QR SCANNER
      // --------------------------------

      _studentCodeFocusNode.unfocus();
      FocusScope.of(context).unfocus();

      setState(() {
        _isManualInputMode = false;
        _studentCodeController.clear();
        _errorMessage = null;
        _scanResponse = null;
        _attendanceSuccess = false;
        _isScanning = false;
        _isMarkingAttendance = false;
        _isBottomSheetVisible = false;
      });

      _slideController.reverse();

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) return;

        await _restartScanner();
      });

      return;
    }

    // --------------------------------
    // SWITCH TO MANUAL INPUT
    // --------------------------------

    setState(() {
      _isManualInputMode = true;
      _studentCodeController.clear();
      _errorMessage = null;
      _scanResponse = null;
      _attendanceSuccess = false;
      _isScanning = false;
      _isMarkingAttendance = false;
    });

    if (!_isBottomSheetVisible) {
      setState(() {
        _isBottomSheetVisible = true;
      });

      _slideController.forward();
    }

    Future.delayed(const Duration(milliseconds: 350), () {
      if (!mounted || !_isManualInputMode) return;

      _studentCodeFocusNode.requestFocus();
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
              final response = state.response;
              final data = response.data;

              // More than one class open: let the staff member choose.
              // Nothing is marked yet, so keep _isScanning true to stop the
              // camera from picking up another QR meanwhile.
              if (response.requiresSelection && response.selection != null) {
                setState(() {
                  _scanResponse = response;
                  _errorMessage = null;
                  _isMarkingAttendance = false;
                  _attendanceSuccess = false;
                });
                _showBottomSheet();
                return;
              }

              if (data == null) {
                setState(() {
                  _scanResponse = response;
                  _errorMessage = 'Attendance data not found.';
                  _isScanning = false;
                  _isMarkingAttendance = false;
                  _attendanceSuccess = false;
                });
                _showBottomSheet();
                return;
              }

              final alreadyMarked = data.attendanceResult.alreadyMarked;

              setState(() {
                _scanResponse = response;
                _errorMessage = null;
                _isScanning = false;
                _isMarkingAttendance = false;
                _attendanceSuccess = !alreadyMarked;
              });

              _showBottomSheet();
            }

            if (state is ScanAttendanceFailure) {
              // Keep _isScanning true so the camera waits until the staff
              // member has read the message and taps "Scan Next".
              setState(() {
                _isMarkingAttendance = false;
                _isScanning = true;
                _attendanceSuccess = false;
                _errorMessage = state.message;
                _errorStatusCode = state.statusCode;
              });
              _showBottomSheet();
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
                if (!mounted) return;
                setState(() {
                  _isScanning = false;
                });
              });
            }

            if (state is ReadPaymentError) {
              // Attendance is already marked here, so don't replace the
              // student panel with the "not marked" error panel.
              setState(() => _isPaymentProcessing = false);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.message.replaceFirst('Exception: ', ''),
                  ),
                  backgroundColor: AppColors.danger,
                ),
              );
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
                              if (capture.barcodes.isEmpty) {
                                return;
                              }

                              final barcode = capture.barcodes.first.rawValue;

                              if (barcode == null || barcode.trim().isEmpty) {
                                return;
                              }

                              _onScan(barcode);
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
                final screenHeight = MediaQuery.of(context).size.height;
                final sheetHeight = screenHeight * 0.50;
                final borderColor = _paymentBorderColor;

                return Positioned(
                  left: 0,
                  right: 0,
                  bottom: -sheetHeight * _slideAnimation.value,
                  height: sheetHeight,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                      // Thick red border when this month is unpaid
                      // (green paid, amber free card).
                      border: borderColor != null
                          ? Border.all(color: borderColor, width: 4)
                          : null,
                      boxShadow: AppColors.mediumShadow,
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
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

    if (_errorMessage != null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.danger.withOpacity(0.9),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.cancel, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text(
              "Attendance NOT marked",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      );
    }

    if (_attendanceSuccess && _paymentBorderColor == AppColors.danger) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.danger.withOpacity(0.9),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.check_circle, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text(
              "Attendance Marked  •  UNPAID",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
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
      return _buildErrorPanel();
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

    // Class Selection State
    if (_scanResponse!.requiresSelection && _scanResponse!.selection != null) {
      return _buildClassSelectionPanel(_scanResponse!.selection!);
    }

    // Student Data State
    return _buildStudentPanel();
  }

  //---------------------------------------
  // Class Selection Panel
  //---------------------------------------

  Widget _buildClassSelectionPanel(ClassSelectionModel selection) {
    final student = selection.student;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        Row(
          children: [
            const Icon(Icons.call_split, color: AppColors.warning, size: 28),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student.initialName,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppColors.dark,
                    ),
                  ),
                  Text(
                    student.studentCode,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.warningLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            "This student has more than one class right now. "
            "Select the class the student came for.",
            style: TextStyle(fontSize: 14, color: AppColors.dark),
          ),
        ),

        const SizedBox(height: 12),

        ...selection.options.map(_buildClassOptionCard),

        const SizedBox(height: 8),

        OutlinedButton.icon(
          onPressed: _cancelClassSelection,
          icon: const Icon(Icons.close),
          label: const Text("Cancel"),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildClassOptionCard(ClassOptionModel option) {
    final classInfo = option.studentClass;
    final title = classInfo.subject.isNotEmpty
        ? classInfo.subject
        : classInfo.className;
    final disabled = option.alreadyMarked;

    final details = <String>[
      if (classInfo.teacher.isNotEmpty) classInfo.teacher,
      if (option.hall.isNotEmpty) option.hall,
      if (classInfo.category.isNotEmpty) classInfo.category,
    ].join('  •  ');

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: disabled ? AppColors.surfaceSecondary : Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: disabled ? null : () => _selectClass(option),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: disabled ? AppColors.border : AppColors.primary,
                width: disabled ? 1 : 1.5,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: disabled
                              ? AppColors.textMuted
                              : AppColors.dark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 15,
                            color: disabled
                                ? AppColors.textMuted
                                : AppColors.info,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${_formatTime(option.startTime)} - "
                            "${_formatTime(option.endTime)}",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: disabled
                                  ? AppColors.textMuted
                                  : AppColors.dark,
                            ),
                          ),
                        ],
                      ),
                      if (details.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          details,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                disabled
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.successLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          "Already marked",
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.success,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    : const Icon(
                        Icons.chevron_right,
                        color: AppColors.primary,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //---------------------------------------
  // Error Panel
  //---------------------------------------

  Widget _buildErrorPanel() {
    final info = _ScanErrorInfo.from(_errorMessage!, _errorStatusCode);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: info.color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(info.icon, color: info.color, size: 40),
          ),

          const SizedBox(height: 12),

          Text(
            info.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: info.color,
            ),
          ),

          const SizedBox(height: 4),

          const Text(
            "Attendance was not marked",
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),

          const SizedBox(height: 14),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surfaceSecondary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _errorMessage!,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.dark,
                  ),
                ),
                if (info.hint.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    info.hint,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 18),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _resetForNextScan,
              icon: Icon(
                _isManualInputMode ? Icons.edit : Icons.qr_code_scanner,
              ),
              label: Text(
                _isManualInputMode ? "Enter Next Code" : "Scan Next",
              ),
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
    );
  }

  //---------------------------------------
  // Manual Input Panel
  //---------------------------------------

  Widget _buildManualInputPanel() {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        20 + MediaQuery.of(context).viewInsets.bottom,
      ),
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
            textAlign: TextAlign.center,
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
            textInputAction: TextInputAction.done,
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

    final alreadyMarked = data.attendanceResult.alreadyMarked;

    // Current month payment: paid / not paid / free card
    final payStatus = _PaymentStatus.from(data);

    // The bottom sheet border shows the payment colour (see
    // _paymentBorderColor), so no extra line is drawn here.
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: alreadyMarked
                            ? AppColors.warning.withOpacity(0.12)
                            : AppColors.successLight,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            alreadyMarked ? Icons.info_outline : Icons.check_circle,
                            color: alreadyMarked
                                ? AppColors.warning
                                : AppColors.success,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            alreadyMarked ? "Already Marked" : "Attendance Marked",
                            style: TextStyle(
                              color: alreadyMarked
                                  ? AppColors.warning
                                  : AppColors.success,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
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
                // Current Month Payment Message
                //====================================
                _buildPaymentStatusBanner(payStatus),

                const SizedBox(height: 14),

                //====================================
                // Summary Cards - Horizontal
                //====================================
                SizedBox(
                  height: 100,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      // This month's payment: green / red / amber
                      _SummaryCard(
                        title: "This Month",
                        value: payStatus.shortLabel,
                        icon: payStatus.icon,
                        color: payStatus.color,
                        highlighted: true,
                      ),

                      // Last payment month
                      _SummaryCard(
                        title: "Last Paid",
                        value: payment != null && payment.paymentMonth.isNotEmpty
                            ? _formatMonth(payment.paymentMonth)
                            : "None",
                        icon: Icons.calendar_month,
                        color: AppColors.info,
                      ),

                      // Fee Amount
                      _SummaryCard(
                        title: "Fee",
                        value: "Rs.${enrollment.finalFee.toStringAsFixed(0)}",
                        icon: Icons.payments,
                        color: AppColors.primary,
                      ),

                      // Attendance
                      _SummaryCard(
                        title: "Attendance",
                        value: "${attendance.presentCount}/${attendance.totalCount}",
                        icon: Icons.fact_check,
                        color: AppColors.secondary,
                      ),

                      // Percentage
                      _SummaryCard(
                        title: "Percentage",
                        value: "${attendance.attendancePercentage}%",
                        icon: Icons.percent,
                        color: AppColors.warning,
                      ),

                      // Class Time
                      _SummaryCard(
                        title: "Class Time",
                        value:
                            "${_formatTime(schedule.startTime)} - ${_formatTime(schedule.endTime)}",
                        icon: Icons.access_time,
                        color: AppColors.info,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                //====================================
                // Collect Payment - always visible for every student
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
                        : const Icon(Icons.payments, color: Colors.white),
                    label: Text(
                      _isPaymentProcessing ? "Loading..." : "Collect Payment",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: AppColors.primary.withOpacity(0.7),
                      disabledForegroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppColors.radiusMedium,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Next student
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: OutlinedButton.icon(
                    onPressed: _isPaymentProcessing ? null : _resetForNextScan,
                    icon: Icon(
                      _isManualInputMode ? Icons.edit : Icons.qr_code_scanner,
                    ),
                    label: Text(
                      _isManualInputMode ? "Enter Next Code" : "Scan Next",
                    ),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: AppColors.radiusMedium,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  //---------------------------------------
  // Current Month Payment Banner
  //---------------------------------------

  Widget _buildPaymentStatusBanner(_PaymentStatus status) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: status.color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: status.color, width: 1.5),
      ),
      child: Row(
        children: [
          Icon(status.icon, color: status.color, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  status.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: status.color,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  status.message,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.dark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// "2026-10" -> "Oct 2026". Returns the input if it can't parse.
  String _formatMonth(String value) {
    final date = DateTime.tryParse(value.length == 7 ? '$value-01' : value);
    if (date == null) return value;
    return DateFormat('MMM yyyy').format(date);
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

  /// Draws a thick coloured border and tinted background.
  final bool highlighted;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: highlighted ? color.withOpacity(0.08) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            color: Colors.black.withOpacity(0.06),
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: highlighted ? color : color.withOpacity(0.15),
          width: highlighted ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: color.withOpacity(0.12),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: color,
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


/// Turns a scan error into a short title, an icon/colour and a hint telling
/// the staff member what to do next. The server message is always shown too.
class _ScanErrorInfo {
  final String title;
  final String hint;
  final IconData icon;
  final Color color;

  const _ScanErrorInfo(this.title, this.hint, this.icon, this.color);

  factory _ScanErrorInfo.from(String message, int? statusCode) {
    final m = message.toLowerCase();

    if (statusCode == null &&
        (m.contains('reach the server') || m.contains('too long'))) {
      return const _ScanErrorInfo(
        'No connection',
        'Check Wi-Fi or mobile data, then scan again.',
        Icons.wifi_off,
        AppColors.danger,
      );
    }

    if (m.contains('attendance service was not found')) {
      return const _ScanErrorInfo(
        'Server not updated',
        'The server does not have the attendance service yet. '
            'Ask the system admin to update it.',
        Icons.cloud_off,
        AppColors.danger,
      );
    }

    if (statusCode == 401) {
      return const _ScanErrorInfo(
        'Session expired',
        'Log out and log in again, then scan.',
        Icons.lock_outline,
        AppColors.danger,
      );
    }

    if (statusCode == 409 || m.contains('already')) {
      return const _ScanErrorInfo(
        'Already marked',
        "This student's attendance for this class is already recorded.",
        Icons.how_to_reg,
        AppColors.warning,
      );
    }

    if (m.contains('opens at')) {
      return const _ScanErrorInfo(
        'Too early',
        'Attendance opens one hour before the class starts.',
        Icons.schedule,
        AppColors.warning,
      );
    }

    if (m.contains('finished') || m.contains('ended')) {
      return const _ScanErrorInfo(
        'Classes finished',
        "All of today's classes for this student have ended.",
        Icons.event_busy,
        AppColors.warning,
      );
    }

    if (m.contains('not enrolled') || m.contains('enrollment not found')) {
      return const _ScanErrorInfo(
        'Not enrolled in a class',
        'Enroll the student in the class first, then scan again.',
        Icons.person_off_outlined,
        AppColors.danger,
      );
    }

    if (m.contains('no classes') || m.contains('no class')) {
      return const _ScanErrorInfo(
        'No class today',
        "This student has no class scheduled for today.",
        Icons.event_busy,
        AppColors.warning,
      );
    }

    if (m.contains('not open')) {
      return const _ScanErrorInfo(
        'Class not open now',
        'Scan again and choose a class that is on now.',
        Icons.schedule,
        AppColors.warning,
      );
    }

    if (m.contains('inactive') || m.contains('disabled')) {
      return const _ScanErrorInfo(
        'Student inactive',
        'This student is inactive or disabled. Check the student in the system.',
        Icons.block,
        AppColors.danger,
      );
    }

    if (m.contains('expired')) {
      return const _ScanErrorInfo(
        'QR code expired',
        'This temporary QR card has expired. Issue a new card.',
        Icons.qr_code_2,
        AppColors.danger,
      );
    }

    if ((m.contains('student') && m.contains('not found')) ||
        m.contains('qr')) {
      return const _ScanErrorInfo(
        'Student not found',
        'Check the QR card or the student code.',
        Icons.badge_outlined,
        AppColors.danger,
      );
    }

    return const _ScanErrorInfo(
      'Cannot mark attendance',
      '',
      Icons.error_outline,
      AppColors.danger,
    );
  }
}


/// This month's payment state for the scanned class.
class _PaymentStatus {
  final String title;
  final String shortLabel;
  final String message;
  final IconData icon;
  final Color color;

  const _PaymentStatus({
    required this.title,
    required this.shortLabel,
    required this.message,
    required this.icon,
    required this.color,
  });

  factory _PaymentStatus.from(AttendanceDataModel data) {
    final current = data.currentMonthPayment;
    final now = DateTime.now();

    final monthLabel = (current != null && current.monthLabel.isNotEmpty)
        ? current.monthLabel
        : DateFormat('MMMM yyyy').format(now);

    final isFreeCard = data.enrollment.isFreeCard || (current?.isFreeCard ?? false);

    if (isFreeCard) {
      return _PaymentStatus(
        title: 'FREE CARD',
        shortLabel: 'FREE CARD',
        message: 'No payment needed for $monthLabel.',
        icon: Icons.card_giftcard,
        color: AppColors.warning,
      );
    }

    final bool isPaid;

    if (current != null) {
      isPaid = current.isPaid;
    } else {
      // Older server without current_month_payment: use the last payment,
      // but only if it is for this month.
      final last = data.lastPayment;
      final thisMonth = DateFormat('yyyy-MM').format(now);
      final status = last?.status.toLowerCase() ?? '';

      isPaid = last != null &&
          last.paymentMonth.startsWith(thisMonth) &&
          (status == 'completed' || status == 'paid');
    }

    if (isPaid) {
      final receipt = current?.receiptNumber ?? '';

      return _PaymentStatus(
        title: 'PAID',
        shortLabel: 'PAID',
        message: receipt.isNotEmpty
            ? '$monthLabel fee paid. Receipt: $receipt'
            : '$monthLabel fee paid.',
        icon: Icons.check_circle,
        color: AppColors.success,
      );
    }

    return _PaymentStatus(
      title: 'UNPAID',
      shortLabel: 'UNPAID',
      message: '$monthLabel fee is unpaid. Collect the payment.',
      icon: Icons.cancel,
      color: AppColors.danger,
    );
  }
}
