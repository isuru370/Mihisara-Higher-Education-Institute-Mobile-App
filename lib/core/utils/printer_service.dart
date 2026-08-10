import 'dart:async';
import 'dart:developer';

import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrinterService {
  static final PrinterService _instance = PrinterService._internal();

  factory PrinterService() => _instance;

  PrinterService._internal();

  final FlutterThermalPrinter _printer = FlutterThermalPrinter.instance;

  Printer? _connectedPrinter;

  Printer? get selectedPrinter => _connectedPrinter;

  bool get isConnected => _connectedPrinter != null;

  // ---------------------------------------------------------------------------
  // Saved printer
  // ---------------------------------------------------------------------------

  Future<String?> getSavedPrinterKey() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString('saved_printer_key');
  }

  String _printerKey(Printer printer) {
    // Bluetooth
    if (printer.connectionType == ConnectionType.BLE) {
      if (printer.address != null && printer.address!.isNotEmpty) {
        return 'BLE_${printer.address}';
      }
    }

    // USB
    if (printer.connectionType == ConnectionType.USB) {
      final vendorId = printer.vendorId ?? '';
      final productId = printer.productId ?? '';

      if (vendorId.isNotEmpty || productId.isNotEmpty) {
        return 'USB_${vendorId}_$productId';
      }

      if (printer.address != null && printer.address!.isNotEmpty) {
        return 'USB_${printer.address}';
      }
    }

    // Final fallback
    return '${printer.connectionType}_${printer.name}_${printer.address}';
  }

  // ---------------------------------------------------------------------------
  // Connect
  // ---------------------------------------------------------------------------

  Future<void> connectPrinter(Printer printer) async {
    try {
      // Disconnect previous printer
      if (_connectedPrinter != null) {
        try {
          await _printer.disconnect(_connectedPrinter!);
        } catch (e) {
          log('Previous printer disconnect error: $e');
        }

        _connectedPrinter = null;
      }

      log(
        'Connecting printer => '
        'name: ${printer.name}, '
        'address: ${printer.address}, '
        'type: ${printer.connectionType}, '
        'vendorId: ${printer.vendorId}, '
        'productId: ${printer.productId}',
      );

      await _printer.connect(
        printer,
        connectionStabilizationDelay: const Duration(seconds: 2),
      );

      _connectedPrinter = printer;

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('saved_printer_key', _printerKey(printer));

      log(
        'Printer connected successfully: '
        '${printer.name} (${printer.connectionType})',
      );
    } catch (e, st) {
      log('Printer connection failed: $e', stackTrace: st);

      _connectedPrinter = null;

      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // Disconnect
  // ---------------------------------------------------------------------------

  Future<void> disconnectPrinter({bool removeSavedPrinter = true}) async {
    try {
      if (_connectedPrinter != null) {
        try {
          await _printer.disconnect(_connectedPrinter!);
        } catch (e) {
          log('Disconnect error: $e');
        }

        _connectedPrinter = null;
      }

      if (removeSavedPrinter) {
        final prefs = await SharedPreferences.getInstance();

        await prefs.remove('saved_printer_key');
      }

      log('Printer disconnected');
    } catch (e, st) {
      log('Printer disconnect failed: $e', stackTrace: st);

      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // Scan printers
  // ---------------------------------------------------------------------------

  Future<List<Printer>> getAvailablePrinters() async {
    final Map<String, Printer> printers = {};

    final completer = Completer<List<Printer>>();

    StreamSubscription<List<Printer>>? subscription;

    void addPrinters(List<Printer> devices) {
      for (final printer in devices) {
        log(
          'Found device => '
          'name: ${printer.name}, '
          'address: ${printer.address}, '
          'type: ${printer.connectionType}, '
          'vendorId: ${printer.vendorId}, '
          'productId: ${printer.productId}',
        );

        final key = _printerKey(printer);

        if (!printers.containsKey(key)) {
          printers[key] = printer;
        }
      }
    }

    subscription = _printer.devicesStream.listen(
      (devices) {
        addPrinters(devices);
      },
      onError: (Object error, StackTrace stackTrace) {
        log('Device stream error: $error', stackTrace: stackTrace);

        // Bluetooth off error එකක් නම් USB devices තිබුණොත්
        // ඒවා return කරන්න.
        if (!completer.isCompleted) {
          if (_isBluetoothOffError(error)) {
            completer.complete(printers.values.toList());
          } else {
            completer.completeError(error, stackTrace);
          }
        }
      },
      cancelOnError: false,
    );

    try {
      await _printer.getPrinters(
        connectionTypes: [ConnectionType.BLE, ConnectionType.USB],
        refreshDuration: const Duration(seconds: 5),
      );

      // devicesStream එකට devices එන්න පොඩි time එකක් දෙන්න.
      await Future.delayed(const Duration(seconds: 5));

      if (!completer.isCompleted) {
        completer.complete(printers.values.toList());
      }
    } catch (e, st) {
      log('Printer scan error: $e', stackTrace: st);

      if (!completer.isCompleted) {
        if (_isBluetoothOffError(e)) {
          completer.complete(printers.values.toList());
        } else {
          completer.completeError(e, st);
        }
      }
    } finally {
      await subscription?.cancel();
    }

    final result = await completer.future;

    log('Total printers found: ${result.length}');

    return result;
  }

  // ---------------------------------------------------------------------------
  // Bluetooth off detection
  // ---------------------------------------------------------------------------

  bool _isBluetoothOffError(Object error) {
    final message = error.toString().toLowerCase();

    return message.contains('bluetooth is turned off') ||
        message.contains('bluetooth off') ||
        message.contains('bluetooth disabled');
  }

  // ---------------------------------------------------------------------------
  // Auto reconnect
  // ---------------------------------------------------------------------------

  Future<bool> autoReconnect() async {
    try {
      final savedKey = await getSavedPrinterKey();

      if (savedKey == null || savedKey.isEmpty) {
        log('No saved printer');
        return false;
      }

      log('Trying auto reconnect for: $savedKey');

      final printers = await getAvailablePrinters();

      Printer? printer;

      for (final item in printers) {
        final key = _printerKey(item);

        if (key == savedKey) {
          printer = item;
          break;
        }
      }

      if (printer == null) {
        log('Saved printer not found');

        return false;
      }

      await connectPrinter(printer);

      log('Auto reconnect successful');

      return true;
    } catch (e, st) {
      log('Auto reconnect failed: $e', stackTrace: st);

      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // Select printer
  // ---------------------------------------------------------------------------

  Future<void> selectPrinter(Printer printer) async {
    await connectPrinter(printer);
  }

  // ---------------------------------------------------------------------------
  // Print
  // ---------------------------------------------------------------------------

  Future<void> printData(List<int> data) async {
    if (_connectedPrinter == null) {
      throw Exception('Printer not connected');
    }

    if (data.isEmpty) {
      throw Exception('Print data is empty');
    }

    const chunkSize = 100;

    log('Print bytes length: ${data.length}');

    for (int i = 0; i < data.length; i += chunkSize) {
      final end = (i + chunkSize > data.length) ? data.length : i + chunkSize;

      final chunk = data.sublist(i, end);

      log('Sending chunk: $i - $end');

      await _printer.printData(_connectedPrinter!, chunk);

      // BLE printer වල buffer issue avoid කරන්න.
      // USB වලදී මේ delay එක අවශ්‍ය නැති වෙන්න පුළුවන්,
      // නමුත් common flow එකක් විදිහට තියාගන්න පුළුවන්.
      if (_connectedPrinter!.connectionType == ConnectionType.BLE) {
        await Future.delayed(const Duration(milliseconds: 120));
      }
    }

    log('Print completed');
  }
}
