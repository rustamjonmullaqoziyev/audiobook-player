import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

import '../../constants/rest_end_poind.dart';

@LazySingleton()
class AudiobooksService {
  AudiobooksService(this._dio);

  final Dio _dio;

  Future<Response> getAudiobooks() async {
    final response = await _dio.get(RestEndPoint.audiobooks);
    return response;
  }

  Future<Response> getAudios({required int id}) async {
    final queryParameters = {"id": id};
    final response = await _dio.get(RestEndPoint.audiobook,
        options: Options(headers: queryParameters));
    return response;
  }

  Future<String> downloadFile({required String url, required String filename}) async {
    var dir = await getApplicationDocumentsDirectory();

    await _dio.download(
      url,
      "${dir.path}/$filename",
      onReceiveProgress: (received, total) {
        if (total != -1) {
          print("${(received / total * 100).toStringAsFixed(0)}%");
        }
      },
    );
    return "${dir.path}/$filename";
  }
}
