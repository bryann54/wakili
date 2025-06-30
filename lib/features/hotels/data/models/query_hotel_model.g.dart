// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_hotel_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueryHotelModel _$QueryHotelModelFromJson(Map<String, dynamic> json) =>
    QueryHotelModel(
      engine: json['engine'] as String,
      q: json['q'] as String,
      gl: json['gl'] as String,
      hl: json['hl'] as String,
      currency: json['currency'] as String,
      checkInDate: json['check_in_date'] as String,
      checkOutDate: json['check_out_date'] as String,
      nextPageToken: json['next_page_token'] as String?,
    );

Map<String, dynamic> _$QueryHotelModelToJson(QueryHotelModel instance) =>
    <String, dynamic>{
      'engine': instance.engine,
      'q': instance.q,
      'gl': instance.gl,
      'hl': instance.hl,
      'currency': instance.currency,
      'check_in_date': instance.checkInDate,
      'check_out_date': instance.checkOutDate,
      'next_page_token': instance.nextPageToken,
    };
