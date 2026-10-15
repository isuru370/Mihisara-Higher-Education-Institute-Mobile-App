import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../data/model/scan_payment_new/scan_payment_request_model.dart';
import '../bloc/scan_payment/scan_payment_bloc.dart';

class ScanPaymentPage extends StatefulWidget {
  const ScanPaymentPage({super.key});

  @override
  State<ScanPaymentPage> createState() => _ScanPaymentPageState();
}

class _ScanPaymentPageState extends State<ScanPaymentPage> {
  // ============================================================
  // CAMERA CONTROLLER
  // ============================================================

  final MobileScannerController _scannerController = MobileScannerController(
    autoStart: false,
    detectionSpeed: DetectionSpeed.noDuplicates,
  );

  // ============================================================
  // STATES
  // ============================================================

  bool _hasPermission = false;
  bool _isScanning = false;
  bool _isManualInputMode = false;

  String? _errorMessage;

  // This keeps the method that was used to start the current request.
  //
  // QR:
  // qr_mobile
  //
  // Manual:
  // manual_mobile
  String _currentMarkMethod = 'qr_mobile';

  // ============================================================
  // MANUAL INPUT
  // ============================================================

  final TextEditingController _studentCodeController = TextEditingController();

  final FocusNode _studentCodeFocusNode = FocusNode();

  // ============================================================
  // LIFECYCLE
  // ============================================================

  @override
  void initState() {
    super.initState();

    _requestPermission();
  }

  @override
  void dispose() {
    _scannerController.dispose();
    _studentCodeController.dispose();
    _studentCodeFocusNode.dispose();

    super.dispose();
  }

  // ============================================================
  // CAMERA PERMISSION
  // ============================================================

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

  // ============================================================
  // START SCANNER
  // ============================================================

  Future<void> _startScanner() async {
    try {
      if (!mounted || !_hasPermission || _isManualInputMode) {
        return;
      }

      await _scannerController.start();
    } catch (e) {
      debugPrint('Scanner start error: $e');
    }
  }

  // ============================================================
  // RESTART SCANNER
  // ============================================================

  Future<void> _restartScanner() async {
    try {
      if (!mounted || !_hasPermission || _isManualInputMode) {
        return;
      }

      try {
        await _scannerController.stop();
      } catch (_) {}

      await Future.delayed(const Duration(milliseconds: 150));

      if (!mounted || !_hasPermission || _isManualInputMode) {
        return;
      }

      await _scannerController.start();
    } catch (e) {
      debugPrint('Scanner restart error: $e');
    }
  }

  // ============================================================
  // QR SCAN
  // ============================================================

  Future<void> _onScan(String qr) async {
    if (_isScanning) return;

    final value = qr.trim();

    if (value.isEmpty) return;

    _processStudentCode(value, markMethod: 'qr_mobile');
  }

  // ============================================================
  // MANUAL SUBMIT
  // ============================================================

  void _onManualSubmit() {
    if (_isScanning) return;

    final code = _studentCodeController.text.trim();

    if (code.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a student code';
      });

      Future.delayed(const Duration(milliseconds: 100), () {
        if (!mounted || !_isManualInputMode) return;

        _studentCodeFocusNode.requestFocus();
      });

