import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:user_data_system/bloc/signup/signup_event.dart';
import 'package:user_data_system/bloc/signup/signup_state.dart';
import 'package:user_data_system/data/network/api/constants/endpoints.dart';
import 'package:user_data_system/ui/auth/signup.dart';
import '../../../data/sharedpreference/shared_preference_helper.dart';
import '../../../di/components/service_locator.dart';
import '../../models/UserModel.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc(SignupState initialState) : super(SignupInitialized());
  var sharedPreference=getIt<SharedPreferenceHelper>();


  @override
  Stream<SignupState> mapEventToState(
      SignupEvent event,
      ) async* {
    if(event is SignupPressedButton){
      yield SignupLoading();
      try{
        final dio = Dio();

        var jsonVar = {
          "username": event.username,
          "password": event.password,
          "role" : event.role,
        };

        dio
          ..options.baseUrl = Endpoints.baseUrl
          ..options.responseType = ResponseType.json
          ..options.followRedirects = false
          ..options.headers = {'Content-Type': 'application/json'}

          ..options.headers['Accept'] = 'application/json';
        dio.interceptors.add(PrettyDioLogger());
        final SignupResponse = await dio.post('api/user/register',data: jsonEncode(jsonVar));
        print('statusCode'+SignupResponse.statusCode.toString());

        if(SignupResponse.statusCode!=201){
          yield SignupError(errorMessage: 'Invalid');
        }

        else{
          try{

            yield SignupSuccess(message: SignupResponse.data['message'],
                userModel: UserModel.fromJson(SignupResponse.data) );
          }
          catch(e){
            // print(memberLoginResponse.data['message']);
            yield SignupError(errorMessage: 'Fail Registration');
          }
        }
      }
      on DioError catch(e){
        print("ERRORR is ${e.toString()}");
        int? code = e.response!.statusCode;

        yield SignupError(errorMessage:"Sorry, Please Register Again.");
      }
    }
  }
}

