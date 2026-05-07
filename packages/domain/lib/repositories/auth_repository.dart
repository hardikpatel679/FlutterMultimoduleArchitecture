import 'package:core/entities/user.dart';

abstract interface class AuthRepository {
  Future<User> login(String username, String password);
  Future<User> getProfile(String token);
}
