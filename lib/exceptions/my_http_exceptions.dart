class MyHttpException implements Exception {
  final String message;
  final int statusCode;

  MyHttpException({required this.message, required this.statusCode});

  @override
  String toString() {
    return message;
  }
}
