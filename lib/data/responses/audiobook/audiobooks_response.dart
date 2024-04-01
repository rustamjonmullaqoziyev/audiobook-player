import 'package:freezed_annotation/freezed_annotation.dart';

part 'audiobooks_response.freezed.dart';

part 'audiobooks_response.g.dart';

@freezed
class AudiobooksResponse with _$AudiobooksResponse {
  const factory AudiobooksResponse({
    String? status,
    int? totalResults,
    required List<AudiobookResponse> audiobooks,
  }) = _AudiobooksResponse;

  factory AudiobooksResponse.fromJson(Map<String, dynamic> json) =>
      _$AudiobooksResponseFromJson(json);
}

@freezed
class AudiobookResponse with _$AudiobookResponse {
  const factory AudiobookResponse({
    required int id,
    required String name,
    required String author,
    required String url,
    required String image_url,
    required String description,
  }) = _AudiobookResponse;

  factory AudiobookResponse.fromJson(Map<String, dynamic> json) =>
      _$AudiobookResponseFromJson(json);
}
