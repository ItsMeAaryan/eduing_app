import 'package:eduing_app/features/applications/data/admission_service.dart';
import 'package:eduing_app/features/applications/data/issued_document_pdf.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('snapshot reads flat keys and older onboarding maps', () {
    final s = buildProfileSnapshot({
      'fullName': 'Riya',
      'personal': {'phone': '9876543210'},
      'academic': {'marks12': '88.4', 'board12': 'CBSE'},
      'exams': {'jeeMain': '97.1'},
      'category': 'OBC-NCL',
      'unrelated': 'x',
    });
    expect(s['fullName'], 'Riya');
    expect(s['phone'], '9876543210');
    expect(s['twelfthScore'], '88.4');
    expect(s['twelfthBoard'], 'CBSE');
    expect(s['jeeScore'], '97.1');
    expect(s['category'], 'OBC-NCL');
    expect(s.containsKey('unrelated'), isFalse);
    expect(s.containsKey('sharedAt'), isTrue);
  });

  test('status helpers', () {
    expect(normalizeStatus('accepted'), 'selected');
    expect(stageOf('enrolled'), 7);
    expect(statusLabel('offer_declined'), 'Offer declined');
  });

  test('issued documents render to a PDF', () async {
    for (final type in ['offer_letter', 'admit_card', 'enrollment_certificate']) {
      final bytes = await buildIssuedPdf(type, {
        'universityName': 'Test University', 'studentName': 'Riya', 'programName': 'B.Tech CSE',
        'date': '2026-11-02T00:00:00.000Z', 'lastAcceptanceDate': '2026-11-16T00:00:00.000Z',
      }).save();
      expect(bytes.length, greaterThan(500));
    }
  });
}
