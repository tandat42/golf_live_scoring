import 'package:get_it/get_it.dart';
import 'package:golf_live_scoring/core/di.config.dart';
import 'package:injectable/injectable.dart';

final getIt = GetIt.instance;

@InjectableInit(
  preferRelativeImports: false,
)
void initGetIt() => getIt.init();
