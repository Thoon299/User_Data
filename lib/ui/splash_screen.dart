import 'dart:async';

import 'package:flutter/material.dart';
import 'package:user_data_system/ui/users/user_list-page.dart';
import '../data/sharedpreference/shared_preference_helper.dart';
import '../di/components/service_locator.dart';
import 'auth/Login.dart';
import 'home.dart';

class Splash extends StatefulWidget {
  static const String route = '/splash_screen';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<Splash> {
  var sharedPreference=getIt<SharedPreferenceHelper>();


  void initState() {
    super.initState();

    String role = sharedPreference.getRole.toString();
    if( role != null ){
      Timer(Duration(seconds: 2),
              ()=>Navigator.pushReplacement(context,
              MaterialPageRoute(builder:
                  (context) =>
              //loginToken =="null" ?
              //Home()
               // UserListPage()
                 Login()
                  //: Home()
              )
          )
      );
    }


  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
         color: Colors.teal
        ),
        child: Center(
          child: Container(
           height: 700,
              width: MediaQuery.of(context).size.width,

            child:
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 180,
                      height: 170,
                      margin: EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          // image: Image.asset('assets/images/original_bg.png').image,
                          image: Image.asset('assets/images/ud.png').image,
                          fit: BoxFit.fill,
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                     Padding(padding: EdgeInsets.only(top: 10)),
                     Text('User Data System',style: TextStyle(
                        fontSize: 30,letterSpacing: 2,
                       color: Colors.white,
                    ),),

                  ],
                ),
              )


          ),
        ) /* add child content here */,
      ),
    );
  }
}


