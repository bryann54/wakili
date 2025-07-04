class ServerException implements Exception {
  final String? message;
  ServerException({this.message});
}

class CacheException implements Exception {}

class DatabaseException implements Exception {}

class ClientException implements Exception {
  final String message;
  ClientException({required this.message});
}
