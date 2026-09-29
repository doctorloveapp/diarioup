import 'package:diarioup/diarioup.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fakes.dart';

void main() {
  test('legge la release pubblica piu recente dalla API GitHub', () async {
    final adapter = ScriptedAdapter((request) {
      expect(request.uri.host, 'api.github.com');
      expect(request.uri.path, '/repos/doctorloveapp/diarioup/releases/latest');
      expect(request.headers['Cache-Control'], 'no-cache');
      return jsonResponse(200, <String, Object?>{
        'tag_name': 'v1.5.0',
        'html_url':
            'https://github.com/doctorloveapp/diarioup/releases/tag/v1.5.0',
      });
    });
    final repository = GitHubAppReleaseRepository(
      dio: Dio()..httpClientAdapter = adapter,
    );

    final release = await repository.fetchLatest();

    expect(release.version, 'v1.5.0');
    expect(release.releasePage.host, 'github.com');
    expect(adapter.requests, hasLength(1));
  });

  test(
    'usa la prima prerelease pubblica quando latest restituisce 404',
    () async {
      final adapter = ScriptedAdapter((request) {
        if (request.uri.path.endsWith('/latest')) {
          return jsonResponse(404, <String, Object?>{'message': 'Not Found'});
        }
        expect(request.uri.path, '/repos/doctorloveapp/diarioup/releases');
        expect(request.uri.queryParameters['per_page'], '20');
        return jsonResponse(200, <Object?>[
          <String, Object?>{
            'tag_name': 'v1.5.0-beta.1',
            'html_url':
                'https://github.com/doctorloveapp/diarioup/releases/tag/v1.5.0-beta.1',
            'draft': false,
            'prerelease': true,
          },
        ]);
      });
      final repository = GitHubAppReleaseRepository(
        dio: Dio()..httpClientAdapter = adapter,
      );

      final release = await repository.fetchLatest();

      expect(release.version, 'v1.5.0-beta.1');
      expect(adapter.requests, hasLength(2));
    },
  );
}
