import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/university_model.dart';

final universitiesProvider = StateNotifierProvider<UniversitiesNotifier, List<University>>((ref) {
  return UniversitiesNotifier();
});

class UniversitiesNotifier extends StateNotifier<List<University>> {
  UniversitiesNotifier() : super(_initialData);

  void toggleFavorite(String id) {
    state = state.map((uni) {
      if (uni.id == id) {
        return uni.copyWith(isFavorite: !uni.isFavorite);
      }
      return uni;
    }).toList();
  }

  static const List<University> _initialData = [
    University(
      id: '1',
      name: 'BITS Pilani',
      location: 'Pilani, Rajasthan',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/BITS_Pilani_clock_tower.jpg/1200px-BITS_Pilani_clock_tower.jpg',
      logoUrl: 'https://upload.wikimedia.org/wikipedia/en/thumb/d/d3/BITS_Pilani-Logo.svg/1200px-BITS_Pilani-Logo.svg.png',
      aiMatch: 95,
      rating: 4.8,
      nirfRanking: 'NIRF #1',
      accreditation: 'A++',
      type: 'Deemed',
      established: 'Est. 1964',
      course: 'B.Tech Computer Science',
      fees: '₹4.81 L / year',
      placementScore: 96,
      roiScore: 94,
      researchScore: 88,
      tags: ['Scholarships', 'Hostel', 'Placements', '+2'],
      studentCount: '+12K Students',
    ),
    University(
      id: '2',
      name: 'Indian Institute of Technology Bombay',
      location: 'Mumbai, Maharashtra',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/ca/IIT_Bombay_Main_Building.jpg/1200px-IIT_Bombay_Main_Building.jpg',
      logoUrl: 'https://upload.wikimedia.org/wikipedia/en/thumb/f/f3/IIT_Bombay_logo.svg/1200px-IIT_Bombay_logo.svg.png',
      aiMatch: 94,
      rating: 4.7,
      nirfRanking: 'NIRF #2',
      accreditation: 'A++',
      type: 'Public',
      established: 'Est. 1958',
      course: 'B.Tech Computer Science',
      fees: '₹2.4 L / year',
      placementScore: 99,
      roiScore: 98,
      researchScore: 99,
      tags: ['Scholarships', 'Hostel', 'Research', '+3'],
      studentCount: '+18K Students',
    ),
    University(
      id: '3',
      name: 'Delhi University',
      location: 'New Delhi, Delhi',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5a/Delhi_University_VC_Office.jpg/1200px-Delhi_University_VC_Office.jpg',
      logoUrl: 'https://upload.wikimedia.org/wikipedia/en/thumb/b/b4/University_of_Delhi_coat_of_arms.svg/1200px-University_of_Delhi_coat_of_arms.svg.png',
      aiMatch: 93,
      rating: 4.6,
      nirfRanking: 'NIRF #3',
      accreditation: 'A++',
      type: 'Public',
      established: 'Est. 1922',
      course: 'B.Sc (Hons) Computer Science',
      fees: '₹72K / year',
      placementScore: 84,
      roiScore: 82,
      researchScore: 87,
      tags: ['Scholarships', 'Hostel', 'Placements', '+2'],
      studentCount: '+25K Students',
      isFavorite: true,
    ),
    University(
      id: '4',
      name: 'VIT Vellore',
      location: 'Vellore, Tamil Nadu',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/05/VIT_Vellore_Main_Building.jpg/1200px-VIT_Vellore_Main_Building.jpg',
      logoUrl: 'https://upload.wikimedia.org/wikipedia/en/thumb/c/c5/Vellore_Institute_of_Technology_seal_2017.svg/1200px-Vellore_Institute_of_Technology_seal_2017.svg.png',
      aiMatch: 92,
      rating: 4.5,
      nirfRanking: 'NIRF #4',
      accreditation: 'A+',
      type: 'Private',
      established: 'Est. 1984',
      course: 'B.Tech Computer Science',
      fees: '₹2.11 L / year',
      placementScore: 92,
      roiScore: 90,
      researchScore: 85,
      tags: ['Scholarships', 'Hostel', 'Placements', '+1'],
      studentCount: '+15K Students',
    ),
  ];
}
