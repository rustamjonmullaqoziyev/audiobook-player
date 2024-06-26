import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:audiobook/core/di/injection.config.dart';

final getIt = GetIt.instance;

@injectableInit
Future<GetIt> configureDependencies() async => getIt.init();
