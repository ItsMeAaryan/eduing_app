import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/neo_design_system.dart';

class DocumentModel {
  final String id;
  final String name;
  final String cat;
  final String status;
  final String icon;
  final Color color;

  const DocumentModel({
    required this.id,
    required this.name,
    required this.cat,
    required this.status,
    required this.icon,
    required this.color,
  });
}

class VaultState {
  final String currentTab;
  final String query;
  final List<DocumentModel> docs;

  const VaultState({
    this.currentTab = 'All',
    this.query = '',
    this.docs = const [],
  });

  VaultState copyWith({
    String? currentTab,
    String? query,
    List<DocumentModel>? docs,
  }) {
    return VaultState(
      currentTab: currentTab ?? this.currentTab,
      query: query ?? this.query,
      docs: docs ?? this.docs,
    );
  }
}

class VaultNotifier extends Notifier<VaultState> {
  @override
  VaultState build() {
    return const VaultState(
      docs: [
        DocumentModel(id: '1', name: '10th Marksheet', cat: 'Academic', status: 'VERIFIED', icon: '📄', color: NeoColors.green),
        DocumentModel(id: '2', name: '12th Marksheet', cat: 'Academic', status: 'VERIFIED', icon: '📄', color: NeoColors.green),
        DocumentModel(id: '3', name: 'Aadhaar Card', cat: 'Identity', status: 'PENDING', icon: '🪪', color: NeoColors.yellow),
        DocumentModel(id: '4', name: 'Passport', cat: 'Identity', status: 'MISSING', icon: '📘', color: NeoColors.red),
        DocumentModel(id: '5', name: 'JEE Scorecard', cat: 'Academic', status: 'VERIFIED', icon: '📊', color: NeoColors.green),
        DocumentModel(id: '6', name: 'Income Certificate', cat: 'Financial', status: 'PENDING', icon: '💰', color: NeoColors.yellow),
      ],
    );
  }

  void setTab(String tab) => state = state.copyWith(currentTab: tab);
  
  void setQuery(String q) => state = state.copyWith(query: q);
}

final vaultProvider = NotifierProvider<VaultNotifier, VaultState>(() {
  return VaultNotifier();
});

final filteredDocsProvider = Provider<List<DocumentModel>>((ref) {
  final state = ref.watch(vaultProvider);
  return state.docs.where((d) {
    if (state.currentTab != 'All' && d.cat != state.currentTab) return false;
    if (state.query.isNotEmpty && !d.name.toLowerCase().contains(state.query.toLowerCase())) return false;
    return true;
  }).toList();
});
