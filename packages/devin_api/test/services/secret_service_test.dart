import 'package:devin_api/devin_api.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../test_helpers/mock_client.dart';

void main() {
  setUpAll(() {
    registerFallbackValues();
  });
  
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
      
      // Setup mock HTTP client to return a response
      when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => mockResponse);
      when(() => mockHttpClient.delete(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => mockResponse);
    });

    group('list', () {
      test('returns a list of secrets', () async {
        // Arrange
        final responseJson = {
          'secrets': [
            {
              'id': 'secret-1',
              'key': 'Test Secret 1',
              'type': 'key-value',
              'created_at': '2023-01-01T00:00:00Z',
            },
            {
              'id': 'secret-2',
              'key': 'Test Secret 2',
              'type': 'cookie',
              'created_at': '2023-01-03T00:00:00Z',
            },
          ],
        };

        when(() => mockResponse.body).thenReturn(jsonEncode(responseJson));

        // Act
        final result = await secretService.list();

        // Assert
        expect(result.items.length, equals(2));
        expect(result.items[0].id, equals('secret-1'));
        expect(result.items[0].key, equals('Test Secret 1'));
        expect(result.items[0].type, equals(SecretType.keyValue));
        expect(result.items[1].id, equals('secret-2'));
        expect(result.items[1].type, equals(SecretType.cookie));

        verify(
          () => mockHttpClient.get(
            Uri.parse('${DevinApiConstants.baseUrl}/${DevinApiConstants.secrets}'),
            headers: any(named: 'headers'),
          ),
        ).called(1);
      });
    });

    group('delete', () {
      test('deletes a secret by ID', () async {
        // Act
        await secretService.delete('secret-1');

        // Assert
        verify(
          () => mockHttpClient.delete(
            Uri.parse('${DevinApiConstants.baseUrl}/${DevinApiConstants.secrets}/secret-1'),
            headers: any(named: 'headers'),
          ),
        ).called(1);
      });
    });
  });
}
