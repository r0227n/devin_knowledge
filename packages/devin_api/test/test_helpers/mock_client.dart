import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

/// Mock HTTP client for testing
class MockHttpClient extends Mock implements http.Client {}

/// Mock HTTP response for testing
class MockResponse extends Mock implements http.Response {}

/// Helper function to encode JSON
String jsonEncode(Object? object) => json.encode(object);
