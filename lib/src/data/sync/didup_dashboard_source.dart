import '../client/didup_client.dart';

abstract interface class DidupDashboardSource {
  Future<Map<String, Object?>> download({
    required String profileId,
    required DateTime since,
  });
}

final class NetworkDidupDashboardSource implements DidupDashboardSource {
  const NetworkDidupDashboardSource(this._client);

  final DidupClient _client;

  @override
  Future<Map<String, Object?>> download({
    required String profileId,
    required DateTime since,
  }) => _client.fetchDashboard(profileId: profileId, since: since);
}
