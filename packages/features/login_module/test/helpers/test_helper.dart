import 'dart:convert';
import 'dart:io';

import 'package:domain/entities/user.dart';
import 'package:network/data/dtos/user_dto.dart';
import 'package:network/data/mappers/user_mapper.dart';

class TestHelper {
  static User getUserFromMockJson() {
    // When running 'flutter test' from root, the path starts from root
    final file = File('assets/mocks/login_success.json');
    if (!file.existsSync()) {
      // Fallback for running from inside a subfolder or package
      final alternateFile = File('../../assets/mocks/login_success.json');
      if (alternateFile.existsSync()) {
        return _parseUser(alternateFile);
      }
      // Another fallback for deep nested tests
      final alternateFile2 = File('../../../assets/mocks/login_success.json');
      if (alternateFile2.existsSync()) {
        return _parseUser(alternateFile2);
      }
      throw Exception('Could not find mock JSON file at ${file.absolute.path}');
    }
    return _parseUser(file);
  }

  static User _parseUser(File file) {
    final jsonString = file.readAsStringSync();
    final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
    final dto = UserDto.fromJson(jsonMap);
    return UserMapper.toEntity(dto);
  }
}
