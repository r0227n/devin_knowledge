import '../../models/secret/secret.dart';
import '../../models/pagination/pagination.dart';
import 'base_service.dart';

/// Abstract interface for interacting with the Secrets API
/// API Documentation: https://docs.devin.ai/api-reference/secrets
abstract class SecretServiceBase extends BaseService<Secret, void> {
  @override
  /// Lists all secrets
  /// Endpoint: GET /api/secrets
  Future<PaginatedResponse<Secret>> list({
    int? page,
    int? limit,
  });

  @override
  /// Gets a secret by ID
  /// This method is not implemented in the API and will throw an error if called
  Future<Secret?> get(String id) async => throw UnimplementedError('Get secret is not implemented in the API');

  @override
  /// Creates a new secret
  /// This method is not implemented in the API and will throw an error if called
  Future<Secret> create(void request) async => throw UnimplementedError('Create secret is not implemented in the API');

  @override
  /// Deletes a secret by ID
  /// Endpoint: DELETE /api/secrets/{id}
  Future<void> delete(String id);
}
