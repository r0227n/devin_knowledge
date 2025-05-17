import '../core/api_client.dart';
import '../core/api_constants.dart';
import '../models/secret.dart';
import '../models/list_response.dart';

/// Abstract interface for interacting with the Secrets API
/// API Documentation: https://docs.devin.ai/api-reference/overview#secrets
sealed class SecretServiceBase {
  /// List metadata for all secrets in your organization. Does not return secret values.
  Future<ListResponse<Secret>> list();

  /// Permanently delete a secret by its ID. This action cannot be undone.
  Future<void> delete(String id);
}

/// Secret Endpoints
/// API Documentation: https://docs.devin.ai/api-reference/overview#secrets
class SecretService implements SecretServiceBase {
  /// Creates a new [SecretService]
  const SecretService({required DevinApiClient apiClient})
    : _apiClient = apiClient;

  /// The API client
  final DevinApiClient _apiClient;

  @override
  Future<ListResponse<Secret>> list() async {
    final response = await _apiClient.get(DevinApiConstants.secrets);

    return ListResponse<Secret>.fromJson(response);
  }

  @override
  Future<void> delete(String id) async {
    await _apiClient.delete('${DevinApiConstants.secrets}/$id');
  }
}
