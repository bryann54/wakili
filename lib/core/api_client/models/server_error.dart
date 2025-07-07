import 'package:dio/dio.dart' hide Headers;
import 'package:json_annotation/json_annotation.dart';

part 'server_error.g.dart';

@JsonSerializable()
class ServerError implements Exception {
  // ServerError should implement Exception
  final String message;
  final int? statusCode; // Add statusCode for more detail

  ServerError({required this.message, this.statusCode});

  // Factory constructor to create ServerError from DioException
  factory ServerError.withError({required DioException error}) {
    String errorMessage = "Something went wrong.";
    int? statusCode;

    switch (error.type) {
      case DioExceptionType.cancel:
        errorMessage = "Request was cancelled.";
        break;
      case DioExceptionType.connectionTimeout:
        errorMessage = "Connection timeout.";
        break;
      case DioExceptionType.receiveTimeout:
        errorMessage = "Receive timeout in connection with API server.";
        break;
      case DioExceptionType.badResponse:
        statusCode = error.response?.statusCode;
        // Attempt to parse a specific error message from the response data
        try {
          if (error.response?.data is Map &&
              error.response?.data.containsKey('message')) {
            errorMessage = error.response?.data['message'] as String;
          } else if (error.response?.data is String) {
            errorMessage = error.response?.data as String;
          } else {
            errorMessage = "Server responded with an error: ${statusCode}";
          }
        } catch (e) {
          errorMessage = "Failed to parse server error: ${statusCode}";
        }
        break;
      case DioExceptionType.sendTimeout:
        errorMessage = "Send timeout in connection with API server.";
        break;
      case DioExceptionType.badCertificate:
        errorMessage = "Bad SSL certificate.";
        break;
      case DioExceptionType.connectionError:
        errorMessage =
            "Failed to connect to the internet. Please check your network connection.";
        break;
      case DioExceptionType.unknown:
      errorMessage = "An unexpected error occurred: ${error.message}";
        break;
    }
    return ServerError(message: errorMessage, statusCode: statusCode);
  }

  String getErrorMessage() => message;

  // Needed for JsonSerializable
  Map<String, dynamic> toJson() => _$ServerErrorToJson(this);
  factory ServerError.fromJson(Map<String, dynamic> json) =>
      _$ServerErrorFromJson(json);

  @override
  String toString() =>
      'ServerError(message: $message, statusCode: $statusCode)';
}
