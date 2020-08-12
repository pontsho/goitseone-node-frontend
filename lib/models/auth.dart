import 'dart:convert';
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  // final FacebookLogin _facebookLogin = FacebookLogin();

  Stream<String> get onAuthStateChanged => _firebaseAuth.onAuthStateChanged.map(
        (FirebaseUser user) => user?.uid,
      );

  Future<FirebaseUser> currentUser() async {
    return (await _firebaseAuth.currentUser());
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password, String firstName, String lastName) async {
    try {
      _userId = (await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user
          .uid;
      notifyListeners();
    } catch (error) {
      throw error;
    }

    // return currentUser();
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      _userId = (await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user
          .uid;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount account = await _googleSignIn.signIn();
      final GoogleSignInAuthentication _auth = await account.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: _auth.accessToken,
        idToken: _auth.idToken,
      );
      FirebaseUser user =
          (await _firebaseAuth.signInWithCredential(credential)).user;
      _userId = user.uid;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signOut() {
    logout();
    return _firebaseAuth.signOut();
  }

  // Future<void> signInWithFacebook() async {
  //   try {
  //     final result = await _facebookLogin.logInWithReadPermissions(['email']);

  //     final AuthCredential credential = FacebookAuthProvider.getCredential(
  //       accessToken: result.accessToken.token,
  //     );
  //     FirebaseUser user =
  //         (await _firebaseAuth.signInWithCredential(credential)).user;
  //     _userId = user.uid;
  //     notifyListeners();
  //   } on Exception catch (error) {
  //     throw error;
  //   }
  // }

  bool get isAuth {
    return onAuthStateChanged != null;
  }

  String get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/$urlSegment?key=AIzaSyDvKvBO-EJF1K5yayZ-mg1P2ASsoLflkqA';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate.toIso8601String(),
        },
      );
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signupNewUser');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'verifyPassword');
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('userData');
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
