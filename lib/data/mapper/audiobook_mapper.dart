import 'package:audiobook/data/responses/audiobook/audiobooks_response.dart';

import '../../domain/modules/audiobooks/audiobooks.dart';

extension AudioBookExtension on AudiobookResponse {
  Audiobook toAudiobook({required int position}) {
    return Audiobook(
        id: id,
        author: author,
        description: description,
        url: url,
        name: name,
        imageUrl: image_url,
        position: position);
  }
}
