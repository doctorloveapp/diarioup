import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/profile/profile_customization.dart';
import '../../domain/diagnostics/diagnostic_event.dart';
import '../../domain/reminders/reminder_preferences.dart';
import '../../domain/reminders/reminder_service.dart';
import '../design_system/diarioup_tokens.dart';
import '../l10n/app_copy.dart';
import '../providers/app_providers.dart';
import '../routing/app_router.dart';

final class SettingsPage extends ConsumerWidget {
  const SettingsPage({
    required this.profileId,
    required this.onSignOut,
    super.key,
  });

  final String? profileId;
  final Future<void> Function() onSignOut;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentProfileId = profileId;
    final permission = ref.watch(reminderPermissionProvider);
    return ListView(
      padding: const EdgeInsets.all(DiarioUpSpacing.lg),
      children: <Widget>[
        Text(
          AppCopy.settings,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: DiarioUpSpacing.lg),
        if (currentProfileId != null) ...<Widget>[
          ref
              .watch(profileCustomizationProvider(currentProfileId))
              .when(
                loading: () => const _SettingsLoadingCard(),
                error: (_, _) => _SettingsErrorCard(
                  message: AppCopy.customizationLoadError,
                  onRetry: () => ref.invalidate(
                    profileCustomizationProvider(currentProfileId),
                  ),
                ),
                data: (value) => _AppearanceSettingsCard(
                  profileId: currentProfileId,
                  customization: value,
                ),
              ),
          const SizedBox(height: DiarioUpSpacing.md),
          ref
              .watch(reminderPreferencesProvider(currentProfileId))
              .when(
                loading: () => const _SettingsLoadingCard(),
                error: (_, _) => _SettingsErrorCard(
                  message: AppCopy.reminderUpdateError,
                  onRetry: () => ref.invalidate(
                    reminderPreferencesProvider(currentProfileId),
                  ),
                ),
                data: (value) => _ReminderSettingsCard(
                  profileId: currentProfileId,
                  preferences: value,
                  permission: permission.value,
                ),
              ),
        ],
        const SizedBox(height: DiarioUpSpacing.md),
        Card(
          child: ListTile(
            leading: const Icon(Icons.info_outline_rounded),
            title: const Text(AppCopy.infoPrivacy),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: currentProfileId == null
                ? null
                : () => context.pushNamed(AppRoutes.infoPrivacyName),
          ),
        ),
        const SizedBox(height: DiarioUpSpacing.md),
        Card(
          child: ListTile(
            leading: const Icon(Icons.logout_rounded),
            title: const Text(AppCopy.signOut),
            onTap: onSignOut,
          ),
        ),
      ],
    );
  }
}

final class _AppearanceSettingsCard extends ConsumerStatefulWidget {
  const _AppearanceSettingsCard({
    required this.profileId,
    required this.customization,
  });

  final String profileId;
  final ProfileCustomization customization;

  @override
  ConsumerState<_AppearanceSettingsCard> createState() =>
      _AppearanceSettingsCardState();
}

