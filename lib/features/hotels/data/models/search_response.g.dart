// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchResponse _$SearchResponseFromJson(Map<String, dynamic> json) =>
    SearchResponse(
      searchMetadata: json['search_metadata'] == null
          ? null
          : SearchMetadata.fromJson(
              json['search_metadata'] as Map<String, dynamic>),
      searchParameters: json['search_parameters'] == null
          ? null
          : SearchParameters.fromJson(
              json['search_parameters'] as Map<String, dynamic>),
      searchInformation: json['search_information'] == null
          ? null
          : SearchInformation.fromJson(
              json['search_information'] as Map<String, dynamic>),
      brands: (json['brands'] as List<dynamic>?)
          ?.map((e) => Brand.fromJson(e as Map<String, dynamic>))
          .toList(),
      properties: (json['properties'] as List<dynamic>)
          .map((e) => PropertyModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: SerpApiPagination.fromJson(
          json['serpapi_pagination'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SearchResponseToJson(SearchResponse instance) =>
    <String, dynamic>{
      'search_metadata': instance.searchMetadata?.toJson(),
      'search_parameters': instance.searchParameters?.toJson(),
      'search_information': instance.searchInformation?.toJson(),
      'brands': instance.brands?.map((e) => e.toJson()).toList(),
      'properties': instance.properties.map((e) => e.toJson()).toList(),
      'serpapi_pagination': instance.pagination.toJson(),
    };

SearchMetadata _$SearchMetadataFromJson(Map<String, dynamic> json) =>
    SearchMetadata(
      id: json['id'] as String,
      status: json['status'] as String,
      jsonEndpoint: json['json_endpoint'] as String,
      createdAt: json['created_at'] as String,
      processedAt: json['processed_at'] as String,
      googleHotelsUrl: json['google_hotels_url'] as String,
      rawHtmlFile: json['raw_html_file'] as String,
      prettifyHtmlFile: json['prettify_html_file'] as String,
      totalTimeTaken: (json['total_time_taken'] as num).toDouble(),
    );

Map<String, dynamic> _$SearchMetadataToJson(SearchMetadata instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'json_endpoint': instance.jsonEndpoint,
      'created_at': instance.createdAt,
      'processed_at': instance.processedAt,
      'google_hotels_url': instance.googleHotelsUrl,
      'raw_html_file': instance.rawHtmlFile,
      'prettify_html_file': instance.prettifyHtmlFile,
      'total_time_taken': instance.totalTimeTaken,
    };

SearchParameters _$SearchParametersFromJson(Map<String, dynamic> json) =>
    SearchParameters(
      engine: json['engine'] as String,
      q: json['q'] as String,
      gl: json['gl'] as String,
      hl: json['hl'] as String,
      currency: json['currency'] as String,
      checkInDate: json['check_in_date'] as String,
      checkOutDate: json['check_out_date'] as String,
      adults: (json['adults'] as num).toInt(),
      children: (json['children'] as num).toInt(),
    );

Map<String, dynamic> _$SearchParametersToJson(SearchParameters instance) =>
    <String, dynamic>{
      'engine': instance.engine,
      'q': instance.q,
      'gl': instance.gl,
      'hl': instance.hl,
      'currency': instance.currency,
      'check_in_date': instance.checkInDate,
      'check_out_date': instance.checkOutDate,
      'adults': instance.adults,
      'children': instance.children,
    };

SearchInformation _$SearchInformationFromJson(Map<String, dynamic> json) =>
    SearchInformation(
      totalResults: (json['total_results'] as num).toInt(),
    );

Map<String, dynamic> _$SearchInformationToJson(SearchInformation instance) =>
    <String, dynamic>{
      'total_results': instance.totalResults,
    };

Brand _$BrandFromJson(Map<String, dynamic> json) => Brand(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      children: (json['children'] as List<dynamic>?)
          ?.map((e) => BrandChild.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BrandToJson(Brand instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'children': instance.children,
    };

BrandChild _$BrandChildFromJson(Map<String, dynamic> json) => BrandChild(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$BrandChildToJson(BrandChild instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

PropertyModel _$PropertyModelFromJson(Map<String, dynamic> json) =>
    PropertyModel(
      type: json['type'] as String,
      name: json['name'] as String,
      link: json['link'] as String?,
      gpsCoordinates: GPSCoordinates.fromJson(
          json['gps_coordinates'] as Map<String, dynamic>),
      checkInTime: json['check_in_time'] as String?,
      checkOutTime: json['check_out_time'] as String?,
      ratePerNight: json['rate_per_night'] == null
          ? null
          : Rate.fromJson(json['rate_per_night'] as Map<String, dynamic>),
      totalRate: json['total_rate'] == null
          ? null
          : Rate.fromJson(json['total_rate'] as Map<String, dynamic>),
      prices: (json['prices'] as List<dynamic>?)
          ?.map((e) => Price.fromJson(e as Map<String, dynamic>))
          .toList(),
      nearbyPlaces: (json['nearby_places'] as List<dynamic>?)
          ?.map((e) => NearbyPlace.fromJson(e as Map<String, dynamic>))
          .toList(),
      images: (json['images'] as List<dynamic>)
          .map((e) => HotelImage.fromJson(e as Map<String, dynamic>))
          .toList(),
      overallRating: (json['overall_rating'] as num?)?.toDouble(),
      reviews: (json['reviews'] as num?)?.toInt(),
      locationRating: (json['location_rating'] as num).toDouble(),
      amenities: (json['amenities'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      excludedAmenities: (json['excluded_amenities'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      essentialInfo: (json['essential_info'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      propertyToken: json['property_token'] as String,
      serpapiPropertyDetailsLink:
          json['serpapi_property_details_link'] as String,
    );

Map<String, dynamic> _$PropertyModelToJson(PropertyModel instance) =>
    <String, dynamic>{
      'type': instance.type,
      'name': instance.name,
      'link': instance.link,
      'gps_coordinates': instance.gpsCoordinates,
      'check_in_time': instance.checkInTime,
      'check_out_time': instance.checkOutTime,
      'rate_per_night': instance.ratePerNight,
      'total_rate': instance.totalRate,
      'prices': instance.prices,
      'nearby_places': instance.nearbyPlaces,
      'images': instance.images,
      'overall_rating': instance.overallRating,
      'reviews': instance.reviews,
      'location_rating': instance.locationRating,
      'amenities': instance.amenities,
      'excluded_amenities': instance.excludedAmenities,
      'essential_info': instance.essentialInfo,
      'property_token': instance.propertyToken,
      'serpapi_property_details_link': instance.serpapiPropertyDetailsLink,
    };

GPSCoordinates _$GPSCoordinatesFromJson(Map<String, dynamic> json) =>
    GPSCoordinates(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$GPSCoordinatesToJson(GPSCoordinates instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

Rate _$RateFromJson(Map<String, dynamic> json) => Rate(
      lowest: json['lowest'] as String,
      extractedLowest: (json['extracted_lowest'] as num).toInt(),
      beforeTaxesFees: json['before_taxes_fees'] as String?,
      extractedBeforeTaxesFees:
          (json['extracted_before_taxes_fees'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RateToJson(Rate instance) => <String, dynamic>{
      'lowest': instance.lowest,
      'extracted_lowest': instance.extractedLowest,
      'before_taxes_fees': instance.beforeTaxesFees,
      'extracted_before_taxes_fees': instance.extractedBeforeTaxesFees,
    };

Price _$PriceFromJson(Map<String, dynamic> json) => Price(
      source: json['source'] as String,
      logo: json['logo'] as String,
      numGuests: (json['num_guests'] as num).toInt(),
      ratePerNight:
          Rate.fromJson(json['rate_per_night'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PriceToJson(Price instance) => <String, dynamic>{
      'source': instance.source,
      'logo': instance.logo,
      'num_guests': instance.numGuests,
      'rate_per_night': instance.ratePerNight,
    };

NearbyPlace _$NearbyPlaceFromJson(Map<String, dynamic> json) => NearbyPlace(
      name: json['name'] as String,
      transportations: (json['transportations'] as List<dynamic>?)
          ?.map((e) => Transportation.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$NearbyPlaceToJson(NearbyPlace instance) =>
    <String, dynamic>{
      'name': instance.name,
      'transportations': instance.transportations,
    };

Transportation _$TransportationFromJson(Map<String, dynamic> json) =>
    Transportation(
      type: json['type'] as String,
      duration: json['duration'] as String,
    );

Map<String, dynamic> _$TransportationToJson(Transportation instance) =>
    <String, dynamic>{
      'type': instance.type,
      'duration': instance.duration,
    };

HotelImage _$HotelImageFromJson(Map<String, dynamic> json) => HotelImage(
      thumbnail: json['thumbnail'] as String?,
      originalImage: json['original_image'] as String,
    );

Map<String, dynamic> _$HotelImageToJson(HotelImage instance) =>
    <String, dynamic>{
      'thumbnail': instance.thumbnail,
      'original_image': instance.originalImage,
    };

SerpApiPagination _$SerpApiPaginationFromJson(Map<String, dynamic> json) =>
    SerpApiPagination(
      currentFrom: (json['current_from'] as num).toInt(),
      currentTo: (json['current_to'] as num).toInt(),
      nextPageToken: json['next_page_token'] as String,
    );

Map<String, dynamic> _$SerpApiPaginationToJson(SerpApiPagination instance) =>
    <String, dynamic>{
      'current_from': instance.currentFrom,
      'current_to': instance.currentTo,
      'next_page_token': instance.nextPageToken,
    };
