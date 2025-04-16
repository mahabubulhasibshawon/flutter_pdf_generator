// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp();
//   }
// }

import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf_generator/certificate_home_page.dart';
import 'package:printing/printing.dart';

void main() {
  runApp(const AssignmentPDFApp());
}

class AssignmentPDFApp extends StatelessWidget {
  const AssignmentPDFApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Assignment PDF Generator',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
      ),
      home: const CertificateHomePage(),
    );
  }
}

class AssignmentFormPage extends StatefulWidget {
  const AssignmentFormPage({super.key});

  @override
  State<AssignmentFormPage> createState() => _AssignmentFormPageState();
}

class _AssignmentFormPageState extends State<AssignmentFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _nameController = TextEditingController();
  final _dateController = TextEditingController();
  final _contentController = TextEditingController();

  void _generatePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(24),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(_titleController.text,
                  style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Text('Name: ${_nameController.text}', style: const pw.TextStyle(fontSize: 14)),
              pw.Text('Date: ${_dateController.text}', style: const pw.TextStyle(fontSize: 14)),
              pw.Divider(),
              pw.Text('Assignment Content:', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Text(_contentController.text, textAlign: pw.TextAlign.justify),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _nameController.dispose();
    _dateController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Assignment to PDF')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Assignment Title'),
                validator: (value) => value!.isEmpty ? 'Please enter title' : null,
              ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Your Name'),
                validator: (value) => value!.isEmpty ? 'Please enter name' : null,
              ),
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(labelText: 'Date'),
                validator: (value) => value!.isEmpty ? 'Please enter date' : null,
              ),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: 'Assignment Content'),
                maxLines: 10,
                validator: (value) => value!.isEmpty ? 'Please enter content' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _generatePdf();
                  }
                },
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text('Export as PDF'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
