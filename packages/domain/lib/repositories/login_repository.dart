import '../entities/user.dart';

abstract interface class LoginRepository {
  Future<User> login(String username, String password);
}
