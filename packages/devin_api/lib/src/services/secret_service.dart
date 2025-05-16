import '../core/api_client.dart';
import '../core/api_constants.dart';
import '../models/secret/secret.dart';
import '../models/pagination/pagination.dart';

/// Base service interface for common API operations
/// This interface defines methods common to all API services
sealed class SecretBaseService<T, C> {
  /// Lists all items with pagination
  ///
  /// Parameters:
  ///   page: The page number (1-indexed)
  ///   limit: The number of items per page
  Future<PaginatedResponse<T>> list({int? page, int? limit});

  /// Gets an item by ID
  ///
  /// Parameters:
  ///   id: The ID of the item to get
  Future<T?> get(String id);

  /// Creates a new item
  ///
  /// Parameters:
  ///   request: The request data for creating the item
  Future<T> create(C request);

  /// Deletes an item by ID
  ///
  /// Parameters:
  ///   id: The ID of the item to delete
  Future<void> delete(String id);
}

/// Abstract interface for interacting with the Secrets API
/// API Documentation: https://docs.devin.ai/api-reference/secrets
sealed class SecretServiceBase extends SecretBaseService<Secret, void> {
  @override
  /// Lists all secrets
  /// Endpoint: GET /api/secrets
  Future<PaginatedResponse<Secret>> list({int? page, int? limit});

  @override
  /// Gets a secret by ID
  /// This method is not implemented in the API and will throw an error if called
  Future<Secret?> get(String id);

  @override
  /// Creates a new secret
  /// This method is not implemented in the API and will throw an error if called
  Future<Secret> create(void request);

  @override
  /// Deletes a secret by ID
  /// Endpoint: DELETE /api/secrets/{id}
  Future<void> delete(String id);
}

/// Implementation of [SecretServiceBase]
/// API Documentation: https://docs.devin.ai/api-reference/secrets
class SecretService implements SecretServiceBase {
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
