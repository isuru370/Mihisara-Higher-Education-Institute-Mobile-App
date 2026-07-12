import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:nexorait_education_app/features/qr/data/model/read_tute/read_tute_request_model.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/enums/scan_type.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../route_observer.dart';
import '../../../students/presentaion/pages/single_student_view_page.dart';
import '../bloc/read_payment/read_payment_bloc.dart';
import '../bloc/read_student/read_student_bloc.dart';
import '../bloc/read_student_classes/read_student_classes_bloc.dart';
import '../bloc/read_tute/read_tute_bloc.dart';
import '../bloc/scan_attendance/scan_attendance_bloc.dart';

class QrScannerPage extends StatefulWidget {
  final ScanType scanType;
  final int? studentClassId;
  final int? classCategoryFeeId;
  final int? classScheduleId;
  const QrScannerPage({
    super.key,
    required this.scanType,
    this.studentClassId,
    this.classCategoryFeeId,
    this.classScheduleId,
  });

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> with RouteAware {
  bool _hasPermission = false;
  bool _isScanned = false;
  bool _isHandlingResult = false;
  String _pendingMarkMethod = 'qr_mobile';

  final MobileScannerController _scannerController = MobileScannerController(
    autoStart: false,
    detectionSpeed: DetectionSpeed.noDuplicates,
  );

  final TextEditingController _customIdController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route != null) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _customIdController.dispose();
    _focusNode.dispose();
    _scannerController.dispose();
    super.dispose();
  }

  @override
  void didPopNext() {
    _customIdController.clear();
    _resetScanner();
  }

  Future<void> _requestPermission() async {
    final status = await Permission.camera.request();
    if (!mounted) return;

    setState(() {
      _hasPermission = status.isGranted;
    });

    if (_hasPermission) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _safeStartScanner();
      });
    }
  }

  Future<void> _safeStartScanner() async {
    try {
      await _scannerController.start();
    } catch (_) {}
  }

  Future<void> _safeStopScanner() async {
    try {
      await _scannerController.stop();
    } catch (_) {}
  }

  void _resetScanner() {
    if (!mounted) return;

    setState(() {
      _isScanned = false;
      _isHandlingResult = false;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _safeStartScanner();
    });
  }

  void _showSnackBar(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _handleScanValue(
    String value, {
    required String markMethod,
  }) async {
    if (!mounted) return;
    if (_isScanned || _isHandlingResult) return;

    final trimmedValue = value.trim();
    if (trimmedValue.isEmpty) return;

    setState(() {
      _isScanned = true;
      _isHandlingResult = true;
      _pendingMarkMethod = markMethod;
    });

    _focusNode.unfocus();
    await _safeStopScanner();

    switch (widget.scanType) {
      case ScanType.attendance:
        context.read<ScanAttendanceBloc>().add(
          ScanAttendanceRequested(qrCode: trimmedValue),
        );

        break;

      case ScanType.payment:
        context.read<ReadPaymentBloc>().add(ReadPaymentRequested(trimmedValue));
        break;

      case ScanType.student:
        context.read<ReadStudentBloc>().add(
          ReadStudentRequested(qrCode: trimmedValue),
        );
        break;

      case ScanType.tute:
        context.read<ReadTuteBloc>().add(
          ReadTuteRequested(
            readTuteRequestModel: ReadTuteRequestModel(qrCode: trimmedValue),
          ),
        );
        break;

      case ScanType.classes:
        context.read<ReadStudentClassesBloc>().add(
          ReadStudentClassesRequested(qrCode: trimmedValue),
        );
        break;
    }
  }

  void _handleManualSubmit() {
    final customId = _customIdController.text.toUpperCase().trim();
    _handleScanValue(customId, markMethod: 'manual_mobile');
  }

  String _getTitle() {
    switch (widget.scanType) {
      case ScanType.attendance:
        return 'Scan Attendance QR';
      case ScanType.payment:
        return 'Scan Payment QR';
      case ScanType.tute:
        return 'Scan Tute QR';
      case ScanType.classes:
        return 'Add Student Classes';
      case ScanType.student:
        return 'Scan Student';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasPermission) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Camera Permission'),
          backgroundColor: AppTheme.lightTheme.primaryColor,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.camera_alt_outlined, size: 70),
                const SizedBox(height: 16),
                const Text(
                  'Camera permission is required to scan QR codes.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _requestPermission,
                  child: const Text('Grant Permission'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return MultiBlocListener(
      listeners: [
        BlocListener<ScanAttendanceBloc, ScanAttendanceState>(
          listenWhen: (previous, current) =>
              current is ScanAttendanceSuccess ||
              current is ScanAttendanceFailure,
          listener: (context, state) async {
            if (state is ScanAttendanceSuccess) {
              await _safeStopScanner();
              if (!mounted) return;

              Navigator.pushNamed(
                context,
                '/attendance-details-new',
                arguments: {
                  'attendanceData': state.response,
                  'mark_method': _pendingMarkMethod,
                },
              );
            }

            if (state is ScanAttendanceFailure) {
              _showSnackBar(state.message);
              _resetScanner();
            }
          },
        ),
        BlocListener<ReadPaymentBloc, ReadPaymentState>(
          listenWhen: (previous, current) =>
              current is ReadPaymentLoaded || current is ReadPaymentError,
          listener: (context, state) async {
            if (state is ReadPaymentLoaded) {
              final response = state.response;

              if (response.data == null) {
                _showSnackBar('No payment records found.');
                _resetScanner();
                return;
              }

              await _safeStopScanner();
              if (!mounted) return;

              Navigator.pushNamed(
                context,
                '/payment-details',
                arguments: {
                  'paymentState': state,
                  'mark_method': _pendingMarkMethod,
                },
              );
            }

            if (state is ReadPaymentError) {
              _showSnackBar(state.message);
              _resetScanner();
            }
          },
        ),
        BlocListener<ReadStudentBloc, ReadStudentState>(
          listenWhen: (previous, current) =>
              current is ReadStudentLoaded || current is ReadStudentError,
          listener: (context, state) async {
            if (state is ReadStudentLoaded) {
              final student = state.response.student;
              if (student != null) {
                await _safeStopScanner();
                if (!mounted) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SingleStudentViewPage(student: student),
                  ),
                );
              } else {
                _showSnackBar(state.response.message);
                _resetScanner();
              }
            }

            if (state is ReadStudentError) {
              _showSnackBar(state.message);
              _resetScanner();
            }
          },
        ),
        BlocListener<ReadTuteBloc, ReadTuteState>(
          listenWhen: (previous, current) =>
              current is ReadTuteSuccess || current is ReadTuteFailure,
          listener: (context, state) async {
            if (state is ReadTuteSuccess) {
              _showSnackBar(state.response.message);

              await _safeStopScanner();

              if (!mounted) return;

              await Navigator.pushReplacementNamed(
                context,
                '/student-tute-screen',
                arguments: state.response,
              );

              if (!mounted) return;

              _resetScanner();
            } else if (state is ReadTuteFailure) {
              _showSnackBar(state.message);

              _resetScanner();
            }
          },
        ),
        BlocListener<ReadStudentClassesBloc, ReadStudentClassesState>(
          listenWhen: (previous, current) =>
              current is ReadStudentClassesSuccess ||
              current is ReadStudentClassesError,

          listener: (context, state) async {
            if (state is ReadStudentClassesSuccess) {
              _showSnackBar(state.response.message ?? 'Success');

              await _safeStopScanner();

              if (!mounted) return;

              await Navigator.pushReplacementNamed(
                context,
                '/add-student-class',
                arguments: state.response,
              );

              if (!mounted) return;

              _resetScanner();
            } else if (state is ReadStudentClassesError) {
              _showSnackBar(state.message);

              _resetScanner();
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.lightTheme.primaryColor,
          title: Text(_getTitle()),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            MobileScanner(
              controller: _scannerController,
              onDetect: (capture) {
                if (_isScanned || _isHandlingResult) return;
                if (capture.barcodes.isEmpty) return;

                final value = capture.barcodes.first.rawValue;
                if (value == null || value.trim().isEmpty) return;

                _handleScanValue(value, markMethod: 'qr_mobile');
              },
            ),
            Center(
              child: IgnorePointer(
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppTheme.lightTheme.primaryColor.withValues(
                        alpha: 0.6,
                      ),
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _customIdController,
                            focusNode: _focusNode,
                            decoration: const InputDecoration(
                              hintText: 'Enter custom ID',
                              border: InputBorder.none,
                            ),
                            textInputAction: TextInputAction.search,
                            onSubmitted: (_) => _handleManualSubmit(),
                            enabled: !_isScanned && !_isHandlingResult,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: (_isScanned || _isHandlingResult)
                              ? null
                              : _handleManualSubmit,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (_isScanned || _isHandlingResult)
              Container(
                color: Colors.black.withValues(alpha: 0.15),
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}
