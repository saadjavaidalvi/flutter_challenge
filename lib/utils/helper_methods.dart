class HelperMethods {
  String capitalize(String string) {
    if (string.isEmpty) {
      return string;
    }
    final firstChar = string[0];
    return "${firstChar.toUpperCase()}${string.substring(1)}";
  }
}
