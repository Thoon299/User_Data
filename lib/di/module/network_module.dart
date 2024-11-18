import 'package:dio/dio.dart';

import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../data/network/api/constants/endpoints.dart';
import '../../data/network/app_interceptors.dart';
import '../../data/sharedpreference/shared_preference_helper.dart';
import '../components/service_locator.dart';

abstract class NetworkModule {
  /// A singleton dio provider.
  ///
  /// Calling it multiple times will return the same instance.

  static Dio provideDio(SharedPreferenceHelper sharedPreferenceHelper) {
    final dio = Dio();
    var sharedPreference=getIt<SharedPreferenceHelper>();

    dio
      ..options.baseUrl = Endpoints.baseUrl
      ..options.connectTimeout = Endpoints.connectionTimeout
      ..options.receiveTimeout = Endpoints.receiveTimeout
      ..options.responseType = ResponseType.json
      ..options.followRedirects = false
      ..options.headers = {'Content-Type': 'application/json'}
      ..options.headers = {'X-API-Key': '{{ x-api-key }}'}
    // ..options.headers = {'Locale': 'en'}
      ..interceptors.add(AppInterceptors(dio: dio, sharedPreferenceHelper: sharedPreferenceHelper));
    dio.options.headers['Accept'] = 'application/json';

    dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
    ));

    return dio;
  }
}
