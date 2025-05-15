import 'dart:convert';
import 'package:devin_api/devin_api.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockHttpClient extends Mock implements http.Client {}
class MockResponse extends Mock implements http.Response {}

void main() {
  group('DevinClient', () {
    late MockHttpClient mockHttpClient;
    late http.Response mockResponse;
    
    setUp(() {
      mockHttpClient = MockHttpClient();
      mockResponse = MockResponse();
      
      when(() => mockResponse.statusCode).thenReturn(200);
      when(() => mockResponse.body).thenReturn('{}');
    });
    
    test('Session service - listSessions returns a paginated list of sessions', () async {
      // TODO: Implement test for listSessions once we can inject the HTTP client
      // into the DevinClient for testing
    });
    
    test('Session service - getSession returns a session by ID', () async {
      // TODO: Implement test for getSession
    });
    
    test('Session service - createSession creates a new session', () async {
      // TODO: Implement test for createSession
    });
    
    test('Knowledge service - listKnowledge returns a paginated list of knowledge items', () async {
      // TODO: Implement test for listKnowledge
    });
    
    test('Knowledge service - getKnowledge returns a knowledge item by ID', () async {
      // TODO: Implement test for getKnowledge
    });
    
    test('Knowledge service - createKnowledge creates a new knowledge item', () async {
      // TODO: Implement test for createKnowledge
    });
    
    test('Secret service - listSecrets returns a paginated list of secrets', () async {
      // TODO: Implement test for listSecrets
    });
    
    test('Error handling - throws DevinApiException on error response', () async {
      // TODO: Implement test for error handling
    });
  });
  
  group('Session', () {
    test('fromJson creates a Session from JSON', () {
      final json = {
        'id': 'test-id',
        'name': 'Test Session',
        'status': 'active',
        'created_at': '2023-01-01T00:00:00Z',
        'updated_at': '2023-01-02T00:00:00Z',
      };
      
      final session = Session.fromJson(json);
      
      expect(session.id, equals('test-id'));
      expect(session.name, equals('Test Session'));
      expect(session.status, equals('active'));
      expect(session.createdAt, equals(DateTime.parse('2023-01-01T00:00:00Z')));
      expect(session.updatedAt, equals(DateTime.parse('2023-01-02T00:00:00Z')));
    });
    
    test('toJson converts a Session to JSON', () {
      final session = Session(
        id: 'test-id',
        name: 'Test Session',
        status: 'active',
        createdAt: DateTime.parse('2023-01-01T00:00:00Z'),
        updatedAt: DateTime.parse('2023-01-02T00:00:00Z'),
      );
      
      final json = session.toJson();
      
      expect(json['id'], equals('test-id'));
      expect(json['name'], equals('Test Session'));
      expect(json['status'], equals('active'));
      expect(json['created_at'], equals('2023-01-01T00:00:00.000Z'));
      expect(json['updated_at'], equals('2023-01-02T00:00:00.000Z'));
    });
  });
  
  group('Knowledge', () {
    test('fromJson creates a Knowledge from JSON', () {
      final json = {
        'id': 'test-id',
        'title': 'Test Knowledge',
        'content': 'Test Content',
        'created_at': '2023-01-01T00:00:00Z',
        'updated_at': '2023-01-02T00:00:00Z',
      };
      
      final knowledge = Knowledge.fromJson(json);
      
      expect(knowledge.id, equals('test-id'));
      expect(knowledge.title, equals('Test Knowledge'));
      expect(knowledge.content, equals('Test Content'));
      expect(knowledge.createdAt, equals(DateTime.parse('2023-01-01T00:00:00Z')));
      expect(knowledge.updatedAt, equals(DateTime.parse('2023-01-02T00:00:00Z')));
    });
    
    test('toJson converts a Knowledge to JSON', () {
      final knowledge = Knowledge(
        id: 'test-id',
        title: 'Test Knowledge',
        content: 'Test Content',
        createdAt: DateTime.parse('2023-01-01T00:00:00Z'),
        updatedAt: DateTime.parse('2023-01-02T00:00:00Z'),
      );
      
      final json = knowledge.toJson();
      
      expect(json['id'], equals('test-id'));
      expect(json['title'], equals('Test Knowledge'));
      expect(json['content'], equals('Test Content'));
      expect(json['created_at'], equals('2023-01-01T00:00:00.000Z'));
      expect(json['updated_at'], equals('2023-01-02T00:00:00.000Z'));
    });
  });
  
  group('Secret', () {
    test('fromJson creates a Secret from JSON', () {
      final json = {
        'id': 'test-id',
        'name': 'Test Secret',
        'created_at': '2023-01-01T00:00:00Z',
      };
      
      final secret = Secret.fromJson(json);
      
      expect(secret.id, equals('test-id'));
      expect(secret.name, equals('Test Secret'));
      expect(secret.createdAt, equals(DateTime.parse('2023-01-01T00:00:00Z')));
    });
    
    test('toJson converts a Secret to JSON', () {
      final secret = Secret(
        id: 'test-id',
        name: 'Test Secret',
        createdAt: DateTime.parse('2023-01-01T00:00:00Z'),
      );
      
      final json = secret.toJson();
      
      expect(json['id'], equals('test-id'));
      expect(json['name'], equals('Test Secret'));
      expect(json['created_at'], equals('2023-01-01T00:00:00.000Z'));
    });
  });
  
  group('PaginatedResponse', () {
    test('fromJson creates a PaginatedResponse from JSON', () {
      final json = {
        'items': [
          {
            'id': 'test-id-1',
            'name': 'Test Session 1',
            'status': 'active',
            'created_at': '2023-01-01T00:00:00Z',
            'updated_at': '2023-01-02T00:00:00Z',
          },
          {
            'id': 'test-id-2',
            'name': 'Test Session 2',
            'status': 'active',
            'created_at': '2023-01-03T00:00:00Z',
            'updated_at': '2023-01-04T00:00:00Z',
          },
        ],
        'page_info': {
          'total': 2,
          'limit': 10,
          'page': 1,
          'has_more': false,
        },
      };
      
      final response = PaginatedResponse<Session>.fromJson(
        json,
        (json) => Session.fromJson(json),
      );
      
      expect(response.items.length, equals(2));
      expect(response.items[0].id, equals('test-id-1'));
      expect(response.items[1].id, equals('test-id-2'));
      expect(response.pageInfo.total, equals(2));
      expect(response.pageInfo.limit, equals(10));
      expect(response.pageInfo.page, equals(1));
      expect(response.pageInfo.hasMore, equals(false));
    });
  });
}
