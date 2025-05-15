import 'package:meta/meta.dart';
import '../core/api_client.dart';
import '../core/api_constants.dart';
import '../models/secret/secret.dart';
import '../models/pagination/pagination.dart';

/// Service for interacting with the Secrets API
/// API Documentation: https://docs.devin.ai/api-reference/secrets
class SecretService {
  /// The API client
  final DevinApiClient _apiClient;

  /// Creates a new [SecretService]
  SecretService({
    required DevinApiClient apiClient,
  }) : _apiClient = apiClient;

  /// Lists all secrets
  /// Endpoint: GET /api/secrets
  Future<PaginatedResponse<Secret>> listSecrets({
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

  /// Deletes a secret by ID
  /// Endpoint: DELETE /api/secrets/{id}
  Future<void> deleteSecret(String id) async {
    await _apiClient.delete('${DevinApiConstants.secrets}/$id');
  }
}
