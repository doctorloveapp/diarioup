import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/agenda/homework_agenda_item.dart';
import '../../domain/agenda/manual_homework_input.dart';
import '../../domain/homework/school_date.dart';
import '../../domain/diagnostics/diagnostic_event.dart';
import '../../domain/sharing/homework_file_sharer.dart';
import '../../domain/use_cases/share_homework.dart';
import '../controllers/app_flow_controller.dart';
import '../design_system/diarioup_tokens.dart';
import '../l10n/app_copy.dart';
import '../providers/app_providers.dart';
import '../routing/app_router.dart';
import '../widgets/brand_mark.dart';
import '../widgets/homework_tile.dart';
import '../widgets/homework_share_sheet.dart';
import '../widgets/manual_entry_dialogs.dart';
import '../widgets/subjects_panel.dart';
import 'settings_page.dart';

final class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

final class _DashboardPageState extends ConsumerState<DashboardPage>
    with WidgetsBindingObserver {
  int _selectedIndex = 0;
  var _isSharing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) return;
    ref.invalidate(reminderPermissionProvider);
    final profileId = ref.read(appFlowProvider).activeProfile?.sourceProfileId;
    if (profileId != null) {
      ref.invalidate(reminderBootstrapProvider(profileId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(appFlowProvider).activeProfile;
    final profileId = profile?.sourceProfileId;
    final customization = profileId == null
        ? null
        : ref.watch(profileCustomizationProvider(profileId)).asData?.value;
    final profileImagePath = customization?.profileImagePath;
    final backgroundImagePath = customization?.diaryBackgroundPath;
    final profileImage = profileImagePath == null
        ? null
        : ref.watch(customizationImageProvider(profileImagePath)).asData?.value;
    final backgroundImage = backgroundImagePath == null
        ? null
        : ref
              .watch(customizationImageProvider(backgroundImagePath))
              .asData
              ?.value;
    if (profileId != null) {
      ref.watch(reminderBootstrapProvider(profileId));
    }
    final pages = <Widget>[
      _AgendaPanel(
        profileId: profileId,
        profileLabel: profile?.displayLabel ?? AppCopy.appName,
      ),
      profileId == null
          ? const SizedBox.shrink()
          : SubjectsPanel(profileId: profileId),
      SettingsPage(
        profileId: profileId,
        onSignOut: _signOut,
        onCreateHomework: () async {
          if (profileId != null) await _createHomework(profileId);
        },
        onCreateSubject: () async {
          if (profileId != null) await _createSubject(profileId);
        },
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const BrandMark(compact: true),
        actions: <Widget>[
          if (profileId != null)
            Builder(
              builder: (buttonContext) => IconButton(
                onPressed: _isSharing
                    ? null
                    : () => _shareHomework(buttonContext, profileId),
                tooltip: AppCopy.shareHomework,
                icon: _isSharing
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.ios_share_rounded),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(right: DiarioUpSpacing.md),
            child: CircleAvatar(
              backgroundColor: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.16),
              child: profileImage == null
                  ? Text(
                      _initial(profile?.displayLabel),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  : ClipOval(
                      child: SizedBox.expand(
                        child: Image.memory(
                          profileImage,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Center(
                            child: Text(
                              _initial(profile?.displayLabel),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
      body: _DashboardBackground(
        imageBytes: backgroundImage,
        child: SafeArea(child: pages[_selectedIndex]),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined),
            selectedIcon: Icon(Icons.calendar_today_rounded),
            label: AppCopy.agenda,
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book_rounded),
            label: AppCopy.subjects,
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings_rounded),
            label: AppCopy.settings,
          ),
        ],
      ),
    );
  }

  Future<void> _signOut() async {
    final profileId = ref.read(appFlowProvider).activeProfile?.sourceProfileId;
    if (profileId != null) {
      final coordinator = await ref.read(reminderCoordinatorProvider.future);
      await coordinator.cancelAll(profileId);
    }
    final repository = await ref.read(didupRepositoryProvider.future);
    await repository.logout();
    ref.read(appFlowProvider.notifier).signOut();
  }

  Future<void> _createHomework(String profileId) async {
    try {
      final repository = await ref.read(didupRepositoryProvider.future);
      final subjects = await repository
          .watchSubjects(profileId: profileId)
          .first;
      if (!mounted) return;
      final draft = await showManualHomeworkDialog(context, subjects: subjects);
      if (draft == null) return;
      await repository.createManualHomework(
        ManualHomeworkInput(
          profileId: profileId,
          text: draft.text,
          subjectId: draft.subjectId,
          dueOn: draft.dueOn,
          personalNote: draft.note,
        ),
      );
      if (!mounted) return;
      _showMessage(AppCopy.entrySaved);
    } on Object {
      ref.read(diagnosticRecorderProvider)(
        DiagnosticArea.homework,
        DiagnosticCode.manualEntryFailed,
      );
      if (mounted) _showMessage(AppCopy.entrySaveError);
    }
  }

  Future<void> _createSubject(String profileId) async {
    final draft = await showManualSubjectDialog(context);
    if (draft == null) return;
    try {
      final repository = await ref.read(didupRepositoryProvider.future);
      await repository.createManualSubject(
        profileId: profileId,
        name: draft.name,
        colorValue: draft.colorValue,
      );
      if (!mounted) return;
      _showMessage(AppCopy.entrySaved);
    } on Object {
      ref.read(diagnosticRecorderProvider)(
        DiagnosticArea.homework,
        DiagnosticCode.manualEntryFailed,
      );
      if (mounted) _showMessage(AppCopy.entrySaveError);
    }
  }

  Future<void> _shareHomework(
    BuildContext buttonContext,
    String profileId,
  ) async {
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
    setState(() => _isSharing = true);
    try {
      final subjects = await ref.read(subjectsAgendaProvider(profileId).future);
      if (!mounted) return;
      final selection = await showHomeworkShareSheet(
        context,
        subjects: subjects,
      );
      if (selection == null || !mounted) return;

      _showMessage(
        AppCopy.exportPreparing,
        duration: const Duration(minutes: 1),
      );
      final shareHomework = await ref.read(shareHomeworkProvider.future);
      final result = await shareHomework(
        profileId: profileId,
        selection: selection,
        origin: origin,
      );
      if (!mounted) return;
      _showMessage(
        result.status == HomeworkShareStatus.empty
            ? AppCopy.exportEmpty
            : AppCopy.exportDone,
      );
    } on Object {
      ref.read(diagnosticRecorderProvider)(
        DiagnosticArea.sharing,
        DiagnosticCode.shareFailed,
      );
      if (mounted) _showMessage(AppCopy.exportError);
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }

  void _showMessage(
    String message, {
    Duration duration = const Duration(seconds: 4),
  }) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(content: Text(message), duration: duration),
    );
  }

  String _initial(String? value) {
    final text = value?.trim();
    return text == null || text.isEmpty
        ? 'D'
        : text.substring(0, 1).toUpperCase();
  }
}

final class _DashboardBackground extends StatelessWidget {
  const _DashboardBackground({required this.imageBytes, required this.child});

  final Uint8List? imageBytes;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final bytes = imageBytes;
    if (bytes == null) return child;
    final overlayOpacity = Theme.of(context).brightness == Brightness.dark
        ? 0.70
        : 0.64;
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        ExcludeSemantics(
          child: Image.memory(
            bytes,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                const SizedBox.shrink(),
          ),
        ),
        ColoredBox(
          color: Theme.of(
            context,
          ).scaffoldBackgroundColor.withValues(alpha: overlayOpacity),
        ),
        child,
      ],
    );
  }
}

enum _AgendaFilter { todo, completed }

final class _AgendaPanel extends ConsumerStatefulWidget {
  const _AgendaPanel({required this.profileId, required this.profileLabel});

  final String? profileId;
  final String profileLabel;

  @override
  ConsumerState<_AgendaPanel> createState() => _AgendaPanelState();
}

final class _AgendaPanelState extends ConsumerState<_AgendaPanel> {
  var _filter = _AgendaFilter.todo;
  var _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final profileId = widget.profileId;
    if (profileId == null) return const SizedBox.shrink();
    final agenda = ref.watch(homeworkAgendaProvider(profileId));
    final sync = ref.watch(syncProfileProvider(profileId));
    final status = ref.watch(syncStatusProvider(profileId));
    return ListView(
      padding: const EdgeInsets.all(DiarioUpSpacing.lg),
      children: <Widget>[
        Text(
          '${AppCopy.dashboardGreeting}, ${widget.profileLabel}',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: DiarioUpSpacing.xs),
        _SyncStatus(
          isLoading: sync.isLoading,
          hasError: sync.hasError || status.value?.errorCode != null,
          onRetry: () => ref.invalidate(syncProfileProvider(profileId)),
        ),
        const SizedBox(height: DiarioUpSpacing.lg),
        TextField(
          onChanged: (value) {
            setState(() => _searchQuery = value.trim().toLowerCase());
          },
          decoration: const InputDecoration(
            labelText: AppCopy.searchHomework,
            hintText: AppCopy.searchHomeworkHint,
            prefixIcon: Icon(Icons.search_rounded),
          ),
        ),
        const SizedBox(height: DiarioUpSpacing.md),
        SegmentedButton<_AgendaFilter>(
          segments: const <ButtonSegment<_AgendaFilter>>[
            ButtonSegment<_AgendaFilter>(
              value: _AgendaFilter.todo,
              label: Text(AppCopy.allToDo),
              icon: Icon(Icons.radio_button_unchecked_rounded),
            ),
            ButtonSegment<_AgendaFilter>(
              value: _AgendaFilter.completed,
              label: Text(AppCopy.completed),
              icon: Icon(Icons.check_circle_outline_rounded),
            ),
          ],
          selected: <_AgendaFilter>{_filter},
          onSelectionChanged: (selection) {
            setState(() => _filter = selection.single);
          },
        ),
        const SizedBox(height: DiarioUpSpacing.lg),
        agenda.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => _AgendaError(
            onRetry: () {
              ref.invalidate(homeworkAgendaProvider(profileId));
              ref.invalidate(syncProfileProvider(profileId));
            },
          ),
          data: (items) => _AgendaContent(
            items: items
                .where(
                  (item) => _filter == _AgendaFilter.completed
                      ? item.isDone
                      : !item.isDone,
                )
                .where((item) {
                  if (_searchQuery.isEmpty) return true;
                  return item.text.toLowerCase().contains(_searchQuery) ||
                      (item.subjectName?.toLowerCase().contains(_searchQuery) ??
                          false) ||
                      (item.personalNote?.toLowerCase().contains(
                            _searchQuery,
                          ) ??
                          false);
                })
                .toList(growable: false),
            onChanged: (item, value) =>
                _setCompleted(profileId, item: item, value: value),
          ),
        ),
      ],
    );
  }

  Future<void> _setCompleted(
    String profileId, {
    required HomeworkAgendaItem item,
    required bool value,
  }) async {
    try {
      final repository = await ref.read(didupRepositoryProvider.future);
      await repository.setHomeworkCompleted(
        profileId: profileId,
        homeworkId: item.id,
        isDone: value,
      );
      if (!mounted || !value) return;
      final messenger = ScaffoldMessenger.of(context);
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(
        SnackBar(
          content: const Text(AppCopy.homeworkCompleted),
          action: SnackBarAction(
            label: AppCopy.undo,
            onPressed: () async {
              await repository.setHomeworkCompleted(
                profileId: profileId,
                homeworkId: item.id,
                isDone: false,
              );
            },
          ),
        ),
      );
    } on Object {
      ref.read(diagnosticRecorderProvider)(
        DiagnosticArea.homework,
        DiagnosticCode.completionUpdateFailed,
      );
      if (!mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(
        const SnackBar(content: Text(AppCopy.completionUpdateError)),
      );
    }
  }
}

