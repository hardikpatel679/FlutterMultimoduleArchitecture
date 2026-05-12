extension StringExtensions on String {
  /// Replaces placeholders like {name} with values from the map.
  String format(Map<String, String> values) {
    var result = this;
    values.forEach((key, value) {
      result = result.replaceAll('{$key}', value);
    });
    return result;
  }
}
