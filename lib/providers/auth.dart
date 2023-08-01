import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shop_app/models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;

  bool get isAuthenticated {
    return getToken != null;
  }

  String get userId {
    return _userId ?? '';
  }

  String? get getToken {
    final bool isTokenNotExpired =
        _expiryDate?.isAfter(DateTime.now()) ?? false;

    if (_expiryDate != null && _token != null && isTokenNotExpired) {
      return _token;
    }

    return null;
  }

  Future<void> _authenticate(
      String email, String password, String segmentUrl) async {
    try {
      final url = Uri.parse(
          'https://identitytoolkit.googleapis.com/v1/accounts:$segmentUrl?key=AIzaSyBU2MPoADRHUoYjs_T712dwrN7y02gnTdk');

      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));

      final responseData = json.decode(response.body);

      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }

      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));

      _autoLogout();
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate?.toIso8601String()
      });
      prefs.setString('userData', userData);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> signIn(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey('userData')) {
      return false;
    }

    final savedUserData = prefs.getString('userData') ?? '';
    final parsedUserData = json.decode(savedUserData);

    final expiryDate = DateTime.parse(parsedUserData['expiryDate'] as String);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = parsedUserData['token'] as String;
    _userId = parsedUserData['userId'] as String;
    _expiryDate = expiryDate;
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _expiryDate = null;
    _userId = null;

    if (_authTimer != null) {
      _authTimer?.cancel();
      _authTimer = null;
    }

    final prefs = await SharedPreferences.getInstance();
    // to clear specific keys
    // prefs.remove('authData');
    // below will clear everything
    prefs.clear();

    notifyListeners();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer?.cancel();
    }

    final timeToExpiry = _expiryDate?.difference(DateTime.now()).inSeconds ?? 0;

    _authTimer = Timer(Duration(seconds: timeToExpiry), () {
      logout();
    });
  }
}
