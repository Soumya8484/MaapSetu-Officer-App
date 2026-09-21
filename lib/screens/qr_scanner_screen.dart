import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final MobileScannerController controller = MobileScannerController();

  bool _isProcessing = false;

  Future<void> _handleScan(String value) async {
    if (_isProcessing) return;

    if (!value.contains('maap-setu-two.vercel.app/verify/')) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This is not a valid MaapSetu certificate QR.'),
        ),
      );

      return;
    }

    setState(() {
      _isProcessing = true;
    });

    await controller.stop();

    final uri = Uri.tryParse(value);

    if (uri != null) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }

    if (!mounted) return;

    setState(() {
      _isProcessing = false;
    });

    await controller.start();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF123B6D),
        foregroundColor: Colors.white,
        title: const Text(
          'Scan Certificate QR',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: (capture) {
              if (capture.barcodes.isEmpty) return;

              final barcode = capture.barcodes.first;
              final value = barcode.rawValue;

              if (value != null && value.isNotEmpty) {
                _handleScan(value);
              }
            },
          ),

          Center(
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 70,
            child: Column(
              children: [
                const Text(
                  'Scan a MaapSetu certificate QR code',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Point your camera at the QR code',
                  style: TextStyle(
                    color: Colors.white.withOpacity(.8),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          if (_isProcessing)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}