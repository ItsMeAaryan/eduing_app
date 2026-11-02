// Offer letters, admit cards and enrollment certificates are saved as data by
// the university (no file storage). This renders them as a PDF on the phone and
// opens the system print / save-as-PDF sheet. Same contents as the website.
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:url_launcher/url_launcher.dart';

const _purple = PdfColor.fromInt(0xFF4B2FC9);
const _ink = PdfColor.fromInt(0xFF17142B);
const _muted = PdfColor.fromInt(0xFF6E6A80);

String _date(String? iso) {
  final d = iso == null ? null : DateTime.tryParse(iso);
  return d == null ? (iso ?? '') : DateFormat('d MMMM yyyy').format(d.toLocal());
}

pw.Widget _row(String label, String? value) => (value == null || value.isEmpty)
    ? pw.SizedBox()
    : pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 6),
        child: pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.SizedBox(width: 140, child: pw.Text(label, style: const pw.TextStyle(color: _muted, fontSize: 10.5))),
          pw.Expanded(child: pw.Text(value, style: pw.TextStyle(color: _ink, fontSize: 10.5, fontWeight: pw.FontWeight.bold))),
        ]),
      );

pw.Document buildIssuedPdf(String type, Map<String, dynamic> raw) {
  // The built-in PDF font has no ₹ / curly quotes / dashes — swap them for plain characters.
  String clean(String v) => v
      .replaceAll('₹', 'Rs. ')
      .replaceAll(RegExp('[\u2018\u2019]'), "'")
      .replaceAll(RegExp('[\u201C\u201D]'), '"')
      .replaceAll(RegExp('[\u2013\u2014]'), '-')
      .replaceAll('\u00B7', '|');
  final d = raw.map((k, v) => MapEntry(k, clean(v?.toString() ?? '')));
  final uni = d['universityName'] ?? 'University';
  final title = const {'offer_letter': 'Offer of Admission', 'admit_card': 'Admit Card', 'enrollment_certificate': 'Enrollment Certificate'}[type] ?? 'Document';
  final doc = pw.Document(title: '$title — ${d['studentName'] ?? ''}', author: uni);

  final body = <pw.Widget>[];
  if (type == 'offer_letter') {
    body.addAll([
      pw.Text('Date: ${_date(d['date'])}', style: const pw.TextStyle(color: _muted, fontSize: 10.5)),
      pw.SizedBox(height: 14),
      pw.Text('Dear ${d['studentName']},', style: const pw.TextStyle(fontSize: 11.5)),
      pw.SizedBox(height: 10),
      pw.Text(
        'We are pleased to offer you admission to ${d['programName']} at $uni for the academic year ${d['academicYear'] ?? ''}. '
        'This offer is subject to verification of your original documents at the time of reporting.',
        style: const pw.TextStyle(fontSize: 11.5, lineSpacing: 3),
      ),
      pw.SizedBox(height: 14),
      _row('Application ID', d['applicationId']),
      _row('Program', d['programName']),
      _row('Department', d['department']),
      _row('Fees', d['feeSummary']),
      _row('Accept by', _date(d['lastAcceptanceDate'])),
      pw.SizedBox(height: 14),
      pw.Text('Please accept or decline this offer on EDUING before the date above.', style: const pw.TextStyle(fontSize: 11.5)),
    ]);
  } else if (type == 'admit_card') {
    body.addAll([
      _row('Candidate', d['studentName']),
      _row('Roll number', d['rollNumber']),
      _row('Application ID', d['applicationId']),
      _row('Program', d['programName']),
      _row('Examination', d['examName']),
      _row('Date', _date(d['examDate'])),
      _row('Time', d['examTime']),
      _row('Reporting time', d['reportingTime']),
      _row('Venue', d['venue']),
      if ((d['instructions'] ?? '').isNotEmpty) ...[
        pw.SizedBox(height: 12),
        pw.Text('Instructions', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: _ink)),
        pw.SizedBox(height: 4),
        pw.Text(d['instructions']!, style: const pw.TextStyle(fontSize: 10.5, lineSpacing: 2)),
      ],
      pw.SizedBox(height: 12),
      pw.Text('Carry this admit card and a photo ID to the examination centre.', style: const pw.TextStyle(fontSize: 10.5, color: _muted)),
    ]);
  } else {
    body.addAll([
      pw.Text(
        'This is to certify that ${d['studentName']} is enrolled in ${d['programName']} at $uni for the academic session ${d['academicSession'] ?? ''}.',
        style: const pw.TextStyle(fontSize: 12, lineSpacing: 3),
      ),
      pw.SizedBox(height: 14),
      _row('Enrollment number', d['enrollmentNumber']),
      _row('Department', d['department']),
      _row('Date of issue', _date(d['date'])),
    ]);
  }

  doc.addPage(pw.Page(
    pageFormat: PdfPageFormat.a4,
    margin: const pw.EdgeInsets.all(48),
    build: (_) => pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
      pw.Text(uni, style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold, color: _purple)),
      pw.Text(d['department'] ?? 'Admissions Office', style: const pw.TextStyle(fontSize: 10.5, color: _muted)),
      pw.Divider(color: _purple, thickness: 1.5),
      pw.SizedBox(height: 10),
      pw.Text(title.toUpperCase(), style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, letterSpacing: 1, color: _ink)),
      pw.SizedBox(height: 16),
      ...body,
      pw.Spacer(),
      pw.Divider(color: PdfColors.grey300),
      pw.Text('Issued through EDUING | eduing.in', style: const pw.TextStyle(fontSize: 9, color: _muted)),
    ]),
  ));
  return doc;
}

/// Opens an issued document: renders it from data, or opens the old file link.
Future<void> openIssuedDocument(BuildContext context, Map<String, dynamic>? issued) async {
  if (issued == null) return;
  final data = issued['data'];
  if (data is Map) {
    final type = (issued['type'] ?? '').toString();
    final pdf = buildIssuedPdf(type, Map<String, dynamic>.from(data));
    await Printing.layoutPdf(name: '${type.replaceAll('_', '-')}.pdf', onLayout: (_) => pdf.save());
    return;
  }
  final url = issued['url'] as String?;
  if (url != null && url.isNotEmpty) {
    final ok = await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    if (ok) return;
  }
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('This document isn’t available. Ask the university to issue it again.')));
  }
}