      return;
    }

    _studentCodeFocusNode.unfocus();

    _processStudentCode(code, markMethod: 'manual_mobile');
  }

  // ============================================================
  // PROCESS STUDENT CODE
  // ============================================================

  void _processStudentCode(String code, {required String markMethod}) {
    final value = code.trim();

    if (value.isEmpty || _isScanning) {
      return;
    }

    setState(() {
      _isScanning = true;
      _errorMessage = null;
      _currentMarkMethod = markMethod;
    });

    context.read<ScanPaymentBloc>().add(
      ScanPaymentRequested(requestModel: ScanPaymentRequestModel(code: value)),
    );
  }

  // ============================================================
  // TOGGLE MANUAL INPUT MODE
  // ============================================================

  void _toggleManualInputMode() {
    if (_isManualInputMode) {
      // ========================================================
      // SWITCH BACK TO QR SCANNER
      // ========================================================

      _studentCodeFocusNode.unfocus();
      FocusScope.of(context).unfocus();

      setState(() {
        _isManualInputMode = false;
        _studentCodeController.clear();
        _errorMessage = null;
        _isScanning = false;
        _currentMarkMethod = 'qr_mobile';
      });

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) return;

        await _restartScanner();
      });

      return;
    }

    // ==========================================================
    // SWITCH TO MANUAL INPUT
    // ==========================================================

    // Stop camera before entering manual mode.
    try {
      _scannerController.stop();
    } catch (_) {}

    setState(() {
      _isManualInputMode = true;
      _studentCodeController.clear();
      _errorMessage = null;
      _isScanning = false;
      _currentMarkMethod = 'manual_mobile';
    });

    Future.delayed(const Duration(milliseconds: 350), () {
      if (!mounted || !_isManualInputMode) return;

      _studentCodeFocusNode.requestFocus();
    });
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return BlocListener<ScanPaymentBloc, ScanPaymentState>(
      listener: (context, state) {
        // ======================================================
        // LOADING
        // ======================================================

        if (state is ScanPaymentLoading) {
          setState(() {
            _isScanning = true;
            _errorMessage = null;
          });

          return;
        }

        // ======================================================
        // SUCCESS
        // ======================================================

        if (state is ScanPaymentLoaded) {
          final markMethod = _currentMarkMethod;

          setState(() {
            _isScanning = false;
            _errorMessage = null;
          });

          _studentCodeFocusNode.unfocus();
          FocusScope.of(context).unfocus();

          Navigator.pushNamed(
            context,
            '/payment-details',
            arguments: {
              'paymentState': state.response,
              'mark_method': markMethod,
            },
          );

          return;
        }

        // ======================================================
        // ERROR
        // ======================================================

        if (state is ScanPaymentError) {
          final wasManualInput = _currentMarkMethod == 'manual_mobile';

          setState(() {
            _isScanning = false;
            _errorMessage = state.message;
          });

          // If the request was from manual input,
          // keep the user in manual mode.
          if (wasManualInput) {
            Future.delayed(const Duration(milliseconds: 150), () {
              if (!mounted || !_isManualInputMode) return;

              _studentCodeController.clear();
              _studentCodeFocusNode.requestFocus();
            });
          }

          return;
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,

        // ======================================================
        // APP BAR
        // ======================================================
        appBar: AppBar(
          title: const Text('Payment Scanner'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(
                _isManualInputMode ? Icons.qr_code_scanner : Icons.edit,
              ),
              onPressed: _isScanning ? null : _toggleManualInputMode,
              tooltip: _isManualInputMode
                  ? 'Switch to QR Scan'
                  : 'Enter Student Code',
            ),
          ],
        ),

        // ======================================================
        // BODY
        // ======================================================
        body: Stack(
          children: [
            // ==================================================
            // CAMERA AREA
            // ==================================================
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: MediaQuery.of(context).size.height * 0.55,
              child: _hasPermission
                  ? Stack(
                      children: [
                        // ==================================================
                        // QR SCANNER
                        // ==================================================
                        if (!_isManualInputMode)
                          MobileScanner(
                            key: const ValueKey('payment-scanner'),
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
                        // ==================================================
                        // MANUAL MODE PLACEHOLDER
                        // ==================================================
                        else
                          Container(
                            color: Colors.black87,
                            child: const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.edit,
                                    size: 60,
                                    color: Colors.white70,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'Manual Entry Mode',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Enter student code below',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        // ==================================================
                        // SCANNER OVERLAY
                        // ==================================================
                        if (!_isManualInputMode) _buildScannerOverlay(),

                        // ==================================================
                        // SCANNER STATUS
                        // ==================================================
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

            // ==================================================
            // BOTTOM PANEL
            // ==================================================
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: MediaQuery.of(context).size.height * 0.45,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 12,
                      color: Colors.black12,
                      offset: Offset(0, -3),
                    ),
                  ],
                ),
                child: _buildBottomContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // PERMISSION DENIED
  // ============================================================

  Widget _buildPermissionDenied() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.camera_alt, size: 60, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Camera Permission Required',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              'Please grant camera permission to scan QR codes.',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SCANNER OVERLAY
  // ============================================================

  Widget _buildScannerOverlay() {
    return IgnorePointer(
      child: Center(
        child: Container(
          width: 220,
          height: 220,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 3),
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SCANNER STATUS
  // ============================================================

  Widget _buildScannerStatus() {
    if (_isScanning) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 60),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
              'Processing...',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 30),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.85),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          _errorMessage!,
          style: const TextStyle(color: Colors.white, fontSize: 13),
          textAlign: TextAlign.center,
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
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.edit, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text(
              'Enter Student Code',
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
        'Scan Student QR Code',
        style: TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }

  // ============================================================
  // BOTTOM CONTENT
  // ============================================================

  Widget _buildBottomContent() {
    // Manual mode always keeps the input visible.
    if (_isManualInputMode) {
      return _buildManualInputPanel();
    }

    // QR mode error panel.
    if (_errorMessage != null) {
      return _buildErrorPanel();
    }

    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.qr_code_scanner, size: 50, color: Colors.blue),
          SizedBox(height: 12),
          Text(
            'Scan Student QR Card',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            'Point camera at the student QR code',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MANUAL INPUT
  // ============================================================

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
          const Icon(Icons.person_add, size: 50, color: Colors.blue),

          const SizedBox(height: 16),

          const Text(
            'Enter Student Code',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          const Text(
            'Type the student code',
            style: TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 24),

          // ======================================================
          // ERROR MESSAGE
          // ======================================================
          if (_errorMessage != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.red.withOpacity(0.25)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // ======================================================
          // STUDENT CODE FIELD
          // ======================================================
          TextField(
            controller: _studentCodeController,
            focusNode: _studentCodeFocusNode,
            enabled: !_isScanning,
            textCapitalization: TextCapitalization.characters,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _onManualSubmit(),
            decoration: InputDecoration(
              hintText: 'Enter student code...',
              prefixIcon: const Icon(Icons.badge),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.blue, width: 2),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ======================================================
          // BUTTONS
          // ======================================================
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _isScanning ? null : _toggleManualInputMode,
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text('Scanner'),
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
                  onPressed: _isScanning ? null : _onManualSubmit,
                  icon: const Icon(Icons.send),
                  label: const Text('Submit'),
                  style: ElevatedButton.styleFrom(
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

  // ============================================================
  // ERROR PANEL
  // ============================================================

  Widget _buildErrorPanel() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 50),

            const SizedBox(height: 12),

            Text(
              _errorMessage ?? 'Something went wrong.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.red),
            ),

            const SizedBox(height: 16),

            TextButton.icon(
              onPressed: () {
                setState(() {
                  _errorMessage = null;
                  _isScanning = false;
                });

                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  if (!mounted) return;

                  await _restartScanner();
                });
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
