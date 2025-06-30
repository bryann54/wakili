import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'search_response.g.dart';

@JsonSerializable(explicitToJson: true)
class SearchResponse {
  @JsonKey(name: 'search_metadata')
  final SearchMetadata? searchMetadata;
  @JsonKey(name: 'search_parameters')
  final SearchParameters? searchParameters;
  @JsonKey(name: 'search_information')
  final SearchInformation? searchInformation;
  final List<Brand>? brands;
  final List<PropertyModel> properties;
  @JsonKey(name: 'serpapi_pagination')
  final SerpApiPagination pagination;

  SearchResponse({
    this.searchMetadata,
    this.searchParameters,
    this.searchInformation,
    this.brands,
    required this.properties,
    required this.pagination,
  });

  factory SearchResponse.fromJson(Map<String, dynamic> json) =>
      _$SearchResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SearchResponseToJson(this);
}

@JsonSerializable()
class SearchMetadata {
  final String id;
  final String status;
  @JsonKey(name: 'json_endpoint')
  final String jsonEndpoint;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'processed_at')
  final String processedAt;
  @JsonKey(name: 'google_hotels_url')
  final String googleHotelsUrl;
  @JsonKey(name: 'raw_html_file')
  final String rawHtmlFile;
  @JsonKey(name: 'prettify_html_file')
  final String prettifyHtmlFile;
  @JsonKey(name: 'total_time_taken')
  final double totalTimeTaken;

  SearchMetadata({
    required this.id,
    required this.status,
    required this.jsonEndpoint,
    required this.createdAt,
    required this.processedAt,
    required this.googleHotelsUrl,
    required this.rawHtmlFile,
    required this.prettifyHtmlFile,
    required this.totalTimeTaken,
  });

  factory SearchMetadata.fromJson(Map<String, dynamic> json) =>
      _$SearchMetadataFromJson(json);

  Map<String, dynamic> toJson() => _$SearchMetadataToJson(this);
}

@JsonSerializable()
class SearchParameters {
  final String engine;
  final String q;
  final String gl;
  final String hl;
  final String currency;
  @JsonKey(name: 'check_in_date')
  final String checkInDate;
  @JsonKey(name: 'check_out_date')
  final String checkOutDate;
  final int adults;
  final int children;

  SearchParameters({
    required this.engine,
    required this.q,
    required this.gl,
    required this.hl,
    required this.currency,
    required this.checkInDate,
    required this.checkOutDate,
    required this.adults,
    required this.children,
  });

  factory SearchParameters.fromJson(Map<String, dynamic> json) =>
      _$SearchParametersFromJson(json);

  Map<String, dynamic> toJson() => _$SearchParametersToJson(this);
}

@JsonSerializable()
class SearchInformation {
  @JsonKey(name: 'total_results')
  final int totalResults;

  SearchInformation({required this.totalResults});

  factory SearchInformation.fromJson(Map<String, dynamic> json) =>
      _$SearchInformationFromJson(json);

  Map<String, dynamic> toJson() => _$SearchInformationToJson(this);
}

@JsonSerializable()
class Brand {
  final int id;
  final String name;
  final List<BrandChild>? children;

  Brand({
    required this.id,
    required this.name,
    required this.children,
  });

  factory Brand.fromJson(Map<String, dynamic> json) => _$BrandFromJson(json);

  Map<String, dynamic> toJson() => _$BrandToJson(this);
}

@JsonSerializable()
class BrandChild {
  final int id;
  final String name;

  BrandChild({
    required this.id,
    required this.name,
  });

  factory BrandChild.fromJson(Map<String, dynamic> json) =>
      _$BrandChildFromJson(json);

  Map<String, dynamic> toJson() => _$BrandChildToJson(this);
}

@JsonSerializable()
class PropertyModel extends Equatable {
  final String type;
  final String name;
  final String? link;
  @JsonKey(name: 'gps_coordinates')
  final GPSCoordinates gpsCoordinates;
  @JsonKey(name: 'check_in_time')
  final String? checkInTime;
  @JsonKey(name: 'check_out_time')
  final String? checkOutTime;
  @JsonKey(name: 'rate_per_night')
  final Rate? ratePerNight;
  @JsonKey(name: 'total_rate')
  final Rate? totalRate;
  final List<Price>? prices;
  @JsonKey(name: 'nearby_places')
  final List<NearbyPlace>? nearbyPlaces;
  final List<HotelImage> images;
  @JsonKey(name: 'overall_rating')
  final double? overallRating;
  final int? reviews;
  @JsonKey(name: 'location_rating')
  final double locationRating;
  final List<String>? amenities;
  @JsonKey(name: 'excluded_amenities')
  final List<String>? excludedAmenities;
  @JsonKey(name: 'essential_info')
  final List<String>? essentialInfo;
  @JsonKey(name: 'property_token')
  final String propertyToken;
  @JsonKey(name: 'serpapi_property_details_link')
  final String serpapiPropertyDetailsLink;

