import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'query_hotel_model.g.dart';

@JsonSerializable()
class QueryHotelModel extends Equatable {
  final String engine;
  final String q;
  final String gl;
  final String hl;
  final String currency;
  @JsonKey(name: 'check_in_date')
  final String checkInDate;
  @JsonKey(name: 'check_out_date')
  final String checkOutDate;
  @JsonKey(name: 'next_page_token')
  final String? nextPageToken;

  factory QueryHotelModel.fromJson(Map<String, dynamic> json) =>
      _$QueryHotelModelFromJson(json);

  const QueryHotelModel({
    required this.engine,
    required this.q,
    required this.gl,
    required this.hl,
    required this.currency,
    required this.checkInDate,
    required this.checkOutDate,
    this.nextPageToken,
  });

  Map<String, dynamic> toJson() => _$QueryHotelModelToJson(this);

  static List<QueryHotelModel> fromJsonList(dynamic response) =>
      (response as List).map((x) => QueryHotelModel.fromJson(x)).toList();

  @override
  List<Object?> get props =>
      [engine, q, gl, hl, currency, checkInDate, checkOutDate];
}
