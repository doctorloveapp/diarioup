import 'package:dio/dio.dart';

import '../../domain/release/app_release.dart';
import '../../domain/repositories/app_release_repository.dart';

final class GitHubAppReleaseRepository implements AppReleaseRepository {
  GitHubAppReleaseRepository({required Dio dio}) : _dio = dio;

  static final Uri _endpoint = Uri.https(
    'api.github.com',
    '/repos/doctorloveapp/diarioup/releases/latest',
  );
  static final Uri _releasesEndpoint = Uri.https(
    'api.github.com',
    '/repos/doctorloveapp/diarioup/releases',
    const <String, String>{'per_page': '20'},
  );

  final Dio _dio;

  @override
  Future<AppRelease> fetchLatest() async {
    try {
      final response = await _dio.getUri<Object?>(
        _endpoint,
        options: _requestOptions,
      );
      return _parseRelease(response.data);
    } on DioException catch (error) {
      if (error.response?.statusCode != 404) rethrow;
      // GitHub non espone /latest quando esistono soltanto prerelease. In
      // quel caso controlliamo l'elenco pubblico senza richiedere credenziali.
      final response = await _dio.getUri<Object?>(
        _releasesEndpoint,
        options: _requestOptions,
      );
      final data = response.data;
      if (data is! List<Object?>) {
        throw const FormatException('Risposta release non valida.');
      }
      for (final candidate in data) {
        if (candidate is Map<String, Object?> && candidate['draft'] != true) {
          return _parseRelease(candidate);
        }
      }
      throw const FormatException('Nessuna release pubblica disponibile.');
    }
  }

  static final Options _requestOptions = Options(
    headers: const <String, String>{
      'Accept': 'application/vnd.github+json',
      'X-GitHub-Api-Version': '2022-11-28',
      'Cache-Control': 'no-cache',
    },
  );

  AppRelease _parseRelease(Object? data) {
    if (data is! Map<String, Object?>) {
      throw const FormatException('Risposta release non valida.');
    }
    final tagName = data['tag_name'];
    final htmlUrl = data['html_url'];
    final releaseUri = htmlUrl is String ? Uri.tryParse(htmlUrl) : null;
    if (tagName is! String ||
        tagName.trim().isEmpty ||
        releaseUri == null ||
        releaseUri.scheme != 'https' ||
        releaseUri.host != 'github.com') {
      throw const FormatException('Metadati release non validi.');
    }
    return AppRelease(version: tagName.trim(), releasePage: releaseUri);
  }
}
