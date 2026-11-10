import 'package:diarioup/diarioup.dart';
import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fakes.dart';

void main() {
  final now = DateTime.utc(2026, 11, 10);

  DidupRepositoryImpl repository(
    MemorySessionStore store,
    ScriptedAdapter adapter,
  ) {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final network = DidupNetworkClient.create(
      config: testProtocolConfig(),
      dio: Dio()..httpClientAdapter = adapter,
    );
    addTearDown(network.dio.close);
    return DidupRepositoryImpl(
      authService: _UnusedAuthService(),
      client: DidupClient(
        networkClient: network,
        sessionStore: store,
        now: () => now,
      ),
      database: database,
      sessionStore: store,
      normalizer: HomeworkNormalizer(
        identityRegistry: InMemoryHomeworkIdentityRegistry(),
      ),
      adapterVersion: 'test',
    );
  }

  DidupSession session({bool withLabels = false}) {
    final initial = testSession(expiresAt: now.add(const Duration(hours: 1)));
    final first = initial.profiles['profile-1']!;
    return initial.copyWith(
      activeProfileId: 'profile-1',
      profiles: {
        'profile-1': withLabels ? first.withSchoolClassLabel('I B') : first,
        'profile-2': DidupProfileSession(
          sourceProfileId: 'profile-2',
          appAuthToken: 'synthetic-second-child',
          schoolMinistryCode: 'TEST0000',
          notificationOptions: const {},
          displayLabel: 'Secondo profilo sintetico',
          schoolClassLabel: withLabels ? 'III C' : null,
        ),
      },
    );
  }

  test(
    'la classe e isolata per figlio e disponibile offline dalla sessione',
    () async {
      final store = MemorySessionStore(session(withLabels: true));
      final adapter = ScriptedAdapter(
        (_) => throw StateError('Rete non prevista'),
      );
      final repo = repository(store, adapter);
      expect(await repo.readSchoolClassLabel(profileId: 'profile-1'), 'I B');
      expect(await repo.readSchoolClassLabel(profileId: 'profile-2'), 'III C');
      expect(
        await repo.readSchoolClassLabel(profileId: 'profilo-inesistente'),
        isNull,
      );
      expect(adapter.requests, isEmpty);
      expect(store.writeCount, 0);
    },
  );

  test(
    'arricchisce una vecchia sessione senza cambiare figlio attivo o token',
    () async {
      final store = MemorySessionStore(session());
      final originalToken = store.value!.accessToken;
      final adapter = ScriptedAdapter((request) {
        expect(request.uri.path.endsWith('/profilo'), isTrue);
        expect(request.headers['x-auth-token'], 'synthetic-second-child');
        return jsonResponse(200, {
          'success': true,
          'data': {
            'scheda': {
              'pk': 'profile-2',
              'classe': {'desDenominazione': '3', 'desSezione': 'C'},
            },
          },
        });
      });
      final repo = repository(store, adapter);
      expect(await repo.readSchoolClassLabel(profileId: 'profile-2'), 'III C');
      expect(await repo.readSchoolClassLabel(profileId: 'profile-2'), 'III C');
      expect(adapter.requests, hasLength(1));
      expect(store.value!.activeProfileId, 'profile-1');
      expect(store.value!.accessToken, originalToken);
      expect(store.value!.profiles['profile-1']!.schoolClassLabel, isNull);
      final restored = const SessionCodec().decode(
        const SessionCodec().encode(store.value!),
      );
      expect(restored.profiles['profile-2']!.schoolClassLabel, 'III C');
    },
  );

  test(
    'recupera la classe dopo il rinnovo senza ripristinare i vecchi token',
    () async {
      final store = MemorySessionStore(session().copyWith(expiresAt: now));
      final adapter = ScriptedAdapter((request) {
        if (request.uri.path.endsWith('/auth/refresh-token')) {
          return jsonResponse(200, {
            'access_token': 'synthetic-refreshed-access',
            'refresh_token': 'synthetic-rotated-refresh',
            'expires_in': 1800,
          });
        }
        expect(
          request.headers['authorization'],
          'Bearer synthetic-refreshed-access',
        );
        expect(request.headers['x-auth-token'], 'synthetic-second-child');
        return jsonResponse(200, {
          'data': {
            'scheda': {
              'pk': 'profile-2',
              'classe': {'desDenominazione': '3', 'desSezione': 'C'},
            },
          },
        });
      });
      expect(
        await repository(
          store,
          adapter,
        ).readSchoolClassLabel(profileId: 'profile-2'),
        'III C',
      );
      expect(store.value!.accessToken, 'synthetic-refreshed-access');
      expect(store.value!.refreshToken, 'synthetic-rotated-refresh');
      expect(store.value!.activeProfileId, 'profile-1');
      expect(
        store.value!.profiles.keys,
        containsAll(['profile-1', 'profile-2']),
      );
    },
  );

  test('rifiuta una classe ricevuta per un altro figlio', () async {
    final store = MemorySessionStore(session());
    final adapter = ScriptedAdapter(
      (_) => jsonResponse(200, {
        'data': {
          'scheda': {
            'pk': 'profile-1',
            'classe': {'desDenominazione': '1', 'desSezione': 'B'},
          },
        },
      }),
    );
    expect(
      await repository(
        store,
        adapter,
      ).readSchoolClassLabel(profileId: 'profile-2'),
      isNull,
    );
    expect(store.writeCount, 0);
  });

  test('la rete indisponibile non impedisce la condivisione offline', () async {
    final store = MemorySessionStore(session());
    final adapter = ScriptedAdapter(
      (request) => throw DioException(
        requestOptions: request,
        type: DioExceptionType.connectionError,
      ),
    );
    expect(
      await repository(
        store,
        adapter,
      ).readSchoolClassLabel(profileId: 'profile-1'),
      isNull,
    );
    expect(store.writeCount, 0);
  });

  test('il logout durante il recupero non ripristina la sessione', () async {
    final store = MemorySessionStore(session());
    final adapter = ScriptedAdapter((_) async {
      await store.clear();
      return jsonResponse(200, {
        'data': {
          'scheda': {
            'pk': 'profile-1',
            'classe': {'desDenominazione': '1', 'desSezione': 'B'},
          },
        },
      });
    });
    expect(
      await repository(
        store,
        adapter,
      ).readSchoolClassLabel(profileId: 'profile-1'),
      isNull,
    );
    expect(store.value, isNull);
    expect(store.writeCount, 0);
  });
}

final class _UnusedAuthService implements DidupAuthService {
  @override
  Future<RemoteLoginResult> login(AuthCredentials credentials) =>
      throw UnsupportedError('Login non previsto.');
}
