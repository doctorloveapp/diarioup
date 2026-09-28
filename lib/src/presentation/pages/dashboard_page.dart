import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      _AgendaPanel(profileLabel: profile?.displayLabel ?? AppCopy.appName),
      const _PlaceholderPanel(
        icon: Icons.menu_book_outlined,
        title: AppCopy.subjects,
      ),
      _SettingsPanel(
        onSignOut: () async {
          await ref.read(didupRepositoryProvider).logout();
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

final class _AgendaPanel extends StatelessWidget {
  const _AgendaPanel({required this.profileLabel});

  final String profileLabel;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(DiarioUpSpacing.lg),
      children: <Widget>[
        Text(
          '${AppCopy.dashboardGreeting}, $profileLabel',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: DiarioUpSpacing.xs),
        const _SyncStatus(),
        const SizedBox(height: DiarioUpSpacing.lg),
        const _DayHeading(label: AppCopy.today, count: 0),
        const SizedBox(height: DiarioUpSpacing.sm),
        const _EmptyAgendaCard(),
        const SizedBox(height: DiarioUpSpacing.lg),
        const _DayHeading(label: AppCopy.tomorrow, count: 0),
        const SizedBox(height: DiarioUpSpacing.lg),
        const _DayHeading(label: AppCopy.nextDays, count: 0),
      ],
    );
  }
}

final class _SyncStatus extends StatelessWidget {
  const _SyncStatus();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const Icon(
          Icons.check_circle_outline_rounded,
          size: 20,
          color: DiarioUpColors.verdePetrolio,
        ),
        const SizedBox(width: DiarioUpSpacing.xs),
        Text(AppCopy.syncStatus, style: Theme.of(context).textTheme.bodyMedium),
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
