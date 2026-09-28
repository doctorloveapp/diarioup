import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/app_flow_controller.dart';
import '../design_system/diarioup_tokens.dart';
import '../l10n/app_copy.dart';
import '../widgets/brand_mark.dart';
import '../widgets/info_row.dart';
import '../widgets/responsive_content.dart';

final class OnboardingPage extends ConsumerWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ResponsiveContent(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Align(alignment: Alignment.centerLeft, child: BrandMark()),
            const SizedBox(height: DiarioUpSpacing.lg),
            Text(
              AppCopy.onboardingEyebrow,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: DiarioUpColors.indaco,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: DiarioUpSpacing.sm),
            Text(
              AppCopy.onboardingTitle,
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: DiarioUpSpacing.md),
            Text(
              AppCopy.onboardingBody,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).brightness == Brightness.light
                    ? DiarioUpColors.testoSecondario
                    : Theme.of(context).colorScheme.onSurface,
                height: 1.5,
              ),
            ),
            const SizedBox(height: DiarioUpSpacing.xl),
            const InfoRow(
              icon: Icons.lock_outline_rounded,
              text: AppCopy.onboardingPrivacy,
            ),
            const SizedBox(height: DiarioUpSpacing.md),
            const InfoRow(
              icon: Icons.offline_bolt_outlined,
              text: AppCopy.onboardingOffline,
            ),
            const SizedBox(height: DiarioUpSpacing.xl),
            FilledButton(
              onPressed: () {
                ref.read(appFlowProvider.notifier).completeOnboarding();
              },
              child: const Text(AppCopy.start),
            ),
            const SizedBox(height: DiarioUpSpacing.md),
            Text(
              AppCopy.independentService,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        ),
      ),
    );
  }
}
