import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/di/injection.dart';
import 'audiobooks_view.dart';
import 'bloc/audiobooks_bloc.dart';

@RoutePage()
class AudiobooksPage extends StatelessWidget {
  const AudiobooksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (_) => getIt<AudiobooksBloc>(),
      child: BlocListener<AudiobooksBloc, AudiobooksState>(
        listenWhen: (_, state) => state is AudiobooksListenable,
        listener: (context, listenable) {},
        child: const AudiobooksView(),
      ),
    );
  }
}
