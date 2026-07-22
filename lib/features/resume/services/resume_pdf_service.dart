import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/resume_model.dart';

class ResumePdfService {
  Future<pw.Document> generateResumePdf(UserResume resume) async {
    final pdf = pw.Document(
      title: '${resume.fullName} - Resume',
      author: resume.fullName,
    );

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Text(
                resume.fullName.isNotEmpty ? resume.fullName : 'John Doe',
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                '${resume.email} • ${resume.phone} • ${resume.location}',
                style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
              ),
              pw.Divider(thickness: 1, color: PdfColors.grey300),
              pw.SizedBox(height: 12),

              // Summary Section
              if (resume.summary.isNotEmpty) ...[
                _buildSectionHeader('PROFESSIONAL SUMMARY'),
                pw.SizedBox(height: 4),
                pw.Text(
                  resume.summary,
                  style: const pw.TextStyle(fontSize: 10),
                ),
                pw.SizedBox(height: 14),
              ],

              // Education Section
              if (resume.education.isNotEmpty) ...[
                _buildSectionHeader('EDUCATION'),
                pw.SizedBox(height: 4),
                ...resume.education.map((edu) => pw.Bullet(text: edu, style: const pw.TextStyle(fontSize: 10))),
                pw.SizedBox(height: 14),
              ],

              // Experience Section
              if (resume.experience.isNotEmpty) ...[
                _buildSectionHeader('WORK EXPERIENCE'),
                pw.SizedBox(height: 4),
                ...resume.experience.map((exp) => pw.Bullet(text: exp, style: const pw.TextStyle(fontSize: 10))),
                pw.SizedBox(height: 14),
              ],

              // Skills Section
              if (resume.skills.isNotEmpty) ...[
                _buildSectionHeader('SKILLS & COMPETENCIES'),
                pw.SizedBox(height: 4),
                pw.Text(
                  resume.skills.join(' • '),
                  style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey900),
                ),
                pw.SizedBox(height: 14),
              ],

              // Projects Section
              if (resume.projects.isNotEmpty) ...[
                _buildSectionHeader('PROJECTS & ACHIEVEMENTS'),
                pw.SizedBox(height: 4),
                ...resume.projects.map((proj) => pw.Bullet(text: proj, style: const pw.TextStyle(fontSize: 10))),
              ],
            ],
          );
        },
      ),
    );

    return pdf;
  }

  pw.Widget _buildSectionHeader(String title) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800),
        ),
        pw.SizedBox(height: 2),
        pw.Container(height: 1, color: PdfColors.blue800, width: double.infinity),
      ],
    );
  }

  Future<File> savePdfFile(UserResume resume) async {
    final pdf = await generateResumePdf(resume);
    final outputDir = await getTemporaryDirectory();
    final file = File("${outputDir.path}/${resume.fullName.replaceAll(' ', '_')}_Resume.pdf");
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  Future<void> printOrExportPdf(UserResume resume) async {
    final pdf = await generateResumePdf(resume);
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: '${resume.fullName} Resume',
    );
  }

  Future<void> shareResumePdf(UserResume resume) async {
    final file = await savePdfFile(resume);
    await Share.shareXFiles([XFile(file.path)], text: 'Sharing Resume PDF for ${resume.fullName}');
  }
}
