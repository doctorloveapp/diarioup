import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/agenda/homework_agenda_item.dart';
import '../../domain/homework/school_date.dart';
import '../controllers/app_flow_controller.dart';
import '../design_system/diarioup_tokens.dart';
import '../l10n/app_copy.dart';
import '../providers/app_providers.dart';
import '../widgets/brand_mark.dart';

final class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

final class _DashboardPageState extends ConsumerState<DashboardPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(appFlowProvider).activeProfile;
    final pages = <Widget>[
      _AgendaPanel(
        profileId: profile?.sourceProfileId,
        profileLabel: profile?.displayLabel ?? AppCopy.appName,
      ),
      const _PlaceholderPanel(
        icon: Icons.menu_book_outlined,
        title: AppCopy.subjects,
      ),
      _SettingsPanel(
        onSignOut: () async {
          final repository = await ref.read(didupRepositoryProvider.future);
          await repository.logout();
          ref.read(appFlowProvider.notifier).signOut();
        },
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const BrandMark(compact: true),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: DiarioUpSpacing.md),
            child: CircleAvatar(
              backgroundColor: DiarioUpColors.indaco.withValues(alpha: 0.16),
              child: Text(
                _initial(profile?.displayLabel),
                style: const TextStyle(
                  color: DiarioUpColors.indaco,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(child: pages[_selectedIndex]),
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

  String _initial(String? value) {
    final text = value?.trim();
    return text == null || text.isEmpty
        ? 'D'
        : text.substring(0, 1).toUpperCase();
  }
}

final class _AgendaPanel extends ConsumerWidget {
  const _AgendaPanel({required this.profileId, required this.profileLabel});

  final String? profileId;
  final String profileLabel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = profileId;
    if (id == null) return const SizedBox.shrink();
    final agenda = ref.watch(homeworkAgendaProvider(id));
    final sync = ref.watch(syncProfileProvider(id));
    final status = ref.watch(syncStatusProvider(id));
    return ListView(
      padding: const EdgeInsets.all(DiarioUpSpacing.lg),
      children: <Widget>[
        Text(
          '${AppCopy.dashboardGreeting}, $profileLabel',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: DiarioUpSpacing.xs),
        _SyncStatus(
          isLoading: sync.isLoading,
          hasError: sync.hasError || status.value?.errorCode != null,
          onRetry: () => ref.invalidate(syncProfileProvider(id)),
        ),
        const SizedBox(height: DiarioUpSpacing.lg),
        agenda.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => _AgendaError(
            onRetry: () {
              ref.invalidate(homeworkAgendaProvider(id));
              ref.invalidate(syncProfileProvider(id));
            },
          ),
          data: (items) => _AgendaContent(
            items: items,
            onChanged: (item, value) async {
              try {
                final repository = await ref.read(
                  didupRepositoryProvider.future,
                );
                await repository.setHomeworkCompleted(
                  profileId: id,
                  homeworkId: item.id,
                  isDone: value,
                );
              } on Object {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text(AppCopy.completionUpdateError)),
                );
              }
            },
          ),
        ),
      ],
    );
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
    if (items.isEmpty) return const _EmptyAgendaCard();
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
    final otherItems = items
        .where((item) => item.dueOn != today && item.dueOn != tomorrow)
        .toList();
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
          items: otherItems,
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
          Card(
            child: CheckboxListTile(
              value: item.isDone,
              onChanged: (value) async {
                if (value != null) await onChanged(item, value);
              },
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(
                item.text,
                style: item.isDone
                    ? const TextStyle(decoration: TextDecoration.lineThrough)
                    : null,
              ),
              subtitle: Text(
                <String>[
                  ?item.subjectName,
                  if (item.changedAfterCompletion)
                    AppCopy.changedAfterCompletion,
                  if (item.requiresIdentityReview) AppCopy.identityReview,
                ].join(' · '),
              ),
            ),
          ),
          const SizedBox(height: DiarioUpSpacing.xs),
        ],
      ],
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

final class _EmptyAgendaCard extends StatelessWidget {
  const _EmptyAgendaCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(DiarioUpSpacing.lg),
        child: Column(
          children: <Widget>[
            const Icon(
              Icons.auto_awesome_outlined,
              size: 32,
              color: DiarioUpColors.indaco,
            ),
            const SizedBox(height: DiarioUpSpacing.sm),
            Text(
              AppCopy.demoEmptyTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: DiarioUpSpacing.xs),
            const Text(AppCopy.demoEmptyBody, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

final class _PlaceholderPanel extends StatelessWidget {
  const _PlaceholderPanel({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DiarioUpSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: 48, color: DiarioUpColors.indaco),
            const SizedBox(height: DiarioUpSpacing.md),
            Text(title, style: Theme.of(context).textTheme.headlineMedium),
          ],
        ),
      ),
    );
  }
}

final class _SettingsPanel extends StatelessWidget {
  const _SettingsPanel({required this.onSignOut});

  final Future<void> Function() onSignOut;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(DiarioUpSpacing.lg),
      children: <Widget>[
        Text(
          AppCopy.settings,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: DiarioUpSpacing.lg),
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
