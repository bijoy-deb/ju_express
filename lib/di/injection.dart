import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:ju_express/di/injection.config.dart';


final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init', // default
  preferRelativeImports: true, // default
  asExtension: true, // default
)
Future<void> configureInjection() async => getIt.init();

/*
final GetIt getIt = GetIt.instance;
@injectableInit
Future<void> configureInjection() async => getIt.init();*/
