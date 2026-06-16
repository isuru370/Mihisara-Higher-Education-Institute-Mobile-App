import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/printer_service.dart';

class PrintTestPage extends StatefulWidget {
  const PrintTestPage({super.key});

  @override
  State<PrintTestPage> createState() => _PrintTestPageState();
}

class _PrintTestPageState extends State<PrintTestPage> {
  final PrinterService _printerService = PrinterService();

  List<Printer> _printers = [];

  Printer? _selectedPrinter;

  bool _isScanning = false;
  bool _isConnecting = false;
  bool _isPrinting = false;

  String _status = 'Ready';

  bool _isBluetoothOffError(Object e) {
    return e.toString().toLowerCase().contains('bluetooth is turned off');
  }

  Future<bool> _checkBluetoothEnabled() async {
    try {
      final state = await FlutterBluePlus.adapterState.first;

      return state == BluetoothAdapterState.on;
    } catch (e) {
      return false;
    }
  }

  Future<void> _requestBluetoothPermissions() async {
    await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();
  }

  void _showSnack(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _scanPrinters() async {
    setState(() {
      _isScanning = true;

      _status = 'Scanning for printers...';

      _printers = [];

      _selectedPrinter = null;
    });

    try {
      await _requestBluetoothPermissions();
      final isBluetoothOn = await _checkBluetoothEnabled();

      if (!isBluetoothOn) {
        throw Exception('Bluetooth is OFF. Please enable Bluetooth.');
      }

      final printers = await _printerService.getAvailablePrinters();

      if (!mounted) return;

      setState(() {
        _printers = printers;

        _status = printers.isEmpty
            ? 'No printers found'
            : '${printers.length} printer(s) found';

        if (printers.isNotEmpty) {
          _selectedPrinter = printers.first;
        }
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _status = e.toString();
      });

      _showSnack(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isScanning = false;
        });
      }
    }
  }

  Future<void> _connectSelectedPrinter() async {
    final printer = _selectedPrinter;

    if (printer == null) {
      _showSnack('Please select printer first');

      return;
    }

    setState(() {
      _isConnecting = true;

      _status = 'Connecting to ${printer.name ?? 'printer'}';
    });

    try {
      await _printerService.connectPrinter(printer);

      if (!mounted) return;

      setState(() {
        _status = 'Connected successfully';
      });

      _showSnack('Printer connected');
    } catch (e) {
      if (!mounted) return;

      final bluetoothOff = _isBluetoothOffError(e);

      setState(() {
        _status = bluetoothOff ? 'Bluetooth is OFF' : 'Connection failed';
      });

      _showSnack(
        bluetoothOff ? 'Please enable Bluetooth' : 'Connection failed',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isConnecting = false;
        });
      }
    }
  }

  Future<void> _disconnectPrinter() async {
    setState(() {
      _status = 'Disconnecting...';
    });

    try {
      await _printerService.disconnectPrinter();

      if (!mounted) return;

      setState(() {
        _status = 'Disconnected';
      });

      _showSnack('Printer disconnected');
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _status = 'Disconnect failed';
      });
    }
  }

  Future<void> _testPrint() async {
    if (!_printerService.isConnected) {
      _showSnack('Printer not connected');

      return;
    }

    setState(() {
      _isPrinting = true;

      _status = 'Printing...';
    });

    try {
      final bytes = <int>[
        0x1B,
        0x40,

        0x1B,
        0x61,
        0x01,

        ...'MINIPALASA EDUCATION CENTRE\n'.codeUnits,

        ...'TEST PRINT\n'.codeUnits,

        ...'Printer Connected\n'.codeUnits,

        0x0A,
        0x0A,

        0x1D,
        0x56,
        0x00,
      ];

      await _printerService.printData(bytes);

      if (!mounted) return;

      setState(() {
        _status = 'Print completed';
      });

      _showSnack('Printed successfully');
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _status = 'Print failed';
      });

      _showSnack('Print failed');
    } finally {
      if (mounted) {
        setState(() {
          _isPrinting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final connected = _printerService.isConnected;

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        elevation: 0,

        centerTitle: true,

        backgroundColor: AppColors.primary,

        foregroundColor: Colors.white,

        title: const Text(
          'Printer Manager',

          style: TextStyle(fontWeight: FontWeight.w800),
        ),

        actions: [
          IconButton(
            onPressed: _isScanning ? null : _scanPrinters,

            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: _scanPrinters,

        child: ListView(
          padding: const EdgeInsets.all(18),

          children: [
            // HERO CARD
            Container(
              padding: const EdgeInsets.all(24),

              decoration: BoxDecoration(
                gradient: AppColors.heroGradient,

                borderRadius: BorderRadius.circular(30),

                boxShadow: AppColors.largeShadow,
              ),

              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,

                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.12),

                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: const Icon(
                      Icons.print_rounded,

                      color: Colors.white,

                      size: 34,
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        const Text(
                          'Bluetooth Printer',

                          style: TextStyle(
                            color: Colors.white70,

                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 4),

                        const Text(
                          'Printer Management',

                          style: TextStyle(
                            color: Colors.white,

                            fontSize: 22,

                            fontWeight: FontWeight.w800,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          _status,

                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // INFO CARD
            Container(
              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.circular(26),

                boxShadow: AppColors.softShadow,
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),

                        decoration: BoxDecoration(
                          color: AppColors.info.withOpacity(.10),

                          borderRadius: BorderRadius.circular(14),
                        ),

                        child: const Icon(
                          Icons.info_outline_rounded,

                          color: AppColors.info,
                        ),
                      ),

                      const SizedBox(width: 12),

                      const Expanded(
                        child: Text(
                          'Printer Information',

                          style: TextStyle(
                            fontSize: 18,

                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  _infoRow(
                    'Selected Printer',
                    _printerService.selectedPrinter?.name ?? 'None',
                  ),

                  _infoRow(
                    'Connection',
                    connected ? 'Connected' : 'Disconnected',
                  ),

                  _infoRow('Status', _status),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // SELECT PRINTER
            Container(
              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.circular(26),

                boxShadow: AppColors.softShadow,
              ),

              child: DropdownButtonFormField<Printer>(
                initialValue: _selectedPrinter,

                decoration: InputDecoration(
                  labelText: 'Select Printer',

                  filled: true,

                  fillColor: AppColors.background,

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),

                    borderSide: BorderSide.none,
                  ),
                ),

                items: _printers.map((printer) {
                  return DropdownMenuItem<Printer>(
                    value: printer,

                    child: Text(
                      printer.name ?? 'Unknown Printer',

                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),

                onChanged: (printer) {
                  setState(() {
                    _selectedPrinter = printer;
                  });
                },
              ),
            ),

            const SizedBox(height: 20),

            // BUTTONS
            Row(
              children: [
                Expanded(
                  child: _actionButton(
                    label: 'Scan',

                    icon: Icons.search_rounded,

                    loading: _isScanning,

                    color: AppColors.primary,

                    onTap: _scanPrinters,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _actionButton(
                    label: 'Connect',

                    icon: Icons.bluetooth_connected_rounded,

                    loading: _isConnecting,

                    color: AppColors.success,

                    onTap: _connectSelectedPrinter,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _actionButton(
                    label: 'Disconnect',

                    icon: Icons.link_off_rounded,

                    color: AppColors.danger,

                    onTap: connected ? _disconnectPrinter : null,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _actionButton(
                    label: 'Test Print',

                    icon: Icons.print_rounded,

                    loading: _isPrinting,

                    color: AppColors.warning,

                    onTap: connected ? _testPrint : null,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            const Text(
              'Available Printers',

              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),

            const SizedBox(height: 14),

            if (_printers.isEmpty)
              Container(
                padding: const EdgeInsets.all(28),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(28),

                  boxShadow: AppColors.softShadow,
                ),

                child: Column(
                  children: [
                    Icon(
                      Icons.print_disabled_rounded,

                      size: 80,

                      color: Colors.grey.shade400,
                    ),

                    const SizedBox(height: 16),

                    Text(
                      'No Printers Found',

                      style: TextStyle(
                        fontSize: 20,

                        fontWeight: FontWeight.w800,

                        color: Colors.grey.shade800,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Tap scan to search Bluetooth printers',

                      textAlign: TextAlign.center,

                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              )
            else
              ..._printers.map((printer) {
                final isSelected = printer.address == _selectedPrinter?.address;

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),

                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius: BorderRadius.circular(24),

                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : Colors.grey.shade200,
                      width: isSelected ? 2 : 1,
                    ),

                    boxShadow: AppColors.softShadow,
                  ),

                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),

                    leading: Container(
                      width: 52,
                      height: 52,

                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(.10),

                        borderRadius: BorderRadius.circular(16),
                      ),

                      child: const Icon(
                        Icons.print_rounded,

                        color: AppColors.primary,
                      ),
                    ),

                    title: Text(
                      printer.name ?? 'Unknown Printer',

                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),

                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),

                      child: Text(printer.address ?? '-'),
                    ),

                    trailing: isSelected
                        ? const Icon(
                            Icons.check_circle_rounded,

                            color: AppColors.success,
                          )
                        : null,

                    onTap: () {
                      setState(() {
                        _selectedPrinter = printer;
                      });
                    },
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _actionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback? onTap,
    bool loading = false,
  }) {
    return SizedBox(
      height: 56,

      child: ElevatedButton.icon(
        onPressed: loading ? null : onTap,

        icon: loading
            ? const SizedBox(
                width: 18,
                height: 18,

                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Icon(icon),

        label: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),

        style: ElevatedButton.styleFrom(
          elevation: 0,

          backgroundColor: color,

          foregroundColor: Colors.white,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),

      child: Row(
        children: [
          Expanded(
            child: Text(
              title,

              style: TextStyle(
                color: Colors.grey.shade700,

                fontWeight: FontWeight.w600,
              ),
            ),
          ),

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
}
