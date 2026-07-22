import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';
import '../providers/sop_provider.dart';
import '../models/sop_model.dart';

class SopDashboardScreen extends ConsumerStatefulWidget {
  const SopDashboardScreen({super.key});

  @override
  ConsumerState<SopDashboardScreen> createState() => _SopDashboardScreenState();
}

class _SopDashboardScreenState extends ConsumerState<SopDashboardScreen> {
  void _showGenerateDialog() {
    final uniCtrl = TextEditingController(text: 'MIT');
    final progCtrl = TextEditingController(text: 'M.S. in Computer Science');
    final bgCtrl = TextEditingController(text: 'B.S. in Computer Science, 3.9 GPA, ML research assistant');
    final goalsCtrl = TextEditingController(text: 'Lead ethical AI research lab focused on efficient edge computing');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24, right: 24, top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Generate AI Draft Statement of Purpose', style: AppTypography.headline),
                const SizedBox(height: 16),
                TextField(controller: uniCtrl, decoration: const InputDecoration(labelText: 'Target University')),
                const SizedBox(height: 12),
                TextField(controller: progCtrl, decoration: const InputDecoration(labelText: 'Target Program')),
                const SizedBox(height: 12),
                TextField(controller: bgCtrl, maxLines: 2, decoration: const InputDecoration(labelText: 'Academic Background')),
                const SizedBox(height: 12),
                TextField(controller: goalsCtrl, maxLines: 2, decoration: const InputDecoration(labelText: 'Career Goals')),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () async {
                    ctx.pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Generating custom SOP with Gemini AI...')),
                    );
                    await ref.read(sopProvider.notifier).generateSopWithAI(
                          university: uniCtrl.text,
                          program: progCtrl.text,
                          background: bgCtrl.text,
                          careerGoals: goalsCtrl.text,
                        );
                  },
                  icon: const Icon(Iconsax.magic_star),
                  label: const Text('Generate SOP Draft'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEditContentDialog(UserSop sop) {
    final controller = TextEditingController(text: sop.fullContent);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24, right: 24, top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Edit Statement of Purpose', style: AppTypography.headline),
                const SizedBox(height: 16),
                Expanded(
                  child: TextField(
                    controller: controller,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                      hintText: 'Write your SOP content here...',
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ref.read(sopProvider.notifier).updateContent(controller.text);
                    ctx.pop();
                  },
                  child: const Text('Save SOP Content'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final sop = ref.watch(sopProvider);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text('SOP Workspace'),
            Text(sop.universityName, style: AppTypography.caption.copyWith(color: AppColors.textSecondary, fontSize: 10)),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.magic_star, color: AppColors.primary),
            onPressed: _showGenerateDialog,
          ),
          IconButton(
            icon: const Icon(Iconsax.eye, color: AppColors.primary),
            onPressed: () => context.push('/sop/preview'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          children: [
            _buildStatsHeader(sop),
            _buildMetricsBar(sop),
            _buildContentPreviewTile(sop),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsHeader(UserSop sop) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 16, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCircularScore('Word Progress', sop.wordCountProgress, color: AppColors.success),
              _buildCircularScore('AI Score', sop.aiSopScore / 100.0, color: AppColors.primary),
              _buildCircularScore('Grammar', sop.review.grammar / 100.0, color: AppColors.secondary),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Polishing tone & grammar with AI...')),
                    );
                    await ref.read(sopProvider.notifier).improveSopWithAI();
                  },
                  icon: const Icon(Iconsax.edit_2, color: AppColors.primary),
                  label: const Text('Polish with AI'),
                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => context.push('/sop/review'),
                  icon: const Icon(Iconsax.magic_star, color: Colors.white),
                  label: const Text('AI Review'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fade().slideY(begin: 0.05);
  }

  Widget _buildCircularScore(String label, double value, {Color color = AppColors.primary}) {
    return Column(
      children: [
        SizedBox(
          width: 56,
          height: 56,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: value,
                strokeWidth: 6,
                backgroundColor: color.withOpacity(0.15),
                valueColor: AlwaysStoppedAnimation(color),
              ),
              Center(
                child: Text(
                  '${(value * 100).toInt()}%',
                  style: AppTypography.label.copyWith(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: AppTypography.caption),
      ],
    );
  }

  Widget _buildMetricsBar(UserSop sop) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Text('${sop.wordCount}', style: AppTypography.headline.copyWith(color: AppColors.primary)),
                    Text('Words (Target ~500)', style: AppTypography.caption),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Text(sop.targetProgram, style: AppTypography.label.copyWith(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                    Text(sop.universityName, style: AppTypography.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentPreviewTile(UserSop sop) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Statement of Purpose Draft', style: AppTypography.subheading),
              IconButton(
                icon: const Icon(Iconsax.edit, color: AppColors.primary),
                onPressed: () => _showEditContentDialog(sop),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            sop.fullContent.isNotEmpty ? sop.fullContent : 'No content generated yet. Tap AI Generate or Edit to start.',
            style: AppTypography.body.copyWith(height: 1.5),
            maxLines: 12,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
