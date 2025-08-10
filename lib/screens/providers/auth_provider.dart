

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:mood_tracker/screens/Service/auth_service.dart';

class AuthProviders extends ChangeNotifier{
  bool loading = false;
  String? error;
  User? user;

 final AuthService _service = AuthService();



  Future<bool> signIn(String email, String password) async {
    _start();
    try {
      await _service.signIn(email, password);
      _ok();
      return true;
    } catch (e) {
      _fail(e);
      return false;
    }
  }

  Future<bool> signUp(String email, String password) async {
    _start();
    try {
      await _service.signUp(email, password);
      print(email);
      print(password);
      _ok();
      return true;
    } catch (e) {
      _fail(e);
      return false;
    }
  }

  Future<void> signOut() async {
    await _service.signOut();
  }



  void _start(){
    loading = true;
    error = null;
    notifyListeners();
  }

  void _ok(){
    loading = false;
    notifyListeners();
  }

  void _fail(Object e){
    loading = false;
    error = _parse(e);
    notifyListeners();
  }


  String _parse(Object e) {
    final s = e.toString();
    if (s.contains('email-already-in-use')) return 'Email already in use';
    if (s.contains('invalid-email')) return 'Invalid email address';
    if (s.contains('weak-password')) return 'Weak password (min 6 chars)';
    if (s.contains('user-not-found') || s.contains('wrong-password')) return 'Invalid credentials';
    return 'Something went wrong. Try again';
  }
}