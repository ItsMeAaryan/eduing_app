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

final sopProvider = StateNotifierProvider<SopNotifier, UserSop>((ref) {
  final repo = ref.watch(sopRepositoryProvider);
  final aiService = ref.watch(aiServiceProvider);
  return SopNotifier(repo, aiService);
});

class SopNotifier extends StateNotifier<UserSop> {
  final SopRepository _repository;
  final AIService _aiService;

  SopNotifier(this._repository, this._aiService) : super(_initialData()) {
    _loadFromFirestore();
  }

  static UserSop _initialData() {
    return const UserSop(
      id: 'default_sop',
      universityName: 'Stanford University',
      targetProgram: 'M.S. in Computer Science',
      fullContent: '''
Statement of Purpose

My fascination with Artificial Intelligence began during my undergraduate studies in Computer Science when I built a real-time object classification engine for low-resource embedded systems. This experience demonstrated how intelligent algorithms can democratize access to advanced technology.

I am applying to the Master of Science in Computer Science program at Stanford University to deepen my expertise in Deep Learning and Distributed Systems. Stanford's world-renowned AI Lab and pioneering research in foundation models align perfectly with my long-term career goal of building scalable, privacy-preserving AI systems.

During my undergraduate career, I maintained a 3.9 GPA while serving as a Research Assistant in the Vision and Learning Lab. I led the development of lightweight neural network pruning methods, resulting in a 35% reduction in model inference latency. In addition to academic research, my software engineering internship at Tech Corp gave me practical experience in designing high-throughput distributed microservices.

At Stanford, I am particularly eager to work under the guidance of leading faculty in automated machine learning and computer vision. I intend to contribute actively to student research groups and collaborate with peers from diverse backgrounds.

Upon completing my degree, I plan to lead research initiatives in ethical AI deployment, bridging the gap between cutting-edge algorithmic discoveries and impactful real-world applications. Stanford's rigorous academic environment and collaborative ecosystem will provide the ideal foundation for achieving these aspirations.
''',
      wordCount: 320,
      wordCountProgress: 0.64,
      aiSopScore: 90,
      sections: [
        SopSection(title: 'Introduction & Hook', isCompleted: true),
        SopSection(title: 'Academic Background', isCompleted: true),
        SopSection(title: 'Research & Work Experience', isCompleted: true),
        SopSection(title: 'Why This University & Program', isCompleted: true),
        SopSection(title: 'Career Goals & Conclusion', isCompleted: true),
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
