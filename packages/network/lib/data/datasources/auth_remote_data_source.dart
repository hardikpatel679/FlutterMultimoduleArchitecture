import '../dtos/user_dto.dart';

abstract interface class AuthRemoteDataSource {
  Future<UserDto> login(String username, String password);
}
