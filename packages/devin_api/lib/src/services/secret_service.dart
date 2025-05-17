import '../core/api_client.dart';
import '../core/api_constants.dart';
import '../models/secret.dart';
import '../models/list_response.dart';

/// Secret Endpoints
/// API Documentation: https://docs.devin.ai/api-reference/overview#secrets
class SecretService {
  /// Creates a new [SecretService]
  const SecretService({required DevinApiClient apiClient})
    : _apiClient = apiClient;

  /// The API client
  final DevinApiClient _apiClient;

  /// Lists all secrets
  /// Endpoint: GET /api/secrets
  Future<ListResponse<Secret>> list() async {
    final response = await _apiClient.get(DevinApiConstants.secrets);

    return ListResponse<Secret>.fromJson(response);
  }

  /// Deletes a secret by ID
  /// Endpoint: DELETE /api/secrets/{id}
  Future<void> delete(String id) async {
    await _apiClient.delete('${DevinApiConstants.secrets}/$id');
  }
}
