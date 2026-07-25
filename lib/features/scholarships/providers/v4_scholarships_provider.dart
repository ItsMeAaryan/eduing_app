import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/neo_design_system.dart';

class V4Scholarship {
  final String name;
  final String org;
  final String amount;
  final int match;
  final String deadline;
  final Color color;
  final String type;

  const V4Scholarship({
    required this.name,
    required this.org,
    required this.amount,
    required this.match,
    required this.deadline,
    required this.color,
    required this.type,
  });
}

class V4ScholarshipsState {
  final String filter;
  final List<V4Scholarship> scholarships;

  const V4ScholarshipsState({
    this.filter = 'All',
    this.scholarships = const [],
  });

  V4ScholarshipsState copyWith({String? filter, List<V4Scholarship>? scholarships}) {
    return V4ScholarshipsState(
      filter: filter ?? this.filter,
      scholarships: scholarships ?? this.scholarships,
    );
  }
}

class V4ScholarshipsNotifier extends StateNotifier<V4ScholarshipsState> {
  V4ScholarshipsNotifier() : super(const V4ScholarshipsState(
    scholarships: [
      V4Scholarship(name: 'STEM Innovators Grant', org: 'Govt of India', amount: '₹2L', match: 94, deadline: 'Jul 29', color: NeoColors.green, type: 'Government'),
      V4Scholarship(name: 'Merit Excellence Fund', org: 'BITS Foundation', amount: '₹1.5L', match: 87, deadline: 'Aug 10', color: NeoColors.purple, type: 'Private'),
      V4Scholarship(name: 'National Science Talent', org: 'DST India', amount: '₹50K', match: 79, deadline: 'Aug 20', color: NeoColors.blue, type: 'Government'),
      V4Scholarship(name: 'Women in Tech Award', org: 'Google India', amount: '₹3L', match: 72, deadline: 'Sep 1', color: Color(0xFFFF3B7A), type: 'Corporate'),
      V4Scholarship(name: 'Sports Excellence Grant', org: 'SAI', amount: '₹75K', match: 65, deadline: 'Sep 15', color: Color(0xFFFF6B35), type: 'Government'),
    ],
  ));

  void setFilter(String filter) {
    state = state.copyWith(filter: filter);
  }
}

final v4ScholarshipsProvider = StateNotifierProvider<V4ScholarshipsNotifier, V4ScholarshipsState>((ref) {
  return V4ScholarshipsNotifier();
});

final v4FilteredScholarshipsProvider = Provider<List<V4Scholarship>>((ref) {
  final state = ref.watch(v4ScholarshipsProvider);
  if (state.filter == 'All') return state.scholarships;
  return state.scholarships.where((s) => s.type == state.filter).toList();
});
