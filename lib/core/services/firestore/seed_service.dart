import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Seeds initial test data into Firestore if the collection is empty.
/// Safe to call on every app start — it's a no-op if data already exists.
class SeedService {
  static final _db = FirebaseFirestore.instance;

  static Future<void> seedIfEmpty() async {
    try {
      final snap = await _db.collection('universities').limit(1).get();
      if (snap.docs.isNotEmpty) return; // Already seeded

      debugPrint('[SeedService] Seeding initial university data…');

      final unis = [
        {
          'name': 'BITS Pilani',
          'shortName': 'BITS',
          'type': 'Engineering',
          'location': {'city': 'Pilani', 'state': 'Rajasthan'},
          'rankings': {'nirfOverall': 1},
          'approvalStatus': 'approved',
          'feesPerYear': 1800000,
          'totalSeats': 120,
          'about':
              'One of India\'s premier private engineering universities, known for its rigorous curriculum and research culture.',
          'logoUrl': '',
          'color': 'blue',
          'applicationDeadline': null,
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'name': 'Delhi University',
          'shortName': 'DU',
          'type': 'Arts',
          'location': {'city': 'New Delhi', 'state': 'Delhi'},
          'rankings': {'nirfOverall': 3},
          'approvalStatus': 'approved',
          'feesPerYear': 15000,
          'totalSeats': 200,
          'about':
              'Central university in the heart of Delhi offering a wide range of undergraduate and postgraduate programs.',
          'logoUrl': '',
          'color': 'yellow',
          'applicationDeadline': null,
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'name': 'VIT Vellore',
          'shortName': 'VIT',
          'type': 'Engineering',
          'location': {'city': 'Vellore', 'state': 'Tamil Nadu'},
          'rankings': {'nirfOverall': 11},
          'approvalStatus': 'approved',
          'feesPerYear': 350000,
          'totalSeats': 300,
          'about':
              'Top-ranked private university in South India with strong industry connections and placement records.',
          'logoUrl': '',
          'color': 'green',
          'applicationDeadline': null,
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'name': 'IIM Ahmedabad',
          'shortName': 'IIMA',
          'type': 'Management',
          'location': {'city': 'Ahmedabad', 'state': 'Gujarat'},
          'rankings': {'nirfOverall': 1},
          'approvalStatus': 'approved',
          'feesPerYear': 2300000,
          'totalSeats': 385,
          'about':
              'India\'s top business school, renowned for its MBA program and global alumni network.',
          'logoUrl': '',
          'color': 'purple',
          'applicationDeadline': null,
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'name': 'AIIMS New Delhi',
          'shortName': 'AIIMS',
          'type': 'Medicine',
          'location': {'city': 'New Delhi', 'state': 'Delhi'},
          'rankings': {'nirfOverall': 1},
          'approvalStatus': 'approved',
          'feesPerYear': 1500,
          'totalSeats': 107,
          'about':
              'India\'s most prestigious medical institution, offering MBBS, MD, and research programs.',
          'logoUrl': '',
          'color': 'red',
          'applicationDeadline': null,
          'createdAt': FieldValue.serverTimestamp(),
        },
      ];

      final batch = _db.batch();
      for (final uni in unis) {
        final ref = _db.collection('universities').doc();
        batch.set(ref, uni);
      }
      await batch.commit();
      debugPrint('[SeedService] Seeded ${unis.length} universities ✓');
    } catch (e) {
      debugPrint('[SeedService] Seed failed (non-fatal): $e');
    }
  }
}
