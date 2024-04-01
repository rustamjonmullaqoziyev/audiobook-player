import 'package:freezed_annotation/freezed_annotation.dart';

part 'audios_response.freezed.dart';

part 'audios_response.g.dart';

@freezed
class AudiosResponse with _$AudiosResponse {
  const factory AudiosResponse({
    String? status,
    int? totalResults,
    required List<AudioResponse> audios,
  }) = _AudiosResponse;

  factory AudiosResponse.fromJson(Map<String, dynamic> json) =>
      _$AudiosResponseFromJson(json);
}

@freezed
class AudioResponse with _$AudioResponse {
  const factory AudioResponse({
    required int id,
    required String name,
    required String url,
    required String description,
  }) = _AudioResponse;

  factory AudioResponse.fromJson(Map<String, dynamic> json) =>
      _$AudioResponseFromJson(json);
}
