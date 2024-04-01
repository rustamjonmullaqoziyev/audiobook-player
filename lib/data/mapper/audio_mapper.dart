import 'package:audiobook/data/responses/audio/audios_response.dart';

import '../../domain/modules/audio/audio.dart';

extension AudioExtension on AudioResponse {
  Audio toAudio({required int position}) {
    return Audio(
        id: id,
        name: name,
        url: url,
        description: description,
        position: position);
  }
}
