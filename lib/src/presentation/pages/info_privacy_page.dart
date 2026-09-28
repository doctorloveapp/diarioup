import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/diagnostics/diagnostic_event.dart';
import '../../domain/sharing/homework_file_sharer.dart';
import '../controllers/app_flow_controller.dart';
import '../design_system/diarioup_tokens.dart';
import '../l10n/app_copy.dart';
import '../providers/app_providers.dart';
import '../routing/app_router.dart';

final class InfoPrivacyPage extends ConsumerStatefulWidget {
  const InfoPrivacyPage({required this.profileId, super.key});

  final String profileId;

  @override
  ConsumerState<InfoPrivacyPage> createState() => _InfoPrivacyPageState();
}

final class _InfoPrivacyPageState extends ConsumerState<InfoPrivacyPage> {
  var _isExporting = false;
  var _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    final version = ref.watch(appVersionProvider);
    final diagnostics = ref.watch(recentDiagnosticsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text(AppCopy.infoPrivacy)),
      body: ListView(
        padding: const EdgeInsets.all(DiarioUpSpacing.lg),
        children: <Widget>[
          Card(
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.info_outline_rounded),
                  title: const Text(AppCopy.appVersion),
                  trailing: Text(version.value ?? '...'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: const Text(AppCopy.privacyNotice),
                  subtitle: const Text(AppCopy.privacyNoticeBody),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => context.pushNamed(AppRoutes.privacyName),
                ),
              ],
            ),
          ),
          const SizedBox(height: DiarioUpSpacing.md),
          Card(
            child: Column(
              children: <Widget>[
                Builder(
                  builder: (buttonContext) => ListTile(
                    enabled: !_isExporting && !_isDeleting,
                    leading: _isExporting
                        ? const SizedBox.square(
                            dimension: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.file_download_outlined),
                    title: const Text(AppCopy.exportData),
                    subtitle: const Text(AppCopy.exportDataBody),
                    onTap: () => _exportData(buttonContext),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  enabled: !_isExporting && !_isDeleting,
                  textColor: Theme.of(context).colorScheme.error,
                  iconColor: Theme.of(context).colorScheme.error,
                  leading: _isDeleting
                      ? const SizedBox.square(
                          dimension: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.delete_forever_outlined),
                  title: const Text(AppCopy.deleteAllData),
                  subtitle: const Text(AppCopy.deleteAllDataBody),
                  onTap: _confirmDeleteAll,
                ),
              ],
            ),
          ),
          const SizedBox(height: DiarioUpSpacing.lg),
          Text(
            AppCopy.diagnostics,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: DiarioUpSpacing.xxs),
          Text(
            AppCopy.diagnosticsBody,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: DiarioUpSpacing.sm),
          diagnostics.when(
            loading: () => const Card(
              child: Padding(
                padding: EdgeInsets.all(DiarioUpSpacing.lg),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
            error: (_, _) => const Card(
              child: Padding(
                padding: EdgeInsets.all(DiarioUpSpacing.md),
                child: Text(AppCopy.diagnosticsLoadError),
              ),
            ),
            data: (events) => _DiagnosticEventsCard(events: events),
          ),
        ],
      ),
    );
  }

  Future<void> _exportData(BuildContext buttonContext) async {
    final renderBox = buttonContext.findRenderObject() as RenderBox?;
    final offset = renderBox?.localToGlobal(Offset.zero);
    final origin = renderBox == null || offset == null
        ? null
        : ShareSheetOrigin(
            left: offset.dx,
            top: offset.dy,
            width: renderBox.size.width,
            height: renderBox.size.height,
          );
    setState(() => _isExporting = true);
    try {
      final exporter = await ref.read(userDataExporterProvider.future);
      await exporter.exportJson(profileId: widget.profileId, origin: origin);
      if (mounted) _showMessage(AppCopy.exportDataDone);
    } on Object {
      ref.read(diagnosticRecorderProvider)(
        DiagnosticArea.portability,
        DiagnosticCode.exportFailed,
      );
      if (mounted) _showMessage(AppCopy.exportDataError);
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  Future<void> _confirmDeleteAll() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppCopy.deleteAllDataTitle),
        content: const Text(AppCopy.deleteAllDataWarning),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(AppCopy.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(AppCopy.deleteAllDataConfirm),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => _isDeleting = true);
    var failed = false;
    try {
      final eraser = await ref.read(appDataEraserProvider.future);
      await eraser.eraseAll();
    } on Object {
      failed = true;
    }
    ref.read(appFlowProvider.notifier).signOut();
    ref.invalidate(appDataEraserProvider);
    ref.invalidate(userDataExporterProvider);
    ref.invalidate(didupRepositoryProvider);
    ref.invalidate(diagnosticLogProvider);
    ref.invalidate(recentDiagnosticsProvider);
    ref.invalidate(appDatabaseProvider);
    if (failed && mounted) _showMessage(AppCopy.deleteAllDataError);
  }

  void _showMessage(String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }
}

final class _DiagnosticEventsCard extends StatelessWidget {
  const _DiagnosticEventsCard({required this.events});

  final List<DiagnosticEvent> events;

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(DiarioUpSpacing.md),
          child: Text(AppCopy.diagnosticsEmpty),
        ),
      );
    }
    return Card(
      child: Column(
        children: <Widget>[
          for (final (index, event) in events.indexed) ...<Widget>[
            ListTile(
              dense: true,
              leading: const Icon(Icons.warning_amber_rounded),
              title: Text(_codeLabel(event.code)),
              subtitle: Text(
                '${_areaLabel(event.area)} - ${_formatDate(context, event.occurredAt)}',
              ),
            ),
            if (index != events.length - 1) const Divider(height: 1),
          ],
        ],
      ),
    );
  }

  static String _formatDate(BuildContext context, DateTime value) {
    final local = value.toLocal();
    final localization = MaterialLocalizations.of(context);
    return '${localization.formatShortDate(local)} '
        '${localization.formatTimeOfDay(TimeOfDay.fromDateTime(local))}';
  }

  static String _areaLabel(DiagnosticArea area) => switch (area) {
    DiagnosticArea.authentication => 'Accesso',
    DiagnosticArea.synchronization => 'Sincronizzazione',
    DiagnosticArea.homework => 'Compiti',
    DiagnosticArea.personalization => 'Personalizzazione',
    DiagnosticArea.reminders => 'Promemoria',
    DiagnosticArea.sharing => 'Condivisione',
    DiagnosticArea.portability => 'Esportazione',
    DiagnosticArea.storage => 'Archivio locale',
  };

  static String _codeLabel(DiagnosticCode code) => switch (code) {
    DiagnosticCode.authenticationFailed => 'Accesso non riuscito',
    DiagnosticCode.synchronizationFailed => 'Aggiornamento non riuscito',
    DiagnosticCode.completionUpdateFailed => 'Checklist non aggiornata',
    DiagnosticCode.manualEntryFailed => 'Salvataggio manuale non riuscito',
    DiagnosticCode.noteUpdateFailed => 'Nota non aggiornata',
    DiagnosticCode.personalizationFailed => 'Immagine non aggiornata',
    DiagnosticCode.reminderUpdateFailed => 'Promemoria non aggiornato',
    DiagnosticCode.shareFailed => 'Condivisione non riuscita',
    DiagnosticCode.exportFailed => 'Esportazione non riuscita',
    DiagnosticCode.deletionFailed => 'Cancellazione non completata',
  };
}
