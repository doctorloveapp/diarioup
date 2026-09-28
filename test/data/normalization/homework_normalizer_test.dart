import 'package:diarioup/diarioup.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'normalizza compiti, date civili, HTML e cancellazioni esplicite',
    () async {
      final registry = InMemoryHomeworkIdentityRegistry();
      final normalizer = HomeworkNormalizer(
        identityRegistry: registry,
        now: () => DateTime.utc(2026, 9, 27, 12),
      );

      final first = await normalizer.normalizeDashboard(
        profileId: 'profile-1',
        response: _fixture('Leggere <b>capitolo 3</b><br>Fare esercizi'),
      );

      expect(first.directive, SyncDirective.rebuildSourceCache);
      expect(first.deletedSourceRecordIds, <String>['record-deleted']);
      expect(first.homework, hasLength(1));
      final homework = first.homework.single;
      expect(homework.text, 'Leggere capitolo 3\nFare esercizi');
      expect(homework.assignedOn, const SchoolDate(2026, 9, 26));
      expect(homework.dueOn, const SchoolDate(2026, 9, 30));
      expect(homework.subject!.sourceSubjectId, 'subject-1');
      expect(
        homework.identityConfidence,
        HomeworkIdentityConfidence.persistentParentMapping,
      );
      expect(homework.requiresIdentityReview, isFalse);

      final modified = await normalizer.normalizeDashboard(
        profileId: 'profile-1',
        response: _fixture('Leggere capitolo 4'),
      );
      expect(modified.homework.single.id, homework.id);
      expect(modified.homework.single.requiresIdentityReview, isTrue);
    },
  );

  test('non interpreta l assenza da un delta come cancellazione', () async {
    final result =
        await HomeworkNormalizer(
          identityRegistry: InMemoryHomeworkIdentityRegistry(),
        ).normalizeDashboard(
          profileId: 'profile-1',
          response: <String, Object?>{
            'data': <String, Object?>{
              'dati': <Object?>[
                <String, Object?>{'registro': <Object?>[]},
              ],
            },
          },
        );

    expect(result.deletedSourceRecordIds, isEmpty);
    expect(result.directive, SyncDirective.incremental);
  });
}

Map<String, Object?> _fixture(String text) => <String, Object?>{
  'success': true,
  'data': <String, Object?>{
    'dati': <Object?>[
      <String, Object?>{
        'rimuoviDatiLocali': true,
        'registro': <Object?>[
          <String, Object?>{
            'pk': 'record-1',
            'operazione': 'I',
            'datGiorno': '26/09/2026',
            'pkMateria': 'subject-1',
            'materia': 'Italiano',
            'compiti': <Object?>[
              <String, Object?>{'compito': text, 'dataConsegna': '30/09/2026'},
            ],
          },
          <String, Object?>{'pk': 'record-deleted', 'operazione': 'D'},
        ],
      },
    ],
  },
};
