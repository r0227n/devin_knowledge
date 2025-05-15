import '../../core/api_client.dart';
import '../../core/api_constants.dart';
import '../../models/secret/secret.dart';
import '../../models/pagination/pagination.dart';
import '../base/secret_service_base.dart';

/// Default implementation of [SecretServiceBase]
/// API Documentation: https://docs.devin.ai/api-reference/secrets
class DefaultSecretService implements SecretServiceBase {
  /// The API client
  final DevinApiClient _apiClient;

  /// Creates a new [DefaultSecretService]
  DefaultSecretService({
    required DevinApiClient apiClient,
  }) : _apiClient = apiClient;

  @override
  /// Lists all secrets
  /// Endpoint: GET /api/secrets
  Future<PaginatedResponse<Secret>> list({
    int? page,
    int? limit,
  }) async {
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
  /// Gets a secret by ID
  /// This method is not implemented in the API and will throw an error if called
  Future<Secret?> get(String id) async => 
      throw UnimplementedError('Get secret is not implemented in the API');

  @override
  /// Creates a new secret
  /// This method is not implemented in the API and will throw an error if called
  Future<Secret> create(void request) async => 
      throw UnimplementedError('Create secret is not implemented in the API');

  @override
  /// Deletes a secret by ID
  /// Endpoint: DELETE /api/secrets/{id}
  Future<void> delete(String id) async {
    await _apiClient.delete('${DevinApiConstants.secrets}/$id');
  }
}
