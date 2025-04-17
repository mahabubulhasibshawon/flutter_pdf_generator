import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class CertificateHomePage extends StatefulWidget {
  const CertificateHomePage({super.key});

  @override
  State<CertificateHomePage> createState() => _CertificateHomePageState();
}

class _CertificateHomePageState extends State<CertificateHomePage> {
  final TextEditingController _nameController = TextEditingController();

  Future<void> _generateCertificate(String name) async {
    final pdf = pw.Document();

    final ByteData bytes = await rootBundle.load('assets/certificate.png');
    final Uint8List imageBytes = bytes.buffer.asUint8List();
    final image = pw.MemoryImage(imageBytes);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (pw.Context context) {
          return pw.Stack(
            children: [
              pw.Positioned.fill(
                child: pw.Image(image, fit: pw.BoxFit.cover),
              ),
              pw.Positioned(
                left: 0,
                right: 0,
                top: 180,
                child: pw.Center(
                  child: pw.Text(
                    "This is to Certify that "+name+"\n\nof ABC school passed the Exam",
                    // textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
              ),

              pw.Positioned(
                left: 0,
                right: 100,
                top: 380,
                child: pw.Center(
                  child: pw.Text(
                    "Exam",
                    // textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Certificate Generator'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Enter Name to Generate Certificate:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter Name',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final name = _nameController.text.trim();
                if (name.isNotEmpty) {
                  _generateCertificate(name);
                }
              },
              child: const Text('Generate PDF'),
            ),
          ],
        ),
      ),
    );
  }
}