
import 'package:flutter/widgets.dart';

import '../ui/auth/Login.dart';
import '../ui/home.dart';
import '../ui/splash_screen.dart';

class Routes {
  Routes._();


  static const String splash = '/splash_screen';
  static const String home = '/home';
  static const String login = '/login';



  static final routes = <String, WidgetBuilder> {
   // blog_posts: (BuildContext context) => BlogPosts(),
    home: (BuildContext context) => Home(),
    login: (BuildContext context) => Login(),
    splash: (BuildContext context) => Splash(),

  };


}
