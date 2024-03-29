import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../constants/rest_end_poind.dart';

@LazySingleton()
class AudiobooksService {
  AudiobooksService(this._dio);

  final Dio _dio;

  Future<Response> getAudiobooks() async {
    final response = await _dio.get(RestEndPoint.audiobooks);
    return response;
  }
}
