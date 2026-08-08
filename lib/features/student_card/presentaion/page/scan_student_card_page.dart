import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/enums/scan_student_card.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../route_observer.dart';
import '../../data/model/student_card_request_model.dart';
import '../bloc/student_card/student_card_bloc.dart';

class ScanStudentCardPage extends StatefulWidget {
  final ScanStudentCard scanStudentCard;
  const ScanStudentCardPage({super.key, required this.scanStudentCard});

  @override
  State<ScanStudentCardPage> createState() => _ScanStudentCardPageState();
}

class _ScanStudentCardPageState extends State<ScanStudentCardPage>
    with RouteAware {
  bool _hasPermission = false;
  bool _isScanned = false;
  bool _isHandlingResult = false;
  String _lastScannedValue = '';

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
    } catch (_) {
      // Handle error silently or log if needed
    }
  }

  Future<void> _safeStopScanner() async {
    try {
      await _scannerController.stop();
    } catch (_) {
      // Handle error silently or log if needed
    }
  }

  void _resetScanner() {
    if (!mounted) return;

    setState(() {
      _isScanned = false;
      _isHandlingResult = false;
      _lastScannedValue = '';
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _safeStartScanner();
      }
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

    // Prevent duplicate scans of the same value
    if (_lastScannedValue == trimmedValue && markMethod == 'qr_mobile') {
      return;
    }

    setState(() {
      _isScanned = true;
      _isHandlingResult = true;
      _lastScannedValue = trimmedValue;
      // ✅ QR value එක TextField එකට set කරන්න
      _customIdController.text = trimmedValue.toUpperCase();
    });

    _focusNode.unfocus();
    await _safeStopScanner();

    switch (widget.scanStudentCard) {
      case ScanStudentCard.studentCard:
        context.read<StudentCardBloc>().add(
          ScanStudentCardEvent(
            request: StudentCardRequestModel(
              qrCode: trimmedValue.toUpperCase(),
            ),
          ),
        );
        break;
      case ScanStudentCard.studentImage:
        Navigator.pushNamed(
          context,
          '/capture-image',
          arguments: {'student-id': trimmedValue.toUpperCase()},
        ).then((_) {
          _resetScanner();
        });
        break;
      case ScanStudentCard.assignStudentCard:
        context.read<StudentCardBloc>().add(
          SearchStudentForAssignmentEvent(
            request: StudentCardRequestModel(
              qrCode: trimmedValue.toUpperCase(),
            ),
          ),
        );
        break;
    }
  }

  void _handleManualSubmit() {
    final customId = _customIdController.text.trim();
    if (customId.isEmpty) {
      _showSnackBar('Please enter a valid ID');
      return;
    }
    _handleScanValue(customId, markMethod: 'manual_mobile');
  }

  String _getTitle() {
    switch (widget.scanStudentCard) {
      case ScanStudentCard.studentCard:
        return 'Scan Student Card QR';
      case ScanStudentCard.studentImage:
        return 'Capture Student Image';
      case ScanStudentCard.assignStudentCard:
        return 'Assign Student Card';
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
        BlocListener<StudentCardBloc, StudentCardState>(
          listenWhen: (previous, current) =>
              current is StudentCardLoaded ||
              current is SearchStudentForAssignmentLoaded ||
              current is StudentCardError,
          listener: (context, state) async {
            if (state is StudentCardLoaded) {
              await _safeStopScanner();

              if (!mounted) return;

              if (state.response.status) {
                Navigator.pushNamed(
                  context,
                  '/register-student',
                  arguments: {'qrCode': _lastScannedValue.toUpperCase()},
                ).then((_) {
                  _resetScanner();
                });
              } else {
                Navigator.pushNamed(
                  context,
                  '/register-details',
                  arguments: {
                    'qrCode': _lastScannedValue.toUpperCase(),
                    'response': state.response,
                  },
                ).then((_) {
                  _resetScanner();
                });
              }
            } else if (state is SearchStudentForAssignmentLoaded) {
              await _safeStopScanner();

              if (!mounted) return;

              Navigator.pushNamed(
                context,
                '/student-card-assignment',
                arguments: state.response,
              ).then((_) {
                _resetScanner();
              });
            } else if (state is StudentCardError) {
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