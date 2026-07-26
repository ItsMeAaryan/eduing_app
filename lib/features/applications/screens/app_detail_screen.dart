import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/neo_design_system.dart' hide Badge;
import '../../../core/theme/neo_design_system.dart' as neo show Badge;

class AppDetailScreen extends StatefulWidget {
  final String id;
  const AppDetailScreen({super.key, required this.id});

  @override
  State<AppDetailScreen> createState() => _AppDetailScreenState();
}

class _AppDetailScreenState extends State<AppDetailScreen> {
  final List<Map<String, dynamic>> _steps = [
    {"title": "Application Submitted", "date": "Jul 15", "status": "done"},
    {"title": "Documents Verified", "date": "Jul 18", "status": "done"},
    {"title": "Application Fee", "date": "Pending", "status": "active"},
    {"title": "Under Review", "date": "", "status": "future"},
    {"title": "Interview (if required)", "date": "", "status": "future"},
    {"title": "Final Decision", "date": "", "status": "future"},
    {"title": "Offer Acceptance", "date": "", "status": "future"},
  ];

  final List<Map<String, dynamic>> _docs = [
    {"name": "Passport", "icon": "🛂", "status": "Verified", "color": NeoColors.green},
    {"name": "Transcripts", "icon": "📄", "status": "Verified", "color": NeoColors.green},
    {"name": "SOP", "icon": "📝", "status": "Pending", "color": NeoColors.yellow},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: Column(
          children: [
            // Header
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
                  const Expanded(
                    child: Text(
                      'APPLICATION DETAILS',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Colors.white30,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // University Header
                    Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: NeoColors.surfDark2,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: NeoColors.borderDark),
                          ),
                          alignment: Alignment.center,
                          child: const Text('🏛', style: TextStyle(fontSize: 28)),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Stanford University', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.5)),
                              SizedBox(height: 2),
                              Text('MS Computer Science', style: TextStyle(fontSize: 13, color: Colors.white60)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Row(
                      children: [
                        neo.Badge(label: 'Deadline: Dec 15', color: NeoColors.yellow),
                        SizedBox(width: 8),
                        neo.Badge(label: 'Fall 2024', color: NeoColors.purple),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Progress Hero NotchedCard
                    NotchedCard(
                      bg: Colors.transparent,
                      padding: EdgeInsets.zero,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [NeoColors.blue, NeoColors.purple],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('OVERALL PROGRESS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white.withValues(alpha: 0.5), letterSpacing: 1.2)),
                                const SizedBox(height: 6),
                                const Text('91%', style: TextStyle(fontSize: 42, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -2, height: 1)),
                                const SizedBox(height: 14),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(2),
                                  child: LinearProgressIndicator(
                                    value: 0.91,
                                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                                    minHeight: 4,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text('Almost there! Complete pending steps.', style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.8))),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: -10,
                            right: -10,
                            child: FloatingActionBtn(
                              icon: '✦',
                              bg: NeoColors.green,
                              color: Colors.black,
                              onClick: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Vertical Step Tracker
                    const Text('TRACKER', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white30, letterSpacing: 1.2)),
                    const SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _steps.length,
                      itemBuilder: (context, index) {
                        final step = _steps[index];
                        final isLast = index == _steps.length - 1;
                        final status = step['status'];

                        return IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      color: status == 'done' ? NeoColors.green : status == 'active' ? NeoColors.purple : NeoColors.surfDark2,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: status == 'active' ? NeoColors.purple : status == 'done' ? Colors.transparent : NeoColors.borderDark,
                                        width: 2,
                                      ),
                                      boxShadow: status == 'active' ? [
                                        BoxShadow(color: NeoColors.purple.withValues(alpha: 0.4), blurRadius: 12, spreadRadius: 2),
                                      ] : [],
                                    ),
                                    alignment: Alignment.center,
                                    child: status == 'done'
                                        ? const Icon(Icons.check, color: Colors.black, size: 16)
                                        : status == 'active'
                                            ? const Icon(Icons.sync, color: Colors.white, size: 16)
                                            : Text('${index + 1}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white30)),
                                  ),
                                  if (!isLast)
                                    Expanded(
                                      child: Container(
                                        width: 2,
                                        color: status == 'done' ? NeoColors.green : NeoColors.borderDark,
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 24),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(step['title'], style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: status == 'future' ? Colors.white30 : Colors.white)),
                                      if (step['date'].isNotEmpty) ...[
                                        const SizedBox(height: 4),
                                        Text(step['date'], style: TextStyle(fontSize: 12, color: status == 'done' ? NeoColors.green : NeoColors.yellow)),
                                      ],
                                      if (status == 'active') ...[
                                        const SizedBox(height: 12),
                                        GreenBtn(
                                          label: 'Pay Now',
                                          small: true,
                                          onClick: () {},
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 8),

                    // Required Documents
                    const Text('REQUIRED DOCUMENTS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white30, letterSpacing: 1.2)),
                    const SizedBox(height: 12),
                    ..._docs.map((doc) => Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: NeoColors.surfDark,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: NeoColors.borderDark),
                      ),
                      child: Row(
                        children: [
                          Text(doc['icon'], style: const TextStyle(fontSize: 20)),
                          const SizedBox(width: 12),
                          Expanded(child: Text(doc['name'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white))),
                          neo.Badge(label: doc['status'], color: doc['color']),
                        ],
                      ),
                    )),
                    const SizedBox(height: 32),

                    // Actions
                    SizedBox(
                      width: double.infinity,
                      child: GreenBtn(label: 'Continue Application', onClick: () {}, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.black)),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: TextButton(
                        onPressed: () {},
                        child: const Text('Withdraw Application', style: TextStyle(color: Colors.white30, fontWeight: FontWeight.w700)),
                      ),
                    ),
                    const SizedBox(height: 40),
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
