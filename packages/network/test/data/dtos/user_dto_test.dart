import 'package:flutter_test/flutter_test.dart';
import 'package:network/data/dtos/user_dto.dart';

void main() {
  final tUserDtoJson = {
    'id': 1,
    'username': 'test',
    'email': 'test@test.com',
    'firstName': 'First',
    'lastName': 'Last',
    'gender': 'male',
    'image': 'url',
    'accessToken': 'token',
  };

  group('UserDto', () {
    test('fromJson should return a valid DTO', () {
      final result = UserDto.fromJson(tUserDtoJson);
      expect(result.id, 1);
      expect(result.token, 'token');
    });

    test('toJson should return a valid JSON map', () {
      final dto = UserDto(
        id: 1,
        username: 'test',
        email: 'test@test.com',
        firstName: 'First',
        lastName: 'Last',
        gender: 'male',
        image: 'url',
        token: 'token',
      );
      final result = dto.toJson();
      expect(result['id'], 1);
      expect(result['token'], 'token');
    });
  });
}
