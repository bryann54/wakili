import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure(); // No need for props here, subclasses handle it.
}

// General failures
class ServerFailure extends Failure {
  final String message;
  final int? statusCode; // Optional: To include HTTP status code

  const ServerFailure(
      {this.message = 'Something went wrong on the server.', this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];

  @override
  String toString() {
    return 'ServerFailure: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
  }
}

class CacheFailure extends Failure {
  final String message;

  const CacheFailure({this.message = 'Failed to retrieve data from cache.'});

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'CacheFailure: $message';
}

class ConnectionFailure extends Failure {
  final String message;

  const ConnectionFailure(
      {this.message =
          'Failed to connect to the internet. Please check your connection.'});

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'ConnectionFailure: $message';
}

class ClientFailure extends Failure {
  final String message;

  const ClientFailure({required this.message});

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'ClientFailure: $message';
}

class GeneralFailure extends Failure {
  final String message;

  const GeneralFailure({this.message = 'An unexpected error occurred.'});

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'GeneralFailure: $message';
}

class ValidationFailure extends Failure {
  final String message;

  const ValidationFailure(this.message);

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'ValidationFailure: $message';
}
