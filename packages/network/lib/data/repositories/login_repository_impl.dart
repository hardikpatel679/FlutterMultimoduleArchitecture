import 'package:domain/entities/user.dart';
import 'package:domain/repositories/login_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../mappers/user_mapper.dart';

class LoginRepositoryImpl implements LoginRepository {
  final AuthRemoteDataSource remoteDataSource;

  LoginRepositoryImpl({required this.remoteDataSource});

  @override
  Future<User> login(String username, String password) async {
    final userDto = await remoteDataSource.login(username, password);
    return UserMapper.toEntity(userDto);
  }

}
