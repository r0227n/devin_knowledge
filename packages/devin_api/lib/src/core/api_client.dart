import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_constants.dart';
import 'api_exception.dart';

/// Base API client for the Devin API
class DevinApiClient {
  /// Creates a new [DevinApiClient]
  DevinApiClient({required this.apiKey, http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client();

  /// The API key for authentication
  final String apiKey;

  /// The HTTP client for making requests
  final http.Client _httpClient;

  /// Closes the HTTP client
  void close() {
    _httpClient.close();
  }

  /// Makes a GET request to the specified [endpoint]
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? queryParameters,
  }) async {
    final uri = Uri.parse(
      '${DevinApiConstants.baseUrl}/$endpoint',
    ).replace(queryParameters: queryParameters);

    final response = await _httpClient.get(uri, headers: _createHeaders());

    return _handleResponse(response);
  }

  /// Makes a POST request to the specified [endpoint] with the given [body]
  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, String>? additionalHeaders,
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse('${DevinApiConstants.baseUrl}/$endpoint');

    final response = await _httpClient.post(
      uri,
      headers: _createHeaders(),
      body: body != null ? jsonEncode(body) : null,
    );

    return _handleResponse(response);
  }

  /// Makes a PUT request to the specified [endpoint] with the given [body]
  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse('${DevinApiConstants.baseUrl}/$endpoint');

    final response = await _httpClient.put(
      uri,
      headers: _createHeaders(),
      body: body != null ? jsonEncode(body) : null,
    );

    return _handleResponse(response);
  }

  /// Makes a DELETE request to the specified [endpoint]
  Future<Map<String, dynamic>> delete(String endpoint) async {
    final uri = Uri.parse('${DevinApiConstants.baseUrl}$endpoint');

    final response = await _httpClient.delete(uri, headers: _createHeaders());

    return _handleResponse(response);
  }

  /// Creates the headers for the API request
  Map<String, String> _createHeaders({Map<String, String>? additionalHeaders}) {
    return {
      if (additionalHeaders != null) ...additionalHeaders,
      'Content-Type': 'application/json',
      DevinApiConstants.authHeaderKey:
          '${DevinApiConstants.authHeaderValuePrefix}$apiKey',
    };
  }

  /// Handles the HTTP response and throws an exception if an error occurs
  Map<String, dynamic> _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    final responseBody =
        response.body.isNotEmpty
            ? jsonDecode(response.body) as Map<String, dynamic>
            : <String, dynamic>{};

    print(responseBody);

    if (statusCode >= 200 && statusCode < 300) {
      return responseBody;
    }

    // Handle error responses
    final errorMessage =
        responseBody['error']?['message'] as String? ??
        _getErrorMessageForStatusCode(statusCode);
    final errorCode = responseBody['error']?['code'] as String?;

    throw DevinApiException(
      statusCode: statusCode,
      message: errorMessage,
      errorCode: errorCode,
      response: responseBody,
    );
  }

  /// Gets the error message for the given status code
  String _getErrorMessageForStatusCode(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request';
      case 401:
        return 'Invalid API key provided';
      case 403:
        return 'Forbidden';
      case 404:
        return 'Not found';
      case 429:
        return 'Too many requests';
      case 500:
      case 502:
      case 503:
      case 504:
        return 'Server error occurred';
      default:
        return 'Unknown error occurred';
    }
  }
}