final class _SyncStatus extends StatelessWidget {
  const _SyncStatus({
    required this.isLoading,
    required this.hasError,
    required this.onRetry,
  });

  final bool isLoading;
  final bool hasError;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(
          hasError
              ? Icons.sync_problem_rounded
              : isLoading
              ? Icons.sync_rounded
              : Icons.check_circle_outline_rounded,
          size: 20,
          color: hasError ? DiarioUpColors.ambra : DiarioUpColors.verdePetrolio,
        ),
        const SizedBox(width: DiarioUpSpacing.xs),
        Expanded(
          child: Text(
            hasError
                ? AppCopy.syncError
                : isLoading
                ? AppCopy.syncInProgress
                : AppCopy.syncStatus,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        if (hasError)
          TextButton(onPressed: onRetry, child: const Text(AppCopy.retry)),
      ],
    );
  }
}

final class _AgendaContent extends StatelessWidget {
  const _AgendaContent({required this.items, required this.onChanged});

  final List<HomeworkAgendaItem> items;
  final Future<void> Function(HomeworkAgendaItem item, bool value) onChanged;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const _FilteredEmptyCard();
    final now = DateTime.now();
    final today = SchoolDate(now.year, now.month, now.day);
    final tomorrowDate = now.add(const Duration(days: 1));
    final tomorrow = SchoolDate(
      tomorrowDate.year,
      tomorrowDate.month,
      tomorrowDate.day,
    );
    final todayItems = items.where((item) => item.dueOn == today).toList();
    final tomorrowItems = items
        .where((item) => item.dueOn == tomorrow)
        .toList();
    final nextItems = items
        .where(
          (item) => item.dueOn != null && item.dueOn!.compareTo(tomorrow) > 0,
        )
        .toList();
    final overdueItems = items
        .where((item) => item.dueOn != null && item.dueOn!.compareTo(today) < 0)
        .toList();
    final withoutDueDate = items.where((item) => item.dueOn == null).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _AgendaSection(
          label: AppCopy.today,
          items: todayItems,
          onChanged: onChanged,
        ),
        const SizedBox(height: DiarioUpSpacing.lg),
        _AgendaSection(
          label: AppCopy.tomorrow,
          items: tomorrowItems,
          onChanged: onChanged,
        ),
        const SizedBox(height: DiarioUpSpacing.lg),
        _AgendaSection(
          label: AppCopy.nextDays,
          items: nextItems,
          onChanged: onChanged,
        ),
        const SizedBox(height: DiarioUpSpacing.lg),
        _AgendaSection(
          label: AppCopy.overdue,
          items: overdueItems,
          onChanged: onChanged,
        ),
        const SizedBox(height: DiarioUpSpacing.lg),
        _AgendaSection(
          label: AppCopy.noDueDate,
          items: withoutDueDate,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

final class _AgendaSection extends StatelessWidget {
  const _AgendaSection({
    required this.label,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final List<HomeworkAgendaItem> items;
  final Future<void> Function(HomeworkAgendaItem item, bool value) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _DayHeading(label: label, count: items.length),
        if (items.isNotEmpty) const SizedBox(height: DiarioUpSpacing.sm),
        for (final item in items) ...<Widget>[
          HomeworkTile(
            item: item,
            onChanged: (value) => onChanged(item, value),
            onTap: () => context.pushNamed(
              AppRoutes.homeworkDetailName,
              pathParameters: <String, String>{'homeworkId': item.id},
            ),
          ),
          const SizedBox(height: DiarioUpSpacing.xs),
        ],
      ],
    );
  }
}

final class _DayHeading extends StatelessWidget {
  const _DayHeading({required this.label, required this.count});

  final String label;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(label, style: Theme.of(context).textTheme.titleLarge),
        ),
        Badge(label: Text('$count')),
      ],
    );
  }
}

final class _FilteredEmptyCard extends StatelessWidget {
  const _FilteredEmptyCard();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(DiarioUpSpacing.lg),
        child: Text(AppCopy.noFilteredHomework, textAlign: TextAlign.center),
      ),
    );
  }
}

final class _AgendaError extends StatelessWidget {
  const _AgendaError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(DiarioUpSpacing.lg),
        child: Column(
          children: <Widget>[
            const Text(AppCopy.agendaLoadError, textAlign: TextAlign.center),
            const SizedBox(height: DiarioUpSpacing.sm),
            FilledButton.tonal(
              onPressed: onRetry,
              child: const Text(AppCopy.retry),
            ),
          ],
        ),
      ),
    );
  }
}
