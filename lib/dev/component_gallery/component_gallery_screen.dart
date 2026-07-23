import 'package:flutter/material.dart';
import '../../shared/components/atoms/app_button.dart';
import '../../shared/components/atoms/app_icon_button.dart';
import '../../shared/components/atoms/app_text_field.dart';
import '../../shared/components/atoms/progress_bar.dart';
import '../../shared/components/atoms/status_pill.dart';
import '../../shared/components/organisms/admission_progress_card.dart';
import '../../shared/components/organisms/premium_application_card.dart';
import '../../shared/components/organisms/university_card.dart';
import '../../shared/components/organisms/planner_card.dart';
import '../../shared/components/organisms/empty_state.dart';
import '../../core/theme/colors/app_colors.dart';
import '../../core/theme/typography/app_typography.dart';
import '../../core/theme/spacing/app_spacing.dart';

class ComponentGalleryScreen extends StatefulWidget {
  const ComponentGalleryScreen({super.key});

  @override
  State<ComponentGalleryScreen> createState() => _ComponentGalleryScreenState();
}

class _ComponentGalleryScreenState extends State<ComponentGalleryScreen> {
  // We simulate theme toggling locally for this screen if possible,
  // or rely on a wrapper that toggles the app theme.
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Design System Gallery'),
        actions: [
          // Simulated theme switch (needs app-level support to actually work, 
          // but we provide the visual toggle here as requested)
          IconButton(
            icon: Icon(Theme.of(context).brightness == Brightness.dark 
                ? Icons.light_mode 
                : Icons.dark_mode),
            onPressed: () {
              // Toggle logic to be implemented at App level
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.p24),
        children: [
          _buildSectionTitle('Colors'),
          _buildColors(),
          
          _buildSectionTitle('Typography'),
          _buildTypography(),
          
          _buildSectionTitle('Buttons'),
          _buildButtons(),
          
          _buildSectionTitle('Application Cards'),
          _buildApplicationCards(),
          
          _buildSectionTitle('Other Cards'),
          _buildOtherCards(),
          
          _buildSectionTitle('Status Pills'),
          _buildStatusPills(),
          
          _buildSectionTitle('Inputs & Progress'),
          _buildInputsAndProgress(),
          
          _buildSectionTitle('Empty States'),
          _buildEmptyStates(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.p32, bottom: AppSpacing.p16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.titleLarge.copyWith(color: AppColors.primary)),
          const Divider(height: AppSpacing.p16),
        ],
      ),
    );
  }

  Widget _buildColors() {
    return Wrap(
      spacing: AppSpacing.p16,
      runSpacing: AppSpacing.p16,
      children: [
        _buildColorBox('Primary', AppColors.primary),
        _buildColorBox('Success', AppColors.success),
        _buildColorBox('Warning', AppColors.warning),
        _buildColorBox('Error', AppColors.error),
        _buildColorBox('Info', AppColors.info),
      ],
    );
  }

  Widget _buildColorBox(String name, Color color) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
        ),
        const SizedBox(height: AppSpacing.p8),
        Text(name, style: AppTypography.labelMedium),
      ],
    );
  }

  Widget _buildTypography() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Display Large', style: AppTypography.display),
        const SizedBox(height: AppSpacing.p8),
        Text('Headline Large', style: AppTypography.headline),
        const SizedBox(height: AppSpacing.p8),
        Text('Title Large', style: AppTypography.titleLarge),
        const SizedBox(height: AppSpacing.p8),
        Text('Title Medium', style: AppTypography.titleMedium),
        const SizedBox(height: AppSpacing.p8),
        Text('Body Large', style: AppTypography.bodyLarge),
        const SizedBox(height: AppSpacing.p8),
        Text('Body Medium', style: AppTypography.bodyMedium),
        const SizedBox(height: AppSpacing.p8),
        Text('Label Large', style: AppTypography.labelLarge),
      ],
    );
  }

  Widget _buildButtons() {
    return Wrap(
      spacing: AppSpacing.p16,
      runSpacing: AppSpacing.p16,
      children: [
        AppButton(text: 'Primary Button', onPressed: () {}),
        AppButton(text: 'Secondary', variant: AppButtonVariant.secondary, onPressed: () {}),
        AppButton(text: 'Outline', variant: AppButtonVariant.outline, onPressed: () {}),
        AppButton(text: 'Ghost', variant: AppButtonVariant.ghost, onPressed: () {}),
        const AppButton(text: 'Loading', isLoading: true),
        const AppButton(text: 'Disabled', onPressed: null),
        AppIconButton(icon: Icons.favorite, onPressed: () {}),
        AppIconButton(icon: Icons.star, isFilled: true, onPressed: () {}),
      ],
    );
  }

  Widget _buildApplicationCards() {
    return Column(
      children: [
        PremiumApplicationCard(
          logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/4b/Stanford_University_seal_2003.svg/1200px-Stanford_University_seal_2003.svg.png',
          universityName: 'Stanford University',
          course: 'MS in Computer Science',
          status: StatusType.inProgress,
          deadline: 'Jul 26, 2025',
          progress: 0.65,
          onTap: () {},
          onMenuTap: () {},
        ),
        const SizedBox(height: AppSpacing.p16),
        PremiumApplicationCard(
          logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0c/MIT_logo.svg/1200px-MIT_logo.svg.png',
          universityName: 'MIT',
          course: 'MS in Data Science',
          status: StatusType.draft,
          deadline: 'Aug 15, 2025',
          progress: 0.30,
          onTap: () {},
          onMenuTap: () {},
        ),
        const SizedBox(height: AppSpacing.p16),
        PremiumApplicationCard(
          logoUrl: 'https://upload.wikimedia.org/wikipedia/en/thumb/b/bb/Carnegie_Mellon_University_seal.svg/1200px-Carnegie_Mellon_University_seal.svg.png',
          universityName: 'Carnegie Mellon University',
          course: 'MS in Information Systems',
          status: StatusType.notStarted,
          deadline: 'Aug 30, 2025',
          progress: 0.0,
          onTap: () {},
          onMenuTap: () {},
        ),
      ],
    );
  }

  Widget _buildOtherCards() {
    return Column(
      children: [
        AdmissionProgressCard(
          readinessPercentage: 88,
          applicationsCount: 4,
          documentsCount: 12,
          onImproveWithAI: () {},
        ),
        const SizedBox(height: AppSpacing.p16),
        const UniversityCard(
          logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/4b/Stanford_University_seal_2003.svg/1200px-Stanford_University_seal_2003.svg.png',
          name: 'Stanford University',
          location: 'Stanford, California',
          rank: '1',
        ),
        const SizedBox(height: AppSpacing.p16),
        const PlannerCard(
          title: 'SOP Draft Submission',
          date: 'Tomorrow, 10:00 AM',
          type: 'Task',
        ),
      ],
    );
  }

  Widget _buildStatusPills() {
    return Wrap(
      spacing: AppSpacing.p8,
      runSpacing: AppSpacing.p8,
      children: const [
        StatusPill(type: StatusType.notStarted),
        StatusPill(type: StatusType.draft),
        StatusPill(type: StatusType.inProgress),
        StatusPill(type: StatusType.submitted),
        StatusPill(type: StatusType.underReview),
        StatusPill(type: StatusType.accepted),
        StatusPill(type: StatusType.rejected),
        StatusPill(type: StatusType.visa),
        StatusPill(type: StatusType.completed),
      ],
    );
  }

  Widget _buildInputsAndProgress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppTextField(
          labelText: 'Email Address',
          hintText: 'john@example.com',
          prefixIcon: Icons.email_outlined,
        ),
        const SizedBox(height: AppSpacing.p16),
        const AppTextField(
          labelText: 'Password',
          hintText: '••••••••',
          prefixIcon: Icons.lock_outline,
          obscureText: true,
        ),
        const SizedBox(height: AppSpacing.p24),
        const ProgressBar(progress: 0.7),
        const SizedBox(height: AppSpacing.p16),
        const ProgressBar(progress: 0.4, color: AppColors.warning),
      ],
    );
  }

  Widget _buildEmptyStates() {
    return EmptyState(
      title: 'No applications yet',
      message: 'Start your journey by adding your first university application.',
      icon: Icons.folder_open,
      action: const AppButton(
        text: 'Add Application',
        onPressed: null,
      ),
    );
  }
}
