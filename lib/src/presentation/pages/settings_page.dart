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
    required this.onCreateHomework,
    required this.onCreateSubject,
    this.profilePhotoKey,
    super.key,
  });

  final String? profileId;
  final Future<void> Function() onSignOut;
  final Future<void> Function() onCreateHomework;
  final Future<void> Function() onCreateSubject;
  final Key? profilePhotoKey;

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
                data: (value) => Column(
                  children: <Widget>[
                    _AppearanceSettingsCard(
                      profileId: currentProfileId,
                      customization: value,
                      profilePhotoKey: profilePhotoKey,
                    ),
                    const SizedBox(height: DiarioUpSpacing.md),
                    _UpdateSettingsCard(
                      profileId: currentProfileId,
                      enabled: value.checkUpdates,
                    ),
                  ],
                ),
              ),
          const SizedBox(height: DiarioUpSpacing.md),
          _ManualEntryCard(
            onCreateHomework: onCreateHomework,
            onCreateSubject: onCreateSubject,
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
                  permission: permission,
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
            subtitle: const Text(AppCopy.signOutBody),
            onTap: () => _confirmSignOut(context),
          ),
        ),
        const SizedBox(height: DiarioUpSpacing.xl),
      ],
    );
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppCopy.signOutTitle),
        content: const Text(AppCopy.signOutConfirmation),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(AppCopy.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(AppCopy.signOut),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) await onSignOut();
  }
}

final class _UpdateSettingsCard extends ConsumerStatefulWidget {
  const _UpdateSettingsCard({required this.profileId, required this.enabled});

  final String profileId;
  final bool enabled;

  @override
  ConsumerState<_UpdateSettingsCard> createState() =>
      _UpdateSettingsCardState();
}

final class _UpdateSettingsCardState
    extends ConsumerState<_UpdateSettingsCard> {
  var _saving = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SwitchListTile(
        secondary: const Icon(Icons.system_update_alt_rounded),
        title: const Text(AppCopy.checkUpdates),
        subtitle: const Text(AppCopy.checkUpdatesBody),
        value: widget.enabled,
        onChanged: _saving ? null : _save,
      ),
    );
  }

  Future<void> _save(bool enabled) async {
    setState(() => _saving = true);
    try {
      final repository = await ref.read(
        profileCustomizationRepositoryProvider.future,
      );
      await repository.saveCheckUpdates(
        profileId: widget.profileId,
        enabled: enabled,
      );
    } on Object {
      ref.read(diagnosticRecorderProvider)(
        DiagnosticArea.personalization,
        DiagnosticCode.personalizationFailed,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppCopy.appearanceSaveError)),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}

final class _ManualEntryCard extends StatelessWidget {
  const _ManualEntryCard({
    required this.onCreateHomework,
    required this.onCreateSubject,
  });

  final Future<void> Function() onCreateHomework;
  final Future<void> Function() onCreateSubject;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.add_task_rounded),
            title: const Text(AppCopy.newHomework),
            subtitle: const Text(AppCopy.newHomeworkSettingsBody),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: onCreateHomework,
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.library_add_outlined),
            title: const Text(AppCopy.newSubject),
            subtitle: const Text(AppCopy.newSubjectSettingsBody),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: onCreateSubject,
          ),
        ],
      ),
    );
  }
}

final class _AppearanceSettingsCard extends ConsumerStatefulWidget {
  const _AppearanceSettingsCard({
    required this.profileId,
    required this.customization,
    required this.profilePhotoKey,
  });

  final String profileId;
  final ProfileCustomization customization;
  final Key? profilePhotoKey;

  @override
  ConsumerState<_AppearanceSettingsCard> createState() =>
      _AppearanceSettingsCardState();
}

