import '../../../constants/api_endpoints.dart';
import '../../../constants/network_constants.dart';
import '../../dtos/user_dto.dart';
import '../auth_remote_data_source.dart';
import '../base_remote_data_source.dart';

class AuthRemoteDataSourceImpl extends BaseRemoteDataSource implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({required super.dio});

  @override
  Future<UserDto> login(String username, String password) async {
    final data = await postRequest(
      ApiEndpoints.login,
      body: {
        AuthParams.username: username,
        AuthParams.password: password,
      },
    );
    
    return UserDto.fromJson(data);
  }
}