  const PropertyModel({
    required this.type,
    required this.name,
    required this.link,
    required this.gpsCoordinates,
    required this.checkInTime,
    required this.checkOutTime,
    required this.ratePerNight,
    required this.totalRate,
    required this.prices,
    required this.nearbyPlaces,
    required this.images,
    required this.overallRating,
    required this.reviews,
    required this.locationRating,
    required this.amenities,
    required this.excludedAmenities,
    required this.essentialInfo,
    required this.propertyToken,
    required this.serpapiPropertyDetailsLink,
  });

  factory PropertyModel.fromJson(Map<String, dynamic> json) =>
      _$PropertyModelFromJson(json);
  Map<String, dynamic> toJson() => _$PropertyModelToJson(this);

  @override
  List<Object?> get props => [name, serpapiPropertyDetailsLink];
}

@JsonSerializable()
class GPSCoordinates {
  final double latitude;
  final double longitude;

  GPSCoordinates({required this.latitude, required this.longitude});

  factory GPSCoordinates.fromJson(Map<String, dynamic> json) =>
      _$GPSCoordinatesFromJson(json);
  Map<String, dynamic> toJson() => _$GPSCoordinatesToJson(this);
}

@JsonSerializable()
class Rate {
  final String lowest;
  @JsonKey(name: 'extracted_lowest')
  final int extractedLowest;
  @JsonKey(name: 'before_taxes_fees')
  final String? beforeTaxesFees;
  @JsonKey(name: 'extracted_before_taxes_fees')
  final int? extractedBeforeTaxesFees;

  Rate({
    required this.lowest,
    required this.extractedLowest,
    required this.beforeTaxesFees,
    required this.extractedBeforeTaxesFees,
  });

  factory Rate.fromJson(Map<String, dynamic> json) => _$RateFromJson(json);
  Map<String, dynamic> toJson() => _$RateToJson(this);
}

@JsonSerializable()
class Price {
  final String source;
  final String logo;
  @JsonKey(name: 'num_guests')
  final int numGuests;
  @JsonKey(name: 'rate_per_night')
  final Rate ratePerNight;

  Price({
    required this.source,
    required this.logo,
    required this.numGuests,
    required this.ratePerNight,
  });

  factory Price.fromJson(Map<String, dynamic> json) => _$PriceFromJson(json);
  Map<String, dynamic> toJson() => _$PriceToJson(this);
}

@JsonSerializable()
class NearbyPlace {
  final String name;
  final List<Transportation>? transportations;

  NearbyPlace({required this.name, required this.transportations});

  factory NearbyPlace.fromJson(Map<String, dynamic> json) =>
      _$NearbyPlaceFromJson(json);
  Map<String, dynamic> toJson() => _$NearbyPlaceToJson(this);
}

@JsonSerializable()
class Transportation {
  final String type;
  final String duration;

  Transportation({required this.type, required this.duration});

  factory Transportation.fromJson(Map<String, dynamic> json) =>
      _$TransportationFromJson(json);
  Map<String, dynamic> toJson() => _$TransportationToJson(this);
}

@JsonSerializable()
class HotelImage {
  final String? thumbnail;
  @JsonKey(name: 'original_image')
  final String originalImage;

  HotelImage({required this.thumbnail, required this.originalImage});

  factory HotelImage.fromJson(Map<String, dynamic> json) =>
      _$HotelImageFromJson(json);
  Map<String, dynamic> toJson() => _$HotelImageToJson(this);
}

@JsonSerializable()
class SerpApiPagination {
  @JsonKey(name: 'current_from')
  int currentFrom;
  @JsonKey(name: 'current_to')
  int currentTo;
  @JsonKey(name: 'next_page_token')
  String nextPageToken;

  SerpApiPagination(
      {required this.currentFrom,
      required this.currentTo,
      required this.nextPageToken});

  factory SerpApiPagination.fromJson(Map<String, dynamic> json) =>
      _$SerpApiPaginationFromJson(json);

  Map<String, dynamic> toJson() => _$SerpApiPaginationToJson(this);
}
