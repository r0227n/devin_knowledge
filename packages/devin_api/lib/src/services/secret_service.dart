import 'base_service.dart';
import '../core/api_client.dart';
import '../core/api_constants.dart';
import '../models/secret/secret.dart';
import '../models/pagination/pagination.dart';

/// Secret Endpoints
/// API Documentation: https://docs.devin.ai/api-reference/overview#secrets
class SecretService implements SecretServiceBase<Secret> {
  /// Creates a new [SecretService]
  const SecretService({required DevinApiClient apiClient})
    : _apiClient = apiClient;

  /// The API client
  final DevinApiClient _apiClient;

  @override
  /// Lists all secrets
  /// Endpoint: GET /api/secrets
  Future<PaginatedResponse<Secret>> list({int? page, int? limit}) async {
    final response = await _apiClient.get(
      DevinApiConstants.secrets,
      queryParameters: {
        if (page != null) 'page': page.toString(),
        if (limit != null) 'limit': limit.toString(),
      },
    );

    return PaginatedResponse<Secret>.fromJson(
      response,
      (json) => Secret.fromJson(json),
    );
  }

  @override
  /// Deletes a secret by ID
  /// Endpoint: DELETE /api/secrets/{id}
  Future<void> delete(String id) async {
    await _apiClient.delete('${DevinApiConstants.secrets}/$id');
  }
}
