import 'package:flutter/material.dart';
import 'package:user_data_system/routes/routes.dart';
import 'package:user_data_system/ui/splash_screen.dart';

import 'data/sharedpreference/shared_preference_helper.dart';
import 'di/components/service_locator.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();


  var sharedPreference=getIt<SharedPreferenceHelper>();


  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  MyApp();
  @override
  _MyAppState createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  // late AuthenticationBloc myAuthenticationBloc =getIt<AuthenticationBloc>();
  static final navigatorKey = new GlobalKey<NavigatorState>();
  String? initialRoute;
  _MyAppState({this.initialRoute});


  @override
  void initState() {
    // TODO: implement initState
    super.initState();


}

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey:navigatorKey ,
      theme: new ThemeData(scaffoldBackgroundColor: const Color(0xFFEFEFFF)),
      routes: Routes.routes,
      initialRoute: Splash.route,
      title: 'Flutter Demo',

    );
  }
}
