import 'package:domain/entities/user.dart';
import '../dtos/user_dto.dart';

class UserMapper {
  static User toEntity(UserDto dto) {
    return User(
      id: dto.id,
      username: dto.username,
      email: dto.email,
      firstName: dto.firstName,
      lastName: dto.lastName,
      gender: dto.gender,
      image: dto.image,
      token: dto.token,
    );
  }

  static UserDto fromEntity(User entity) {
    return UserDto(
      id: entity.id,
      username: entity.username,
      email: entity.email,
      firstName: entity.firstName,
      lastName: entity.lastName,
      gender: entity.gender,
      image: entity.image,
      token: entity.token,
    );
  }
}
