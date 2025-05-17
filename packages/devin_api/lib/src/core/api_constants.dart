/// API constants for the Devin API
class DevinApiConstants {
  static const String _apiVersion = 'v1';

  static const String baseUrl = 'https://api.devin.ai';

  static const String authHeaderKey = 'Authorization';

  static const String authHeaderValuePrefix = 'Bearer ';

  static const String sessions = '$_apiVersion/sessions';

  static const String session = '$_apiVersion/session';

  static const String attachments = '$_apiVersion/attachments';

  static const String secrets = '$_apiVersion/secrets';

  static const String knowledge = '$_apiVersion/knowledge';

  static const String enterprise = '$_apiVersion/enterprise';
}
