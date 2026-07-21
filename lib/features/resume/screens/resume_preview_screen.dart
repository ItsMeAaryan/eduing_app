import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors/app_colors.dart';
import '../../../core/theme/typography/app_typography.dart';

class ResumePreviewScreen extends StatelessWidget {
  const ResumePreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_2, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Live Preview', style: AppTypography.title.copyWith(fontSize: 16)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Iconsax.magic_star, color: AppColors.primary),
            onPressed: () => context.push('/resume/review'),
          ),
          IconButton(
            icon: const Icon(Iconsax.export_1, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildTemplateSelector(),
            _buildA4Preview(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/resume/review'),
        backgroundColor: AppColors.primary,
        icon: const Icon(Iconsax.scan, color: Colors.white),
        label: Text('AI Review', style: AppTypography.button.copyWith(color: Colors.white)),
      ),
    );
  }

  Widget _buildTemplateSelector() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: SizedBox(
        height: 100,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          scrollDirection: Axis.horizontal,
          children: [
            _buildTemplateThumb('Modern', true),
            _buildTemplateThumb('Harvard', false),
            _buildTemplateThumb('Creative', false),
            _buildTemplateThumb('Minimal', false),
          ],
        ),
      ),
    ).animate().fade().slideY(begin: -0.1);
  }

  Widget _buildTemplateThumb(String name, bool isSelected) {
    return Container(
      width: 70,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
                border: isSelected ? Border.all(color: AppColors.primary, width: 2) : null,
              ),
              child: const Icon(Iconsax.document, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 8),
          Text(name, style: AppTypography.caption.copyWith(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? AppColors.primary : AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildA4Preview() {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 600),
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 30, offset: const Offset(0, 15)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                Text('JOHN DOE', style: AppTypography.headline.copyWith(fontSize: 28, letterSpacing: 2)),
                const SizedBox(height: 8),
                Text('Software Engineer | B.Tech Computer Science', style: AppTypography.label.copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: 4),
                Text('john.doe@email.com • +1 234 567 8900 • linkedin.com/in/johndoe', style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _buildPreviewSection('EDUCATION', [
            _buildPreviewItem('B.Tech Computer Science', 'BITS Pilani', 'Aug 2021 - May 2025', 'CGPA: 8.5/10'),
          ]),
          const SizedBox(height: 24),
          _buildPreviewSection('EXPERIENCE', [
            _buildPreviewItem('Software Engineering Intern', 'Google', 'May 2024 - Aug 2024', '• Developed microservices using Go.\n• Improved API response time by 20%.'),
          ]),
          const SizedBox(height: 24),
          _buildPreviewSection('PROJECTS', [
            _buildPreviewItem('AI Chatbot', 'Personal', 'Jan 2024 - Mar 2024', '• Built an AI chatbot using Flutter and OpenAI API.\n• Deployed on AWS with 1000+ active users.'),
          ]),
          const SizedBox(height: 24),
          _buildPreviewSection('SKILLS', [
            Text('Languages: Dart, Java, Python, C++', style: AppTypography.caption),
            const SizedBox(height: 4),
            Text('Frameworks: Flutter, React, Spring Boot', style: AppTypography.caption),
            const SizedBox(height: 4),
            Text('Tools: Git, Docker, AWS, Firebase', style: AppTypography.caption),
          ]),
        ],
      ),
    ).animate().fade(delay: 200.ms).scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildPreviewSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTypography.label.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1)),
        const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Divider(height: 1, color: Colors.black)),
        ...children,
      ],
    );
  }

  Widget _buildPreviewItem(String title, String subtitle, String date, String details) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold)),
              Text(date, style: AppTypography.caption),
            ],
          ),
          const SizedBox(height: 2),
          Text(subtitle, style: AppTypography.caption.copyWith(fontStyle: FontStyle.italic)),
          const SizedBox(height: 4),
          Text(details, style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
