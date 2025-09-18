import 'dart:typed_data';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';

class PrinterServices {
  static final BluetoothManager _bluetooth = BluetoothManager.instance;

  /// Print plain-text receipt via 58 mm thermal printer
  static Future<void> printReceipt(String text) async {
    // 1. Capability profile & generator
    final profile = await CapabilityProfile.load();
    final generator = await Generator(PaperSize.mm58, profile);

    // 2. Build bytes
    List<int> bytes = [];
    bytes += generator.reset();
    bytes += generator.text('Resto',
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ));
    bytes += generator.text(text);
    bytes += generator.feed(1);
    bytes += generator.cut();

    // 3. Scan & connect
    final devices =
        await _bluetooth.startScan(timeout: const Duration(seconds: 3));
    if (devices.isEmpty) throw Exception('Printer tidak ditemukan');
    final device = devices.first;

    await _bluetooth.connect(device);
    await _bluetooth.writeData(Uint8List.fromList(bytes));
    await Future.delayed(const Duration(milliseconds: 500)); // let buffer flush
    await _bluetooth.disconnect();
  }
}
