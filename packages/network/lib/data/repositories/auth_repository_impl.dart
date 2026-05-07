import 'package:core/entities/user.dart';
import 'package:domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../mappers/user_mapper.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<User> login(String username, String password) async {
    final userDto = await remoteDataSource.login(username, password);
    return UserMapper.toEntity(userDto);
  }

}
