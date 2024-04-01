import 'package:audiobook/core/extensions/text_extensions.dart';
import 'package:audiobook/domain/modules/audiobooks/audiobooks.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AudiobookWidget extends StatelessWidget {
  const AudiobookWidget({
    super.key,
    required this.audiobook,
    required this.callback,
  });

  final Audiobook audiobook;
  final Function(Audiobook audiobook) callback;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => callback(audiobook),
        child: Container(
          margin: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12), color: Colors.white),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 80,
                height: 100,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(8)),
                child: CachedNetworkImage(
                  fit: BoxFit.fill,
                  imageBuilder: (context, url) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: url,
                        fit: BoxFit.fill,
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.colorBurn,
                        ),
                      ),
                    ),
                  ),
                  imageUrl: audiobook.imageUrl,
                  placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(
                    color: Colors.blue,
                  )),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                  child: SizedBox(
                height: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    audiobook.name
                        .w(500)
                        .s(20)
                        .c(Colors.black)
                        .copyWith(maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Expanded(
                      child: audiobook.description
                          .w(400)
                          .s(15)
                          .c(Colors.black)
                          .copyWith(
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                    ),
                    const SizedBox(height: 4),
                    audiobook.author.w(400).s(16).c(Colors.grey)
                  ],
                ),
              )),
            ],
          ),
        ));
  }
}
