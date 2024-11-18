import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:user_data_system/ui/auth/Login.dart';

import '../../bloc/signup/signup_bloc.dart';
import '../../bloc/signup/signup_event.dart';
import '../../bloc/signup/signup_state.dart';
import '../../data/sharedpreference/shared_preference_helper.dart';
import '../../di/components/service_locator.dart';

class SignupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          // Do something here
          print("After clicking the singup Back Button");
          SystemNavigator.pop();

          return false;
        },
        child: Scaffold(
          body: Signup(),
        ));
  }
}

class Signup extends StatefulWidget {

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String _groupValue = "USER";
  SignupBloc _SignupBloc = SignupBloc(SignupInitialized());

  @override
  void initState() {
    _SignupBloc.add(SignupStart());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          print("After clicking the Signup Back Button");
          SystemNavigator.pop();


      return false;
    },child: Scaffold(
        body: BlocProvider<SignupBloc>(
            create: (_) {
              return SignupBloc(SignupInitialized());
            },
            child: BlocListener<SignupBloc, SignupState>(
              bloc: _SignupBloc,
              listener: (context, state) {
                if (state is SignupLoading) {
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
                } else if (state is SignupError) {
                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      duration: Duration(seconds: 2),
                      content: Text(state.errorMessage)));

                } else if (state is SignupSuccess) {
                  Navigator.pop(context);
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            title: Text('User registered successfully',
                                style: TextStyle(
                                    fontSize: 20, fontFamily: 'Rasa')),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Go to Login Page And Again Login.',
                                    style: TextStyle(
                                        fontSize: 18, fontFamily: 'Rasa')),
                                Padding(padding: EdgeInsets.only(top: 30)),
                                GestureDetector(
                                  onTap: () {
                                    var sharedPreference = getIt<SharedPreferenceHelper>();
                                    sharedPreference.setRole(state.userModel.user!.role.toString());
                                    print('role '+state.userModel.user!.role.toString());
                                    Navigator.pop(context);
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (BuildContext context) =>
                                            Login()
                                        ));
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
                child: data()
              ),
            )), ),
    );
  }


  data(){
    return Container(
      color: Colors.teal[200],
      padding: EdgeInsets.only(top: 30,left: 20,right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment:  MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          header(),

          Column(
            children: <Widget>[
              TextField(
                controller: userNameController,
                decoration: InputDecoration(
                    hintText: "Username",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none),
                    fillColor: Colors.purple.withOpacity(0.1),
                    filled: true,
                    prefixIcon: const Icon(Icons.person)),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  hintText: "Password",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none),
                  fillColor: Colors.purple.withOpacity(0.1),
                  filled: true,
                  prefixIcon: const Icon(Icons.password),
                ),
                obscureText: true,
              ),


            ],
          ),
          Container(
            padding: EdgeInsets.only(left: 20),
            child:  Text(
              "Please Select Your Role!",
              style: TextStyle(fontSize: 15, color: Colors.grey[700]),
            ),
          ),

          CustomRadioButton(
            width: 100,
            defaultSelected: "USER",
            buttonLables: [
              "USER",
              "ADMIN",
            ],
            buttonValues: [
              "USER",
              "ADMIN",
            ],
            radioButtonValue: (value) {
              setState(() {
                _groupValue = value;
              });
            },
            selectedColor: Colors.blue, unSelectedColor: Colors.white,
          ),

          ElevatedButton(
            onPressed: () {
              print(_groupValue.toString());
              print(userNameController.text+"  "+passwordController.text);
              _SignupBloc.add(SignupPressedButton(
                username: userNameController.text, password: passwordController.text,
                role: _groupValue.toString()

              ));
            },
            style: ElevatedButton.styleFrom(
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.teal,
            ),
            child: const Text(
              "Sign Up",
              style: TextStyle(fontSize: 20),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text("Already have an account?"),
                TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) =>
                              Login()
                          ));
                    },
                    child: const Text("Login", style: TextStyle(color: Colors.purple),)
                )
              ],
            ),
          )
        ],
      ),
    );
  }


  header(){
    return   Column(
        children: <Widget>[
          const SizedBox(height: 60.0),

          const Text(
            "Sign up",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "Create your account",
            style: TextStyle(fontSize: 15, color: Colors.grey[700]),
          )
        ],

    );
  }
}