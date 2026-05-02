import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authViewModelProvider = Provider<AuthViewModel>((ref) => AuthViewModel());

class AuthViewModel {
  final _auth = FirebaseAuth.instance;

  Future<UserCredential> signIn(String email, String password) =>
      _auth.signInWithEmailAndPassword(email: email, password: password);
}
