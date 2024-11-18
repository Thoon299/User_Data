import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:localstorage/localstorage.dart';
import '../../../data/sharedpreference/shared_preference_helper.dart';
import '../../../di/components/service_locator.dart';
import 'package:http/http.dart' as http;

import '../bloc/users/user_edit/user_edit_bloc.dart';
import '../bloc/users/user_edit/user_edit_event.dart';
import '../bloc/users/user_edit/user_edit_state.dart';
import '../data/repository/user_repository.dart';



class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  InternetConnectionStatus? _connectionStatus;
  late StreamSubscription<InternetConnectionStatus> _subscription;
  String lat= "";String long = "";
  final LocalStorage storage = new LocalStorage('localstorage_app');

  UserEditBloc _userEditBloc = UserEditBloc(getIt<UsersRepository>());

  @override
  void initState() {
    var sharedPreference = getIt<SharedPreferenceHelper>();
    print("share");print( sharedPreference.getlat.toString());
     _subscription = InternetConnectionCheckerPlus().onStatusChange.listen(
          (status) {
        setState(() {
          _connectionStatus = status;
        });
      },
    );

    _userEditBloc.add(UserEditStart());
    _userEditBloc.add(DataPostStart());


    super.initState();
  }
   getLocation() async {
     LocationPermission permission;
     permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
    print(position.latitude);
    print(position.longitude);
    setState(() {
      lat = position.latitude.toString();
      long = position.longitude.toString();
    });


  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          print("After clicking the Signup Back Button");
          SystemNavigator.pop();

          return false;
        }, child: Scaffold(

        appBar: AppBar(
          automaticallyImplyLeading: false,
          brightness: Brightness.dark,
          backgroundColor: Colors.teal,
          title: Text("User Home"),

        ),
        body: blocData()
    )
    );
  }


  blocData(){
    return BlocBuilder<UserEditBloc,UserEditState>(
      bloc: _userEditBloc,
      builder: (context,state) {
        if (state is DataPostLoading) {
          WidgetsBinding.instance?.addPostFrameCallback((_) {
            showDialog(
                barrierColor: Color(0x00ffffff),
                context: context,
                builder: (BuildContext context){
                  return
                    Material(
                      type: MaterialType.transparency,
                      child: Center(
                          child: SpinKitThreeBounce(color: Color(0xff334A52),)
                      ),
                    );
                }
            );
          });
        }else if (state is DataPostError) {
          _userEditBloc.add(DataPostStart());
          WidgetsBinding.instance?.addPostFrameCallback((_){
            Navigator.pop(context);
            showDialog(
                context: context,
                builder: (BuildContext context){
                  return AlertDialog(
                    content:
                    Text(
                        state.errorMessage,style: TextStyle(fontSize: 18,fontFamily: 'Poppins')
                    ),
                  );
                }
            );
          });
        } else if (state is DataPostLoaded) {
          _userEditBloc.add(DataPostStart());

          WidgetsBinding.instance?.addPostFrameCallback((_){
            print('loaded');
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(state.msg.toString(),
                              style: TextStyle(
                                  fontSize: 18, fontFamily: 'Rasa')),
                          Padding(padding: EdgeInsets.only(top: 30)),
                          GestureDetector(
                            onTap: () {

                              Navigator.pop(context);
                              Navigator.pop(context);

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
                }
            );
          });
        }
        return Form(
          key: _key,
          child: formContainer(),
        );
      },

    );
  }
  formContainer(){
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          (lat != "")?Text(
            "Your Location is: "+ lat +"(latitude) and "+ long+ " (longitude).",
            style: TextStyle(fontSize: 20, color: Colors.grey[700]),
          )
              :
          Text(""),
          Padding(padding: EdgeInsets.only(top: 20)),
          Center(
            child: GestureDetector(
                onTap: () async {
                  print('click');

                  await getLocation();

                  print('status '+_connectionStatus.toString());
                  String con = _connectionStatus.toString();
                  if( con == "InternetConnectionStatus.disconnected" ){
                    showDig();
                  }

                  else {
                    _userEditBloc.add(
                        DataPost(userId: "33", latitude: lat, longitude: long));
                  }
                },

                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                      color: Colors.teal,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(
                        Radius.circular(30.0),
                      )),
                  child: Center(
                    child: Text(
                      'Click and Save',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize:
                        20,

                      ),
                    ),
                  ),
                )
            ),
          )
        ],
      ),
    );
  }

  showDig() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("You are now Offline.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontFamily: 'Rasa')),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Save in Local Storage.",
                      style: TextStyle(fontSize: 16, fontFamily: 'Rasa')),
                  Padding(padding: EdgeInsets.only(top: 30)),
                  GestureDetector(
                    onTap: () {
                      var sharedPreference = getIt<SharedPreferenceHelper>();
                      sharedPreference.setuserId("userId "+"33");
                      sharedPreference.setlat("lat"+lat);
                      sharedPreference.setlong("long"+long);
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      height: 40,
                      decoration: BoxDecoration(
                          color: Color(0xff334A52),
                          borderRadius: BorderRadius.circular(5.0)),
                      child: Center(
                        child: Text(
                          "OK",
                          style: TextStyle(
                              fontSize: 18,
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

}
