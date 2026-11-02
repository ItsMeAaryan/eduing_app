import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/sop_model.dart';
import '../repositories/sop_repository.dart';
import '../../../core/providers/ai_provider.dart';
import '../../../core/services/ai/ai_service.dart';

final sopRepositoryProvider = Provider((ref) => SopRepository());

final sopsStreamProvider = StreamProvider<List<UserSop>>((ref) {
  final repo = ref.watch(sopRepositoryProvider);
  return repo.getSopsStream();
});

final sopProvider = NotifierProvider<SopNotifier, UserSop>(() {
  return SopNotifier();
});

class SopNotifier extends Notifier<UserSop> {
  late final SopRepository _repository;
  late final AIService _aiService;

  @override
  UserSop build() {
    _repository = ref.watch(sopRepositoryProvider);
    _aiService = ref.watch(aiServiceProvider);
    _loadFromFirestore();
    return _initialData();
  }

  static UserSop _initialData() {
    return const UserSop(
      id: 'default_sop',
      universityName: '',
      targetProgram: '',
      fullContent: '',
      wordCount: 0,
      wordCountProgress: 0,
      aiSopScore: 0,
      sections: [
        SopSection(title: 'Introduction & Hook', isCompleted: false),
        SopSection(title: 'Academic Background', isCompleted: false),
        SopSection(title: 'Research & Work Experience', isCompleted: false),
        SopSection(title: 'Why This University & Program', isCompleted: false),
        SopSection(title: 'Career Goals & Conclusion', isCompleted: false),
      ],
    );
  }

  void _loadFromFirestore() {
    _repository.getSopsStream().listen((sops) {
      if (sops.isNotEmpty) {
        state = sops.first;
      }
    });
  }

  Future<void> updateContent(String newContent) async {
    final words = newContent
        .trim()
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .length;
    state = state.copyWith(
      fullContent: newContent,
      wordCount: words,
      wordCountProgress: (words / 500).clamp(0.0, 1.0),
      lastUpdated: 'Just now',
    );
    await _autoSave();
  }

  Future<void> updateTarget(
      {required String university, required String program}) async {
    state = state.copyWith(
      universityName: university,
      targetProgram: program,
      lastUpdated: 'Just now',
    );
    await _autoSave();
  }

  Future<void> generateSopWithAI({
    required String university,
    required String program,
    required String background,
    required String careerGoals,
  }) async {
    final prompt = '''
Write a compelling, professional 500-word Statement of Purpose (SOP) for a university application:
Target University: $university
Target Program: $program
Academic & Technical Background: $background
Career Goals: $careerGoals

Format the output clearly into Introduction, Background, Why $university, and Future Goals.
''';

    final generatedText = await _aiService.chat(prompt);

    if (generatedText.isNotEmpty) {
      await updateTarget(university: university, program: program);
      await updateContent(generatedText);
    }
  }

  Future<void> improveSopWithAI() async {
    final prompt = '''
Review and polish the following Statement of Purpose for grammar, tone, and impact:
${state.fullContent}

Provide an improved version with enhanced vocabulary and academic tone.
''';

    final improvedText = await _aiService.generateResponse(prompt);

    if (improvedText.isNotEmpty) {
      await updateContent(improvedText);
    }
  }

  Future<File> exportSopPdf() async {
    final pdf =
        pw.Document(title: '${state.universityName} - Statement of Purpose');

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'STATEMENT OF PURPOSE',
                style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.indigo900),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                'Target: ${state.targetProgram} — ${state.universityName}',
                style:
                    const pw.TextStyle(fontSize: 11, color: PdfColors.grey700),
              ),
              pw.Divider(thickness: 1),
              pw.SizedBox(height: 12),
              pw.Text(
                state.fullContent,
                style: const pw.TextStyle(fontSize: 11),
              ),
            ],
          );
        },
      ),
    );

    final dir = await getTemporaryDirectory();
    final file = File(
        '${dir.path}/SOP_${state.universityName.replaceAll(' ', '_')}.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  Future<void> shareSopPdf() async {
    final file = await exportSopPdf();
    await Share.shareXFiles([XFile(file.path)],
        text: 'Sharing Statement of Purpose for ${state.universityName}');
  }

  Future<void> printSopPdf() async {
    final file = await exportSopPdf();
    final bytes = await file.readAsBytes();
    await Printing.layoutPdf(onLayout: (_) async => bytes);
  }

  Future<void> _autoSave() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await _repository.create(state.id, state);
    }
  }
}
