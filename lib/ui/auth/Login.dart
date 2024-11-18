import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:user_data_system/ui/auth/signup.dart';
import 'package:user_data_system/ui/users/user_list-page.dart';

import '../../bloc/login/login_bloc.dart';
import '../../bloc/login/login_event.dart';
import '../../bloc/login/login_state.dart';
import '../../data/sharedpreference/shared_preference_helper.dart';
import '../../di/components/service_locator.dart';
import '../home.dart';


class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          // Do something here
          print("After clicking the Android Back Button");
          SystemNavigator.pop();

          return false;
        },
        child: Scaffold(
          body: InputArea(),
        ));
  }
}

class InputArea extends StatefulWidget {
  @override
  _InputAreaState createState() => _InputAreaState();
}

class _InputAreaState extends State<InputArea> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  LoginBloc _LoginBloc = LoginBloc(LoginInitialized());

  @override
  void initState() {
    _LoginBloc.add(LoginStart());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          print("After clicking the Login Back Button");
          SystemNavigator.pop();


          return false;
    },
    child:Scaffold(
        body: BlocProvider<LoginBloc>(
            create: (_) {
              return LoginBloc(LoginInitialized());
            },
            child: BlocListener<LoginBloc, LoginState>(
              bloc: _LoginBloc,
              listener: (context, state) {
                if (state is LoginLoading) {
                  showDialog(
                      barrierDismissible: false,
                      barrierColor: Color(0x00ffffff),
                      context: context,
                      builder: (BuildContext context) {
                        return Material(
                          type: MaterialType.transparency,
                          child: Center(
                              child: SpinKitFadingFour(
                                color: Color(0xff334A52),
                              )),
                        );
                      });
                } else if (state is LoginError) {
                  Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        duration: Duration(seconds: 2),
                        content: Text(state.errorMessage)));

                } else if (state is LoginSuccess) {
                  Navigator.pop(context);
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            title: Text('Login Success',
                                style: TextStyle(
                                    fontSize: 20, fontFamily: 'Rasa')),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Now You can go to home.',
                                    style: TextStyle(
                                        fontSize: 18, fontFamily: 'Rasa')),
                                Padding(padding: EdgeInsets.only(top: 30)),
                                GestureDetector(
                                  onTap: () {
                                    print("verify tokne");
                                    print(state.token);
                                    var sharedPreference = getIt<SharedPreferenceHelper>();
                                    sharedPreference.setLoginToken("Bearer "+state.token);
                                    Navigator.pop(context);

                                    var role = sharedPreference.getRole.toString();
                                    print('login role'+role);
                                    if(role == "ADMIN")
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  UserListPage(

                                                  )));
                                    else
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  Home(

                                                  )));
                                    // Navigator.pop(context);
                                  },
                                  child: Container(
                                    margin:
                                    EdgeInsets.only(left: 20, right: 20),
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: Color(0xff334A52),
                                        borderRadius:
                                        BorderRadius.circular(5.0)),
                                    child: Center(
                                      child: Text(
                                        'OK',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontFamily: 'Rasa',
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(padding: EdgeInsets.only(top: 20)),
                              ],
                            ));
                      });
                }
              },
              child: Form(
                  key: _key,
                  child: Container(
                    color: Colors.teal[200],
                    padding: EdgeInsets.only(top: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _header(context),
                        _inputField(context),
                        _signup(context),
                      ],
                    ),
                  ),),
            ))
    ));
  }

  _header(context) {
    return  Column(
      children: [
        Text(
          "Welcome",
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),

      ],
    );
  }

  _inputField(context) {
    return Container(
      margin: EdgeInsets.only(left: 20,right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: userNameController,
            decoration: InputDecoration(
                hintText: "Username",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none
                ),
                fillColor: Colors.teal.withOpacity(0.1),
                filled: true,
                prefixIcon: const Icon(Icons.person)),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(
              hintText: "Password",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none),
              fillColor: Colors.teal.withOpacity(0.1),
              filled: true,
              prefixIcon: const Icon(Icons.password),
            ),
            obscureText: true,
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () async {
              var jsonVar = {
                "username": userNameController.text,
                "password": passwordController.text,
              };
              print("login "+ jsonEncode(jsonVar));

              _LoginBloc.add(LoginPressedButton(
                username: userNameController.text, password: passwordController.text,

              ));
            },

            child:Container(
              height: 60,
              decoration: BoxDecoration(
                  color: Colors.teal,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(
                    Radius.circular(30.0),
                  )),
              child: Center(
                child: Text(
                'Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize:
                    20,

                  ),
                ),
              ),
            )
          )
        ],
      ),
    );
  }


  _signup(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Dont have an account? "),
        TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) =>
                      SignupPage()
                  ));
            },
            child: const Text("Sign Up", style: TextStyle(color: Colors.purple),)
        )
      ],
    );
  }
}