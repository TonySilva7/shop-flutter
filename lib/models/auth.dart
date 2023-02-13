import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shop/exceptions/auth_exception.dart';

class Auth with ChangeNotifier {
  static const String _apiKey = 'AIzaSyCXBPpa2OqT2E1cY-0aS4uCTFD-zgNCrlE';
  final Map<String, dynamic> _authDataLogged = {
    'token': null,
    'email': '',
    'uid': '',
    'expiryDate': null,
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

  String? get uid {
    return isAuth ? _authDataLogged['uid'] : null;
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> signIn(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> _authenticate(String email, String password, String urlSegment) async {
    final url = Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=$_apiKey');
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
      _authDataLogged['uid'] = body['localId'];
      _authDataLogged['expiryDate'] = DateTime.now().add(Duration(seconds: int.parse(body['expiresIn'])));

      notifyListeners();
    }
  }
}
