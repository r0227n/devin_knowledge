import 'package:devin_api/devin_api.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../test_helpers/mock_client.dart';

void main() {
  group('SecretService', () {
    late MockHttpClient mockHttpClient;
    late MockResponse mockResponse;
    late DevinApiClient apiClient;
    late SecretService secretService;

    setUp(() {
      mockHttpClient = MockHttpClient();
      mockResponse = MockResponse();
      apiClient = DevinApiClient(
        apiKey: 'test-api-key',
        httpClient: mockHttpClient,
      );
      secretService = SecretService(apiClient: apiClient);

      when(() => mockResponse.statusCode).thenReturn(200);
      when(() => mockResponse.body).thenReturn('{}');
    });

    group('list', () {
      test('returns a paginated list of secrets', () async {
        // Arrange
        final responseJson = {
          'items': [
            {
              'id': 'secret-1',
              'name': 'Test Secret 1',
              'created_at': '2023-01-01T00:00:00Z',
            },
            {
              'id': 'secret-2',
              'name': 'Test Secret 2',
              'created_at': '2023-01-03T00:00:00Z',
            },
          ],
          'page_info': {'total': 2, 'limit': 10, 'page': 1, 'has_more': false},
        };

        when(() => mockResponse.body).thenReturn(jsonEncode(responseJson));
        when(
          () => mockHttpClient.get(
            Uri.parse('https://api.devin.ai/api/secrets?page=1&limit=10'),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await secretService.list(page: 1, limit: 10);

        // Assert
        expect(result.items.length, equals(2));
        expect(result.items[0].id, equals('secret-1'));
        expect(result.items[1].id, equals('secret-2'));
        expect(result.pageInfo.total, equals(2));
        expect(result.pageInfo.limit, equals(10));
        expect(result.pageInfo.page, equals(1));
        expect(result.pageInfo.hasMore, equals(false));

        verify(
          () => mockHttpClient.get(
            Uri.parse('https://api.devin.ai/api/secrets?page=1&limit=10'),
            headers: any(named: 'headers'),
          ),
        ).called(1);
      });
    });

    group('delete', () {
      test('deletes a secret by ID', () async {
        // Arrange
        when(
          () => mockHttpClient.delete(
            Uri.parse('https://api.devin.ai/api/secrets/secret-1'),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer((_) async => mockResponse);

        // Act
        await secretService.delete('secret-1');

        // Assert
        verify(
          () => mockHttpClient.delete(
            Uri.parse('https://api.devin.ai/api/secrets/secret-1'),
            headers: any(named: 'headers'),
          ),
        ).called(1);
      });
    });
  });
}
