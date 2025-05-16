import 'package:get_it/get_it.dart';
import 'package:kliks/core/services/api_service.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => ApiService());
}