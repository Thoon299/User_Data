

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/network/api/user_api.dart';
import '../../data/network/api/user_data_api.dart';
import '../../data/network/dio_client.dart';
import '../../data/repository/user_data_repository.dart';
import '../../data/repository/user_repository.dart';
import '../../data/sharedpreference/shared_preference_helper.dart';
import '../module/local_module.dart';
import '../module/network_module.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  // async singletons:----------------------------------------------------------
  getIt.registerSingletonAsync<SharedPreferences>(() => LocalModule.provideSharedPreferences());
  // singletons:----------------------------------------------------------------
  getIt.registerSingleton(SharedPreferenceHelper(await getIt.getAsync<SharedPreferences>()));
  getIt.registerSingleton<Dio>(NetworkModule.provideDio(getIt<SharedPreferenceHelper>()));
  getIt.registerSingleton(DioClient(getIt<Dio>()));

  // Users list's:---------------------------------------------------------------------
  getIt.registerSingleton(UsersApi(getIt<DioClient>()));
  getIt.registerSingleton(UsersRepository(getIt<UsersApi>()));

  // Users Data's:---------------------------------------------------------------------
  getIt.registerSingleton(UserDataApi(getIt<DioClient>()));
  getIt.registerSingleton(UserDataRepository(getIt<UserDataApi>()));

}