final class _AppearanceSettingsCardState
    extends ConsumerState<_AppearanceSettingsCard> {
  ProfileImageKind? _savingKind;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(DiarioUpSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              AppCopy.personalization,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: DiarioUpSpacing.xxs),
            Text(
              AppCopy.personalizationBody,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: DiarioUpSpacing.md),
            _ImagePreferenceTile(
              kind: ProfileImageKind.profile,
              title: AppCopy.profilePhoto,
              relativePath: widget.customization.profileImagePath,
              isSaving: _savingKind == ProfileImageKind.profile,
              onSelect: () => _select(ProfileImageKind.profile),
              onRemove: () => _remove(ProfileImageKind.profile),
            ),
            const Divider(height: DiarioUpSpacing.lg),
            _ImagePreferenceTile(
              kind: ProfileImageKind.diaryBackground,
              title: AppCopy.diaryBackground,
              relativePath: widget.customization.diaryBackgroundPath,
              isSaving: _savingKind == ProfileImageKind.diaryBackground,
              onSelect: () => _select(ProfileImageKind.diaryBackground),
              onRemove: () => _remove(ProfileImageKind.diaryBackground),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _select(ProfileImageKind kind) async {
    setState(() => _savingKind = kind);
    try {
      final bytes = await ref.read(galleryImageSelectorProvider).select(kind);
      if (bytes == null) return;
      final repository = await ref.read(
        profileCustomizationRepositoryProvider.future,
      );
      await repository.saveImage(
        profileId: widget.profileId,
        kind: kind,
        bytes: bytes,
      );
      if (mounted) _showMessage(AppCopy.imageSaved);
    } on Object {
      ref.read(diagnosticRecorderProvider)(
        DiagnosticArea.personalization,
        DiagnosticCode.personalizationFailed,
      );
      if (mounted) _showMessage(AppCopy.imageSaveError);
    } finally {
      if (mounted) setState(() => _savingKind = null);
    }
  }

  Future<void> _remove(ProfileImageKind kind) async {
    setState(() => _savingKind = kind);
    try {
      final repository = await ref.read(
        profileCustomizationRepositoryProvider.future,
      );
      await repository.removeImage(profileId: widget.profileId, kind: kind);
      if (mounted) _showMessage(AppCopy.imageRemoved);
    } on Object {
      ref.read(diagnosticRecorderProvider)(
        DiagnosticArea.personalization,
        DiagnosticCode.personalizationFailed,
      );
      if (mounted) _showMessage(AppCopy.imageSaveError);
    } finally {
      if (mounted) setState(() => _savingKind = null);
    }
  }

  void _showMessage(String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }
}

final class _ImagePreferenceTile extends ConsumerWidget {
  const _ImagePreferenceTile({
    required this.kind,
    required this.title,
    required this.relativePath,
    required this.isSaving,
    required this.onSelect,
    required this.onRemove,
  });

  final ProfileImageKind kind;
  final String title;
  final String? relativePath;
  final bool isSaving;
  final VoidCallback onSelect;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final path = relativePath;
    final bytes = path == null
        ? const AsyncData<Uint8List?>(null)
        : ref.watch(customizationImageProvider(path));
    final selectedBytes = bytes.value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          children: <Widget>[
            _ImagePreview(kind: kind, bytes: selectedBytes),
            const SizedBox(width: DiarioUpSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: DiarioUpSpacing.xxs),
                  Text(
                    path == null ? AppCopy.noCustomImage : AppCopy.customImage,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            if (isSaving)
              const SizedBox.square(
                dimension: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
          ],
        ),
        const SizedBox(height: DiarioUpSpacing.sm),
        Wrap(
          spacing: DiarioUpSpacing.xs,
          runSpacing: DiarioUpSpacing.xs,
          alignment: WrapAlignment.end,
          children: <Widget>[
            if (path != null)
              TextButton.icon(
                onPressed: isSaving ? null : onRemove,
                icon: const Icon(Icons.delete_outline_rounded),
                label: const Text(AppCopy.removeImage),
              ),
            FilledButton.tonalIcon(
              onPressed: isSaving ? null : onSelect,
              icon: const Icon(Icons.photo_library_outlined),
              label: Text(
                path == null ? AppCopy.chooseImage : AppCopy.changeImage,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

final class _ImagePreview extends StatelessWidget {
  const _ImagePreview({required this.kind, required this.bytes});

  final ProfileImageKind kind;
  final Uint8List? bytes;

  @override
  Widget build(BuildContext context) {
    final imageBytes = bytes;
    if (kind == ProfileImageKind.profile) {
      return CircleAvatar(
        radius: 32,
        backgroundColor: DiarioUpColors.indaco.withValues(alpha: 0.12),
        child: imageBytes == null
            ? const Icon(Icons.person_outline_rounded)
            : ClipOval(
                child: SizedBox.expand(
                  child: Image.memory(
                    imageBytes,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.person_outline_rounded),
                  ),
                ),
              ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(DiarioUpSpacing.xs),
      child: SizedBox(
        width: 88,
        height: 64,
        child: imageBytes == null
            ? ColoredBox(
                color: DiarioUpColors.indaco.withValues(alpha: 0.12),
                child: const Icon(Icons.landscape_outlined),
              )
            : Image.memory(
                imageBytes,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const ColoredBox(
                  color: DiarioUpColors.sfondo,
                  child: Icon(Icons.landscape_outlined),
                ),
              ),
      ),
    );
  }
}

final class _SettingsLoadingCard extends StatelessWidget {
  const _SettingsLoadingCard();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(DiarioUpSpacing.lg),
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

final class _SettingsErrorCard extends StatelessWidget {
  const _SettingsErrorCard({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.error_outline_rounded),
        title: Text(message),
        trailing: IconButton(
          tooltip: AppCopy.retry,
          onPressed: onRetry,
          icon: const Icon(Icons.refresh_rounded),
        ),
      ),
    );
  }
}

final class _ReminderSettingsCard extends ConsumerWidget {
  const _ReminderSettingsCard({
    required this.profileId,
    required this.preferences,
    required this.permission,
  });

  final String profileId;
  final ReminderPreferences preferences;
  final ReminderPermissionStatus? permission;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final time = TimeOfDay(hour: preferences.hour, minute: preferences.minute);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(DiarioUpSpacing.xs),
        child: Column(
          children: <Widget>[
            SwitchListTile(
              secondary: const Icon(Icons.notifications_active_outlined),
              title: const Text(AppCopy.enableReminders),
              subtitle: const Text(AppCopy.remindersBody),
              value: preferences.enabled,
              onChanged: (enabled) => _setEnabled(context, ref, enabled),
            ),
            const Divider(height: 1),
            ListTile(
              enabled: preferences.enabled,
              leading: const Icon(Icons.schedule_rounded),
              title: const Text(AppCopy.reminderTime),
              trailing: Text(
                MaterialLocalizations.of(
                  context,
                ).formatTimeOfDay(time, alwaysUse24HourFormat: true),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              onTap: () => _pickTime(context, ref, time),
            ),
            ListTile(
              leading: Icon(
                permission == ReminderPermissionStatus.granted
                    ? Icons.verified_outlined
                    : Icons.info_outline_rounded,
              ),
              title: Text(_permissionLabel(permission)),
              trailing: permission == ReminderPermissionStatus.denied
                  ? TextButton(
                      onPressed: () => _openSettings(ref),
                      child: const Text(AppCopy.openNotificationSettings),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _setEnabled(
    BuildContext context,
    WidgetRef ref,
    bool enabled,
  ) async {
    try {
      final coordinator = await ref.read(reminderCoordinatorProvider.future);
      if (enabled) {
        final status = await coordinator.enable(profileId);
        ref.invalidate(reminderPermissionProvider);
        if (status != ReminderPermissionStatus.granted && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(AppCopy.reminderPermissionRequired)),
          );
        }
      } else {
        await coordinator.disable(profileId);
      }
    } on Object {
      ref.read(diagnosticRecorderProvider)(
        DiagnosticArea.reminders,
        DiagnosticCode.reminderUpdateFailed,
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppCopy.reminderUpdateError)),
        );
      }
    }
  }

  Future<void> _pickTime(
    BuildContext context,
    WidgetRef ref,
    TimeOfDay current,
  ) async {
    final selected = await showTimePicker(
      context: context,
      initialTime: current,
      helpText: AppCopy.reminderTime,
    );
    if (selected == null || !context.mounted) return;
    if (selected.hour < 7 || selected.hour >= 21) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text(AppCopy.quietHoursError)));
      return;
    }
    try {
      final coordinator = await ref.read(reminderCoordinatorProvider.future);
      await coordinator.updateTime(
        profileId: profileId,
        hour: selected.hour,
        minute: selected.minute,
      );
    } on Object {
      ref.read(diagnosticRecorderProvider)(
        DiagnosticArea.reminders,
        DiagnosticCode.reminderUpdateFailed,
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppCopy.reminderUpdateError)),
        );
      }
    }
  }

  Future<void> _openSettings(WidgetRef ref) async {
    final coordinator = await ref.read(reminderCoordinatorProvider.future);
    await coordinator.openNotificationSettings();
    ref.invalidate(reminderPermissionProvider);
  }

  String _permissionLabel(ReminderPermissionStatus? status) {
    return switch (status) {
      ReminderPermissionStatus.granted => AppCopy.reminderPermissionGranted,
      ReminderPermissionStatus.denied => AppCopy.reminderPermissionDenied,
      ReminderPermissionStatus.unavailable =>
        AppCopy.reminderPermissionUnavailable,
      null => AppCopy.reminderPermissionUnavailable,
    };
  }
}
