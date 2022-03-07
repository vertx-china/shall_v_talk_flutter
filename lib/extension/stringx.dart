extension StringX on String {
  bool isPhotoUrl() {
    var lower = toLowerCase().trim();
    return lower.startsWith('http') &&
        (lower.endsWith('jpeg') ||
            lower.endsWith('png') ||
            lower.endsWith('gif') ||
            lower.endsWith('jpg'));
  }

  bool isUrl() {
    var lower = toLowerCase().trim();
    return lower.startsWith('http');
  }
}
