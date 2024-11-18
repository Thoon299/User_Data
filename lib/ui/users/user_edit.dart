
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:user_data_system/data/repository/user_repository.dart';
import 'package:user_data_system/ui/auth/Login.dart';
import 'package:user_data_system/ui/users/user_list-page.dart';

import '../../bloc/signup/signup_bloc.dart';
import '../../bloc/signup/signup_event.dart';
import '../../bloc/signup/signup_state.dart';
import '../../bloc/users/user_edit/user_edit_bloc.dart';
import '../../bloc/users/user_edit/user_edit_event.dart';
import '../../bloc/users/user_edit/user_edit_state.dart';
import '../../data/sharedpreference/shared_preference_helper.dart';
import '../../di/components/service_locator.dart';

class UserEdit extends StatefulWidget {
  String userId,username,role;
  UserEdit({required this.userId, required this.username, required this.role});

  @override
  _UserEditState createState() => _UserEditState();
}

class _UserEditState extends State<UserEdit> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String _groupValue = "";
  UserEditBloc _userEditBloc = UserEditBloc(getIt<UsersRepository>());

  @override
  void initState() {
    _userEditBloc.add(UserEditStart());

    userNameController.text = widget.username;
    _groupValue = widget.role;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print("After clicking the Signup Back Button");
        Navigator.pop(context);

        return false;
      },child: Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: Colors.teal,
        title: Text("Users Edit"),

      ),
      body: BlocProvider<SignupBloc>(
          create: (_) {
            return SignupBloc(SignupInitialized());
          },
          child: BlocListener<UserEditBloc, UserEditState>(
            bloc: _userEditBloc,
            listener: (context, state) {
              if (state is UserEditLoading) {
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
              } else if (state is UserEditError) {
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    duration: Duration(seconds: 2),
                    content: Text(state.errorMessage)));

              } else if (state is UserEditLoaded) {
                Navigator.pop(context);
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          content:
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                  state.msg.toString(),style: TextStyle(fontSize: 18,fontFamily: 'Poppins')
                              ),
                              Padding(padding: EdgeInsets.only(top: 30)),
                              GestureDetector(
                                onTap: (){

                                    Navigator.pop(context);

                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                UserListPage()));



                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: 20,right: 20),
                                  height: 40,
                                  decoration: BoxDecoration(
                                      color: Color(0xff334A52),
                                      borderRadius: BorderRadius.circular(5.0)
                                  ),
                                  child: Center(child: Text("OK",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'Poppins'
                                        ,color: Colors.white),),),
                                ),
                              ),
                              Padding(padding: EdgeInsets.only(top: 20)),
                            ],
                          )
                      );
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

        children: <Widget>[

          Column(
            children: <Widget>[
               const SizedBox(height: 30),
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
          const SizedBox(height: 30),
          Container(
            padding: EdgeInsets.only(left: 10),
            child:  Column(
              children: [
                Text(
                  "Please Select Your Role!",
                  style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
                CustomRadioButton(
                  width: 100,
                  defaultSelected: _groupValue,
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

              ],
            )
          ),


          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              print("edit");
              print(_groupValue.toString());
              print(userNameController.text+"  "+passwordController.text);
              _userEditBloc.add(UserEditPost(
                  username: userNameController.text, password: passwordController.text,
                  role: _groupValue.toString(), user_id: widget.userId

              ));
            },
            style: ElevatedButton.styleFrom(
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 50),
              backgroundColor: Colors.teal,
            ),
            child: const Text(
              "Update",
              style: TextStyle(fontSize: 16,color: Colors.black),
            ),
          ),


        ],
      ),
    );
  }



}