final class _AppearanceSettingsCardState
    extends ConsumerState<_AppearanceSettingsCard> {
  ProfileImageKind? _savingKind;
  var _savingAppearance = false;

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
            DropdownButtonFormField<DiaryThemeMode>(
              initialValue: widget.customization.themeMode,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: AppCopy.themeMode,
                prefixIcon: Icon(Icons.brightness_6_outlined),
              ),
              items: const <DropdownMenuItem<DiaryThemeMode>>[
                DropdownMenuItem(
                  value: DiaryThemeMode.system,
                  child: Text(AppCopy.themeSystem),
                ),
                DropdownMenuItem(
                  value: DiaryThemeMode.light,
                  child: Text(AppCopy.themeLight),
                ),
                DropdownMenuItem(
                  value: DiaryThemeMode.dark,
                  child: Text(AppCopy.themeDark),
                ),
              ],
              onChanged: _savingAppearance
                  ? null
                  : (value) async {
                      if (value != null) {
                        await _saveAppearance(themeMode: value);
                      }
                    },
            ),
            const SizedBox(height: DiarioUpSpacing.md),
            _ColorPreference(
              label: AppCopy.primaryColor,
              colors: DiarioUpThemeChoices.primary,
              selectedValue:
                  widget.customization.primaryColorValue ??
                  DiarioUpColors.indaco.toARGB32(),
              enabled: !_savingAppearance,
              onSelected: (value) async {
                await _saveAppearance(primaryColor: value);
              },
            ),
            const SizedBox(height: DiarioUpSpacing.md),
            _ColorPreference(
              label: AppCopy.backgroundColor,
              colors: DiarioUpThemeChoices.background,
              selectedValue:
                  widget.customization.backgroundColorValue ??
                  DiarioUpColors.sfondo.toARGB32(),
              enabled: !_savingAppearance,
              onSelected: (value) async {
                await _saveAppearance(backgroundColor: value);
              },
            ),
            if (_savingAppearance) ...<Widget>[
              const SizedBox(height: DiarioUpSpacing.sm),
              const LinearProgressIndicator(),
            ],
            const Divider(height: DiarioUpSpacing.xl),
            KeyedSubtree(
              key: widget.profilePhotoKey,
              child: _ImagePreferenceTile(
                kind: ProfileImageKind.profile,
                title: AppCopy.profilePhoto,
                relativePath: widget.customization.profileImagePath,
                isSaving: _savingKind == ProfileImageKind.profile,
                onSelect: () => _select(ProfileImageKind.profile),
                onRemove: () => _remove(ProfileImageKind.profile),
              ),
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

  Future<void> _saveAppearance({
    DiaryThemeMode? themeMode,
    int? primaryColor,
    int? backgroundColor,
  }) async {
    setState(() => _savingAppearance = true);
    try {
      final repository = await ref.read(
        profileCustomizationRepositoryProvider.future,
      );
      await repository.saveAppearance(
        profileId: widget.profileId,
        themeMode: themeMode ?? widget.customization.themeMode,
        primaryColorValue:
            primaryColor ??
            widget.customization.primaryColorValue ??
            DiarioUpColors.indaco.toARGB32(),
        backgroundColorValue:
            backgroundColor ??
            widget.customization.backgroundColorValue ??
            DiarioUpColors.sfondo.toARGB32(),
      );
      if (mounted) _showMessage(AppCopy.appearanceSaved);
    } on Object {
      ref.read(diagnosticRecorderProvider)(
        DiagnosticArea.personalization,
        DiagnosticCode.personalizationFailed,
      );
      if (mounted) _showMessage(AppCopy.appearanceSaveError);
    } finally {
      if (mounted) setState(() => _savingAppearance = false);
    }
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

final class _ColorPreference extends StatelessWidget {
  const _ColorPreference({
    required this.label,
    required this.colors,
    required this.selectedValue,
    required this.enabled,
    required this.onSelected,
  });

  final String label;
  final List<Color> colors;
  final int selectedValue;
  final bool enabled;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: DiarioUpSpacing.xs),
        Wrap(
          spacing: DiarioUpSpacing.sm,
          runSpacing: DiarioUpSpacing.sm,
          children: colors
              .map((color) {
                final value = color.toARGB32();
                final selected = value == selectedValue;
                return Semantics(
                  button: true,
                  selected: selected,
                  label: label,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(DiarioUpSpacing.xl),
                    onTap: enabled ? () => onSelected(value) : null,
                    child: AnimatedContainer(
                      duration: DiarioUpMotion.micro,
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selected
                              ? Theme.of(context).colorScheme.onSurface
                              : Theme.of(context).colorScheme.outline,
                          width: selected ? 3 : 1,
                        ),
                      ),
                      child: selected
                          ? Icon(
                              Icons.check_rounded,
                              color: color.computeLuminance() > 0.5
                                  ? DiarioUpColors.inchiostro
                                  : DiarioUpColors.superficie,
                            )
                          : null,
                    ),
                  ),
                );
              })
              .toList(growable: false),
        ),
      ],
    );
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
    final selectedBytes = bytes.asData?.value;
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
  final AsyncValue<ReminderPermissionStatus> permission;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final time = TimeOfDay(hour: preferences.hour, minute: preferences.minute);
    final permissionStatus = permission.asData?.value;
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
                permissionStatus == ReminderPermissionStatus.granted
                    ? Icons.verified_outlined
                    : Icons.info_outline_rounded,
              ),
              title: Text(_permissionLabel(permission)),
              trailing: _permissionAction(ref, permissionStatus),
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

  Widget? _permissionAction(WidgetRef ref, ReminderPermissionStatus? status) {
    if (permission.isLoading) {
      return const SizedBox.square(
        dimension: DiarioUpSpacing.lg,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }
    if (permission.hasError) {
      return IconButton(
        tooltip: AppCopy.retry,
        onPressed: () => ref.invalidate(reminderPermissionProvider),
        icon: const Icon(Icons.refresh_rounded),
      );
    }
    if (status == ReminderPermissionStatus.denied) {
      return TextButton(
        onPressed: () => _openSettings(ref),
        child: const Text(AppCopy.openNotificationSettings),
      );
    }
    return null;
  }

  String _permissionLabel(AsyncValue<ReminderPermissionStatus> value) {
    if (value.isLoading) return AppCopy.reminderPermissionChecking;
    if (value.hasError) return AppCopy.reminderPermissionCheckFailed;
    return switch (value.value) {
      ReminderPermissionStatus.granted => AppCopy.reminderPermissionGranted,
      ReminderPermissionStatus.denied => AppCopy.reminderPermissionDenied,
      ReminderPermissionStatus.unavailable =>
        AppCopy.reminderPermissionUnavailable,
      null => AppCopy.reminderPermissionUnavailable,
    };
  }
}
