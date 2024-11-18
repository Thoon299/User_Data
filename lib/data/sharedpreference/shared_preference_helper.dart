import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_data_system/data/sharedpreference/preferences.dart';

class SharedPreferenceHelper {
  // shared pref instance
  // final AuthApi _authApi;
  final SharedPreferences _sharedPreference;

  // constructor
  SharedPreferenceHelper(this._sharedPreference);

  // Set Login token:---------------------------------------------------
  String? get getLoginToken {
    return _sharedPreference.getString(Preferences.loginToken);
  }

  Future<void> setLoginToken(String loginToken) {
    return _sharedPreference.setString(Preferences.loginToken, loginToken);
  }
  Future<bool> removeLoginToken() {
    return _sharedPreference.remove(Preferences.loginToken);
  }

  // Set ROLE:---------------------------------------------------
  String? get getRole {
    return _sharedPreference.getString(Preferences.role);
  }

  Future<void> setRole(String role) {
    return _sharedPreference.setString(Preferences.role, role);
  }
  Future<bool> removeRole() {
    return _sharedPreference.remove(Preferences.role);
  }

  // Set ROLE:---------------------------------------------------
  String? get getuserId {
    return _sharedPreference.getString(Preferences.userId);
  }

  Future<void> setuserId(String userId) {
    return _sharedPreference.setString(Preferences.userId, userId);
  }
  Future<bool> removeuserId() {
    return _sharedPreference.remove(Preferences.userId);
  }


  String? get getlat {
    return _sharedPreference.getString(Preferences.lat);
  }

  Future<void> setlat(String lat) {
    return _sharedPreference.setString(Preferences.lat, lat);
  }
  Future<bool> removelat() {
    return _sharedPreference.remove(Preferences.lat);
  }


  String? get getlong{
    return _sharedPreference.getString(Preferences.long);
  }

  Future<void> setlong(String long) {
    return _sharedPreference.setString(Preferences.long, long);
  }
  Future<bool> removelong() {
    return _sharedPreference.remove(Preferences.long);
  }



}