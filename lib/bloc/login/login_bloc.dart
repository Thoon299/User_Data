import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:user_data_system/data/network/api/constants/endpoints.dart';
import '../../../data/sharedpreference/shared_preference_helper.dart';
import '../../../di/components/service_locator.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(LoginState initialState) : super(LoginInitialized());
  var sharedPreference=getIt<SharedPreferenceHelper>();


  @override
  Stream<LoginState> mapEventToState(
      LoginEvent event,
      ) async* {
    if(event is LoginPressedButton){
      yield LoginLoading();
      try{
        final dio = Dio();

        var jsonVar = {
          "username": event.username,
          "password": event.password,
        };

        dio
          ..options.baseUrl = Endpoints.baseUrl
          ..options.responseType = ResponseType.json
          ..options.followRedirects = false
          ..options.headers = {'Content-Type': 'application/json'}

          ..options.headers['Accept'] = 'application/json';
        dio.interceptors.add(PrettyDioLogger());
        final LoginResponse = await dio.post('login',data: jsonEncode(jsonVar));
        print('statusCode'+LoginResponse.statusCode.toString());

        if(LoginResponse.statusCode!=200){
          yield LoginError(errorMessage: 'Invalid Username and Password');
        }

        else{
          try{
            yield LoginSuccess(token: LoginResponse.data['token'] );
          }
          catch(e){
            // print(memberLoginResponse.data['message']);
            yield LoginError(errorMessage: 'Invalid Username and Password');
          }
        }
      }
      on DioError catch(e){
        print("ERRORR is ${e.toString()}");
        int? code = e.response!.statusCode;

        yield LoginError(errorMessage:"Sorry, Please Login Again.");
      }
    }
  }
}

