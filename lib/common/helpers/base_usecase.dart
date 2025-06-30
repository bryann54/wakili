import 'package:wakili/core/errors/failures.dart';
import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type?>> call(Params params);
}

// Pass this when the usecase expects no parameters
// e.g a call to get a list of shows
class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetHotelsParams extends Equatable {
  final String engine;
  final String q;
  final String gl;
  final String hl;
  final String currency;
  final String checkInDate;
  final String checkOutDate;
  final String? nextPageToken;

  const GetHotelsParams({
    this.engine = 'google_hotels',
    this.q = 'Bali Resorts',
    this.gl = 'us',
    this.hl = 'en',
    this.currency = 'USD',
    required this.checkInDate,
    required this.checkOutDate,
    this.nextPageToken,
  });

  GetHotelsParams copyWith({
    String? engine,
    String? q,
    String? gl,
    String? hl,
    String? currency,
    String? checkInDate,
    String? checkOutDate,
    String? nextPageToken,
  }) {
    return GetHotelsParams(
      engine: engine ?? this.engine,
      q: q ?? this.q,
      gl: gl ?? this.gl,
      hl: hl ?? this.hl,
      currency: currency ?? this.currency,
      checkInDate: checkInDate ?? this.checkInDate,
      checkOutDate: checkOutDate ?? this.checkOutDate,
      nextPageToken: nextPageToken ?? this.nextPageToken,
    );
  }

  @override
  List<Object?> get props => [
    engine,
    q,
    gl,
    hl,
    currency,
    checkInDate,
    checkOutDate,
  ];
}
