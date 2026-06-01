import 'package:flutter_test/flutter_test.dart';
import 'package:network/data/dtos/user_dto.dart';
import 'package:network/data/mappers/user_mapper.dart';
import 'package:domain/entities/user.dart';

void main() {
  final tUserDto = UserDto(
    id: 1,
    username: 'test',
    email: 'test@test.com',
    firstName: 'First',
    lastName: 'Last',
    gender: 'male',
    image: 'url',
    token: 'token',
  );

  final tUser = User(
    id: 1,
    username: 'test',
    email: 'test@test.com',
    firstName: 'First',
    lastName: 'Last',
    gender: 'male',
    image: 'url',
    token: 'token',
  );

  group('UserMapper', () {
    test('toEntity should map DTO to Entity correctly', () {
      final result = UserMapper.toEntity(tUserDto);
      expect(result.id, tUser.id);
      expect(result.username, tUser.username);
      expect(result.email, tUser.email);
    });

    test('fromEntity should map Entity to DTO correctly', () {
      final result = UserMapper.fromEntity(tUser);
      expect(result.id, tUserDto.id);
      expect(result.username, tUserDto.username);
      expect(result.email, tUserDto.email);
    });
  });
}
