import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:shop/data/my_local_store.dart';
import 'package:shop/exceptions/auth_exception.dart';

class Auth with ChangeNotifier {
  final Map<String, dynamic> _authDataLogged = {
    'token': null,
    'email': null,
    'userId': null,
    'expiryDate': null,
    'logoutTimer': null,
  };

  bool get isAuth {
    final isValid = _authDataLogged['expiryDate']?.isAfter(DateTime.now()) ?? false;
    return _authDataLogged['token'] != null && isValid;
  }

  String? get token {
    return isAuth ? _authDataLogged['token'] : null;
  }

  String? get email {
    return isAuth ? _authDataLogged['email'] : null;
  }

  String? get userId {
    return isAuth ? _authDataLogged['userId'] : null;
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> signIn(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> _authenticate(String email, String password, String urlSegment) async {
    final url = Uri.parse('${dotenv.env['API_URL_AUTH']}:$urlSegment?key=${dotenv.env['API_KEY']}');
    final Response response = await post(
      url,
      body: jsonEncode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );

    final body = jsonDecode(response.body);

    if (body['error'] != null) {
      throw AuthException(key: body['error']['message']);
    } else {
      _authDataLogged['token'] = body['idToken'];
      _authDataLogged['email'] = body['email'];
      _authDataLogged['userId'] = body['localId'];
      _authDataLogged['expiryDate'] = DateTime.now().add(Duration(seconds: int.parse(body['expiresIn'])));

      MyLocalStore.saveMap('userData', {
        ..._authDataLogged,
        'expiryDate': _authDataLogged['expiryDate']!.toIso8601String(),
      });

      _autoLogout();
      notifyListeners();
    }
  }

  Future<void> tryAutoLogin() async {
    if (isAuth) return;

    final userData = await MyLocalStore.getMap('userData');

    if (userData.isEmpty) return;

    final expiryDate = DateTime.parse(userData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) return;

    // _authDataLogged['token'] = userData['token'];
    // _authDataLogged['email'] = userData['email'];
    // _authDataLogged['userId'] = userData['userId'];
    // _authDataLogged['expiryDate'] = expiryDate;

    _authDataLogged.updateAll((key, value) {
      if (key == 'expiryDate') return expiryDate;
      return userData[key];
    });

    _autoLogout();
    notifyListeners();
  }

  void logout() {
    _authDataLogged.clear();
    _clearLogoutTimer();
    MyLocalStore.remove('userData').then((_) => notifyListeners());
  }

  void _clearLogoutTimer() {
    if (_authDataLogged['logoutTimer'] != null) {
      _authDataLogged['logoutTimer']?.cancel();
      _authDataLogged['logoutTimer'] = null;
    }
  }

  void _autoLogout() {
    _clearLogoutTimer();

    if (_authDataLogged['expiryDate'] != null) {
      final timeToLogout = _authDataLogged['expiryDate']!.difference(DateTime.now()).inSeconds;
      print('Tempo para logout: $timeToLogout segundos.');

      _authDataLogged['logoutTimer'] = Timer(Duration(seconds: timeToLogout), logout);
    }
  }
}
