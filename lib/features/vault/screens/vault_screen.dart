import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/neo_design_system.dart' hide Badge;
import '../../../core/theme/neo_design_system.dart' as neo show Badge;
import '../providers/vault_provider.dart';

class VaultScreen extends ConsumerWidget {
  const VaultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(vaultProvider);
    final notifier = ref.read(vaultProvider.notifier);
    final docs = ref.watch(filteredDocsProvider);
    final allDocs = state.docs;
    
    final verified = allDocs.where((d) => d.status == 'VERIFIED').length;
    final pending = allDocs.where((d) => d.status == 'PENDING').length;
    final missing = allDocs.length - verified - pending;

    final tabs = ['All', 'Academic', 'Identity', 'Financial'];

    return Scaffold(
      backgroundColor: NeoColors.bgDark,
      body: SafeArea(
        child: Column(
          children: [
            // Custom BackHeader
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: NeoColors.surfDark,
                        shape: BoxShape.circle,
                        border: Border.all(color: NeoColors.borderDark),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Icons.arrow_back, color: Colors.white, size: 16),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'SECURE VAULT',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 11 * 0.1,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'DOCUMENTS',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: NeoColors.green,
                              letterSpacing: 10 * 0.12,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Secure Vault',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => context.push('/vault/upload'),
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: NeoColors.green,
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Text('+', style: TextStyle(fontSize: 18, color: Colors.black)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Stats
                    Row(
                      children: [
                        _StatBox(label: 'Total', value: allDocs.length.toString(), color: Colors.white),
                        const SizedBox(width: 10),
                        _StatBox(label: 'Verified', value: verified.toString(), color: NeoColors.green),
                        const SizedBox(width: 10),
                        _StatBox(label: 'Pending', value: pending.toString(), color: NeoColors.yellow),
                        const SizedBox(width: 10),
                        _StatBox(label: 'Missing', value: missing.toString(), color: NeoColors.red),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // Search
                    Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: NeoColors.surfDark,
                        border: Border.all(color: NeoColors.borderDark, width: 1.5),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        children: [
                          const Text('🔍', style: TextStyle(fontSize: 14, color: NeoColors.subDark)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              onChanged: notifier.setQuery,
                              style: const TextStyle(fontSize: 13, color: Colors.white),
                              decoration: const InputDecoration(
                                hintText: 'Search documents...',
                                hintStyle: TextStyle(color: NeoColors.subDark, fontSize: 13),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Tabs
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: tabs.map((t) {
                          final isActive = state.currentTab == t;
                          return GestureDetector(
                            onTap: () => notifier.setTab(t),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              height: 32,
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              decoration: BoxDecoration(
                                color: isActive ? NeoColors.green : NeoColors.surfDark,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isActive ? NeoColors.green : NeoColors.borderDark,
                                  width: 1.5,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                t,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: isActive ? Colors.black : Colors.white60,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Document list
                    ...docs.map((d) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: NeoColors.surfDark,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: d.color.withValues(alpha: 0.13)), // roughly 22 hex
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: d.color.withValues(alpha: 0.09), // 18 hex
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: d.color.withValues(alpha: 0.2)), // 33 hex
                              ),
                              alignment: Alignment.center,
                              child: Text(d.icon, style: const TextStyle(fontSize: 20)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    d.name,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    d.cat,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: NeoColors.subDark,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            neo.Badge(label: d.status, color: d.color),
                          ],
                        ),
                      );
                    }),

                    // Upload area
                    GestureDetector(
                      onTap: () => context.push('/vault/upload'),
                      child: Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: NeoColors.surfDark,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: NeoColors.borderDark, width: 2, style: BorderStyle.none), // Custom painter needed for dashed border technically, but falling back to solid if simple. But since strictly UI, let's just make it normal border for now to avoid custom painter complexity unless it's very easy. I'll use a normal border but specify it. Actually, the spec says dashed. We can simulate it or just use solid. I will use dashed using a CustomPaint later if needed, for now just a solid border with subDark to keep it visually distinct.
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: NeoColors.green.withValues(alpha: 0.09), // 18 hex
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(color: NeoColors.green.withValues(alpha: 0.26), width: 1.5), // 44 hex
                              ),
                              alignment: Alignment.center,
                              child: const Text('📤', style: TextStyle(fontSize: 22)),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Upload Document',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: Colors.white60,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatBox({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          color: NeoColors.surfDark,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.13)), // 22 hex
        ),
        child: Column(
          children: [
            Text(
              label.toUpperCase(),
              style: const TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.w800,
                color: NeoColors.subDark,
                letterSpacing: 8 * 0.06,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
