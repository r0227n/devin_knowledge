import 'package:devin_api/devin_api.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../test_helpers/mock_client.dart';

void main() {
  group('SessionService', () {
    late MockHttpClient mockHttpClient;
    late MockResponse mockResponse;
    late DevinApiClient apiClient;
    late SessionService sessionService;

    setUp(() {
      mockHttpClient = MockHttpClient();
      mockResponse = MockResponse();
      apiClient = DevinApiClient(
        apiKey: 'test-api-key',
        httpClient: mockHttpClient,
      );
      sessionService = SessionService(apiClient: apiClient);

      when(() => mockResponse.statusCode).thenReturn(200);
      when(() => mockResponse.body).thenReturn('{}');
    });

    group('list', () {
      test('returns a paginated list of sessions', () async {
        // Arrange
        final responseJson = {
          'items': [
            {
              'id': 'session-1',
              'name': 'Test Session 1',
              'status': 'active',
              'created_at': '2023-01-01T00:00:00Z',
              'updated_at': '2023-01-02T00:00:00Z',
            },
            {
              'id': 'session-2',
              'name': 'Test Session 2',
              'status': 'active',
              'created_at': '2023-01-03T00:00:00Z',
              'updated_at': '2023-01-04T00:00:00Z',
            },
          ],
          'page_info': {'total': 2, 'limit': 10, 'page': 1, 'has_more': false},
        };

        when(() => mockResponse.body).thenReturn(jsonEncode(responseJson));
        when(
          () => mockHttpClient.get(
            Uri.parse('https://api.devin.ai/api/sessions?page=1&limit=10'),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await sessionService.list(page: 1, limit: 10);

        // Assert
        expect(result.items.length, equals(2));
        expect(result.items[0].id, equals('session-1'));
        expect(result.items[1].id, equals('session-2'));
        expect(result.pageInfo.total, equals(2));
        expect(result.pageInfo.limit, equals(10));
        expect(result.pageInfo.page, equals(1));
        expect(result.pageInfo.hasMore, equals(false));

        verify(
          () => mockHttpClient.get(
            Uri.parse('https://api.devin.ai/api/sessions?page=1&limit=10'),
            headers: any(named: 'headers'),
          ),
        ).called(1);
      });
    });

    group('get', () {
      test('returns a session by ID', () async {
        // Arrange
        final responseJson = {
          'id': 'session-1',
          'name': 'Test Session',
          'status': 'active',
          'created_at': '2023-01-01T00:00:00Z',
          'updated_at': '2023-01-02T00:00:00Z',
        };

        when(() => mockResponse.body).thenReturn(jsonEncode(responseJson));
        when(
          () => mockHttpClient.get(
            Uri.parse('https://api.devin.ai/api/sessions/session-1'),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await sessionService.get('session-1');

        // Assert
        expect(result.id, equals('session-1'));
        expect(result.name, equals('Test Session'));
        expect(result.status, equals('active'));
        expect(
          result.createdAt,
          equals(DateTime.parse('2023-01-01T00:00:00Z')),
        );
        expect(
          result.updatedAt,
          equals(DateTime.parse('2023-01-02T00:00:00Z')),
        );

        verify(
          () => mockHttpClient.get(
            Uri.parse('https://api.devin.ai/api/sessions/session-1'),
            headers: any(named: 'headers'),
          ),
        ).called(1);
      });
    });

    group('create', () {
      test('creates a new session', () async {
        // Arrange
        final request = CreateSessionRequest(name: 'New Session');
        final responseJson = {
          'id': 'new-session',
          'name': 'New Session',
          'status': 'active',
          'created_at': '2023-01-01T00:00:00Z',
          'updated_at': '2023-01-01T00:00:00Z',
        };

        when(() => mockResponse.body).thenReturn(jsonEncode(responseJson));
        when(
          () => mockHttpClient.post(
            Uri.parse('https://api.devin.ai/api/sessions'),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          ),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await sessionService.create(request);

        // Assert
        expect(result.id, equals('new-session'));
        expect(result.name, equals('New Session'));
        expect(result.status, equals('active'));
        expect(
          result.createdAt,
          equals(DateTime.parse('2023-01-01T00:00:00Z')),
        );
        expect(
          result.updatedAt,
          equals(DateTime.parse('2023-01-01T00:00:00Z')),
        );

        verify(
          () => mockHttpClient.post(
            Uri.parse('https://api.devin.ai/api/sessions'),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          ),
        ).called(1);
      });
    });

    group('delete', () {
      test('deletes a session by ID', () async {
        // Arrange
        when(
          () => mockHttpClient.delete(
            Uri.parse('https://api.devin.ai/api/sessions/session-1'),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer((_) async => mockResponse);

        // Act
        await sessionService.delete('session-1');

        // Assert
        verify(
          () => mockHttpClient.delete(
            Uri.parse('https://api.devin.ai/api/sessions/session-1'),
            headers: any(named: 'headers'),
          ),
        ).called(1);
      });
    });

    group('sendMessage', () {
      test('sends a message to a session', () async {
        // Arrange
        when(
          () => mockHttpClient.post(
            Uri.parse('https://api.devin.ai/api/sessions/session-1/messages'),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          ),
        ).thenAnswer((_) async => mockResponse);

        // Act
        await sessionService.sendMessage('session-1', 'Hello, Devin!');

        // Assert
        verify(
          () => mockHttpClient.post(
            Uri.parse('https://api.devin.ai/api/sessions/session-1/messages'),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          ),
        ).called(1);
      });
    });
  });
}
