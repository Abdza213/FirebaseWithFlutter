import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class idItem {
  String id;

  idItem({
    required this.id,
  });
}

class Auth with ChangeNotifier {
  List<idItem> addIdUser = [];
  /////
  ////1.
  String _token = '';
  late DateTime _expiryDate;
  String _userId = '';
  bool get AuthToken {
    return token != '';
  }

  Object get token {
    return _token;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final String uri =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyAZ503X9F8Bng2XiXZONMLRTsZp65v29Q0';

    try {
      http.Response res = await http.post(Uri.parse(uri),
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final resData = json.decode(res.body);
      if (resData['error'] != null) {
        throw '${resData['error']['message']}';
      }
      _token = resData['idToken'];
      _userId = resData['localId'];

      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(resData['expiresIn']),
        ),
      );
      addIdUser.add(idItem(
        id: _userId,
      ));

      print('userId -:  ${_userId}');
      notifyListeners();
      print('userId -:  ${_userId}');
      // print('is Auth ===  $isAuth');
      // print('is toke === $_token');
    } catch (e) {
      throw e;
    }
  }

  ///
  ////
  ////
  ///////
  ///
  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }
}
