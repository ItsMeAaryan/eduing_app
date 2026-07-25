import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/neo_design_system.dart';

class UniversityModel {
  final String id;
  final String name;
  final String loc;
  final String rank;
  final int match;
  final Color color;
  final String fees;
  final int seats;

  const UniversityModel({
    required this.id,
    required this.name,
    required this.loc,
    required this.rank,
    required this.match,
    required this.color,
    required this.fees,
    required this.seats,
  });
}

class DiscoverState {
  final String query;
  final String filter;
  final List<String> savedIds;
  final List<UniversityModel> unis;

  const DiscoverState({
    this.query = '',
    this.filter = 'All',
    this.savedIds = const [],
    this.unis = const [],
  });

  DiscoverState copyWith({
    String? query,
    String? filter,
    List<String>? savedIds,
    List<UniversityModel>? unis,
  }) {
    return DiscoverState(
      query: query ?? this.query,
      filter: filter ?? this.filter,
      savedIds: savedIds ?? this.savedIds,
      unis: unis ?? this.unis,
    );
  }
}

class DiscoverNotifier extends StateNotifier<DiscoverState> {
  DiscoverNotifier()
      : super(const DiscoverState(
          unis: [
            UniversityModel(id: '1', name: 'BITS Pilani', loc: 'Pilani, Rajasthan', rank: 'NIRF #1', match: 96, color: NeoColors.green, fees: '₹18L/yr', seats: 120),
            UniversityModel(id: '2', name: 'IIT Bombay', loc: 'Mumbai, Maharashtra', rank: 'NIRF #2', match: 88, color: NeoColors.blue, fees: '₹2.2L/yr', seats: 80),
            UniversityModel(id: '3', name: 'Delhi University', loc: 'New Delhi, Delhi', rank: 'NIRF #3', match: 81, color: NeoColors.purple, fees: '₹15K/yr', seats: 200),
            UniversityModel(id: '4', name: 'VIT Vellore', loc: 'Vellore, Tamil Nadu', rank: 'NIRF #11', match: 74, color: NeoColors.yellow, fees: '₹3.5L/yr', seats: 300),
          ],
        ));

  void setQuery(String q) => state = state.copyWith(query: q);
  
  void setFilter(String f) => state = state.copyWith(filter: f);
  
  void toggleSaved(String id) {
    if (state.savedIds.contains(id)) {
      state = state.copyWith(savedIds: state.savedIds.where((i) => i != id).toList());
    } else {
      state = state.copyWith(savedIds: [...state.savedIds, id]);
    }
  }
}

final discoverProvider = StateNotifierProvider<DiscoverNotifier, DiscoverState>((ref) {
  return DiscoverNotifier();
});

final filteredUnisProvider = Provider<List<UniversityModel>>((ref) {
  final state = ref.watch(discoverProvider);
  return state.unis.where((u) {
    // Implement filter logic
    if (state.filter != 'All') {
      // Very basic mock filter simulation
      if (state.filter == 'Engineering' && !u.name.contains('IIT') && !u.name.contains('BITS') && !u.name.contains('VIT')) return false;
      if (state.filter == 'Arts' && !u.name.contains('Delhi')) return false;
    }
    if (state.query.isNotEmpty && !u.name.toLowerCase().contains(state.query.toLowerCase())) return false;
    return true;
  }).toList();
});
