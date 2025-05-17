import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

/// Mock HTTP client for testing
class MockHttpClient extends Mock implements http.Client {}

/// Mock HTTP response for testing
class MockResponse extends Mock implements http.Response {}

/// Register fallback values for types used in tests
void registerFallbackValues() {
  registerFallbackValue(Uri());
  registerFallbackValue(<String, String>{});
  registerFallbackValue(<String, dynamic>{});
}

/// Helper function to encode JSON
String jsonEncode(Object? object) => json.encode(object);
