import 'api_endpoints.dart';

class MockPaths {
  /// Maps API endpoints to their corresponding JSON asset paths.
  static const Map<String, String> mappings = {
    ApiEndpoints.login: 'assets/mocks/auth/login_success.json',
    
    // Example for future endpoints:
    // ApiEndpoints.profile: 'assets/mocks/user/profile.json',
    // ApiEndpoints.products: 'assets/mocks/products/list.json',
  };
}
