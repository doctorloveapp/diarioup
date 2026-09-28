import 'package:diarioup/diarioup.dart';
import 'package:diarioup/src/data/reminders/reminder_coordinator.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'abilitazione, cambio ora e completamento ricalcolano il piano',
    () async {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      await database.storeProfiles(const <StudentProfile>[
        StudentProfile(
          sourceProfileId: 'profile-1',
          displayLabel: 'Profilo test',
          schoolMinistryCode: 'TEST0001',
          academicYear: '2026/2027',
        ),
      ]);
      final homeworkId = await database.createManualHomework(
        const ManualHomeworkInput(
          profileId: 'profile-1',
          text: 'Compito con promemoria',
          dueOn: SchoolDate(2026, 9, 30),
        ),
      );
      final service = _FakeReminderService();
      final coordinator = ReminderCoordinator(
        database: database,
        service: service,
        now: () => DateTime(2026, 9, 28, 12),
      );

      final permission = await coordinator.enable('profile-1');
      expect(permission, ReminderPermissionStatus.granted);
      expect(service.scheduled, hasLength(1));
      expect(service.scheduled.single.hour, 18);

      await coordinator.updateTime(
        profileId: 'profile-1',
        hour: 19,
        minute: 30,
      );
      expect(service.scheduled.single.hour, 19);
      expect(service.scheduled.single.minute, 30);

      await database.setCompleted(
        sourceProfileId: 'profile-1',
        homeworkId: homeworkId,
        isDone: true,
      );
      await coordinator.reschedule('profile-1');
      expect(service.scheduled, isEmpty);
      expect(
        (await database.readReminderPreferences('profile-1')).enabled,
        isTrue,
      );
    },
  );

  test('un permesso negato non abilita i promemoria', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    await database.storeProfiles(const <StudentProfile>[
      StudentProfile(
        sourceProfileId: 'profile-1',
        displayLabel: 'Profilo test',
        schoolMinistryCode: 'TEST0001',
        academicYear: '2026/2027',
      ),
    ]);
    final coordinator = ReminderCoordinator(
      database: database,
      service: _FakeReminderService(status: ReminderPermissionStatus.denied),
    );

    final permission = await coordinator.enable('profile-1');

    expect(permission, ReminderPermissionStatus.denied);
    expect(
      (await database.readReminderPreferences('profile-1')).enabled,
      isFalse,
    );
  });
}

final class _FakeReminderService implements ReminderService {
  _FakeReminderService({this.status = ReminderPermissionStatus.granted});

  ReminderPermissionStatus status;
  List<ReminderPlanEntry> scheduled = const <ReminderPlanEntry>[];

  @override
  Future<void> initialize() async {}

  @override
  Future<ReminderPermissionStatus> permissionStatus() async => status;

  @override
  Future<ReminderPermissionStatus> requestPermission() async => status;

  @override
  Future<bool> openNotificationSettings() async => true;

  @override
  Future<void> replaceSchedule(List<ReminderPlanEntry> entries) async {
    scheduled = List<ReminderPlanEntry>.of(entries);
  }

  @override
  Future<void> cancelAll() async {
    scheduled = const <ReminderPlanEntry>[];
  }
}
