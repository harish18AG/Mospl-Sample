// lib/providers/auth_provider.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mospl/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';
import '../core/constants/app_constants.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AuthStatus _status = AuthStatus.initial;
  UserModel? _user;
  String? _errorMessage;
  String? _verificationId;
  bool _isAdmin = false;

  AuthStatus get status => _status;
  UserModel? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isAdmin => _isAdmin;
  bool get isLoading => _status == AuthStatus.loading;

  AuthProvider() {
    _init();
  }

  void _init() {
    _auth.authStateChanges().listen((User? firebaseUser) async {
      if (firebaseUser != null) {
        await _loadUserData(firebaseUser.uid);
      } else {
        _status = AuthStatus.unauthenticated;
        _user = null;
        _isAdmin = false;
        notifyListeners();
      }
    });
  }

  Future<void> _loadUserData(String uid) async {
    try {
      final doc = await _firestore.collection(AppConstants.usersCollection).doc(uid).get();
      if (doc.exists) {
        _user = UserModel.fromFirestore(doc);
        _isAdmin = _user!.isAdmin;
        _status = AuthStatus.authenticated;
      } else {
        _status = AuthStatus.unauthenticated;
      }
      notifyListeners();
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Email & Password Sign In
  Future<bool> signInWithEmail(String email, String password) async {
    _setLoading();
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      await _loadUserData(credential.user!.uid);
      _saveToken(await credential.user!.getIdToken() ?? '');
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_getAuthErrorMessage(e.code));
      return false;
    }
  }

  // Email & Password Sign Up
  Future<bool> signUpWithEmail({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    _setLoading();
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      await credential.user!.updateDisplayName(name);

      final userModel = UserModel(
        id: credential.user!.uid,
        name: name,
        email: email.trim(),
        phone: phone,
        role: 'user',
        addresses: [],
        rewardPoints: 100, // Welcome bonus
        preferences: {
          'notifications': true,
          'newsletter': true,
          'aiRecommendations': true,
        },
        createdAt: DateTime.now(),
        isActive: true,
        referralCode: _generateReferralCode(name),
      );

      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(credential.user!.uid)
          .set(userModel.toFirestore());

      await _loadUserData(credential.user!.uid);
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_getAuthErrorMessage(e.code));
      return false;
    }
  }

  // Google Sign In
  Future<bool> signInWithGoogle() async {
    _setLoading();
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _status = AuthStatus.unauthenticated;
        notifyListeners();
        return false;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final uid = userCredential.user!.uid;

      // Check if user exists, if not create profile
      final doc = await _firestore.collection(AppConstants.usersCollection).doc(uid).get();
      if (!doc.exists) {
        final userModel = UserModel(
          id: uid,
          name: googleUser.displayName ?? 'MOSPL User',
          email: googleUser.email,
          phone: '',
          profileImage: googleUser.photoUrl,
          role: 'user',
          addresses: [],
          rewardPoints: 100,
          preferences: {'notifications': true, 'aiRecommendations': true},
          createdAt: DateTime.now(),
          isActive: true,
          referralCode: _generateReferralCode(googleUser.displayName ?? 'user'),
        );
        await _firestore.collection(AppConstants.usersCollection).doc(uid).set(userModel.toFirestore());
      }

      await _loadUserData(uid);
      return true;
    } catch (e) {
      _setError('Google sign in failed. Please try again.');
      return false;
    }
  }

  // OTP - Send
  Future<bool> sendOTP(String phoneNumber) async {
    _setLoading();
    try {
      final completer = Completer<bool>();
      await _auth.verifyPhoneNumber(
        phoneNumber: '+91$phoneNumber',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          completer.complete(true);
        },
        verificationFailed: (FirebaseAuthException e) {
          _setError(_getAuthErrorMessage(e.code));
          completer.complete(false);
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          _status = AuthStatus.unauthenticated;
          notifyListeners();
          completer.complete(true);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
      return await completer.future;
    } catch (e) {
      _setError('Failed to send OTP. Please try again.');
      return false;
    }
  }

  // OTP - Verify
  Future<bool> verifyOTP(String otp, {String? name, String? phone}) async {
    if (_verificationId == null) {
      _setError('Verification session expired. Please request OTP again.');
      return false;
    }
    _setLoading();
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );
      final userCredential = await _auth.signInWithCredential(credential);
      final uid = userCredential.user!.uid;

      final doc = await _firestore.collection(AppConstants.usersCollection).doc(uid).get();
      if (!doc.exists) {
        final userModel = UserModel(
          id: uid,
          name: name ?? 'MOSPL User',
          email: userCredential.user?.email ?? '',
          phone: phone ?? userCredential.user?.phoneNumber ?? '',
          role: 'user',
          addresses: [],
          rewardPoints: 100,
          preferences: {'notifications': true, 'aiRecommendations': true},
          createdAt: DateTime.now(),
          isActive: true,
        );
        await _firestore.collection(AppConstants.usersCollection).doc(uid).set(userModel.toFirestore());
      }

      await _loadUserData(uid);
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_getAuthErrorMessage(e.code));
      return false;
    }
  }

  // Forgot Password
  Future<bool> sendPasswordResetEmail(String email) async {
    _setLoading();
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_getAuthErrorMessage(e.code));
      return false;
    }
  }

  // Update Profile
  Future<bool> updateProfile({String? name, String? phone, String? profileImage}) async {
    if (_user == null) return false;
    try {
      final updates = <String, dynamic>{};
      if (name != null) updates['name'] = name;
      if (phone != null) updates['phone'] = phone;
      if (profileImage != null) updates['profileImage'] = profileImage;
      updates['updatedAt'] = FieldValue.serverTimestamp();

      await _firestore.collection(AppConstants.usersCollection).doc(_user!.id).update(updates);
      await _loadUserData(_user!.id);
      return true;
    } catch (e) {
      _setError('Failed to update profile.');
      return false;
    }
  }

  // Add Address
  Future<bool> addAddress(Map<String, dynamic> address) async {
    if (_user == null) return false;
    try {
      address['id'] = DateTime.now().millisecondsSinceEpoch.toString();
      await _firestore.collection(AppConstants.usersCollection).doc(_user!.id).update({
        'addresses': FieldValue.arrayUnion([address]),
      });
      await _loadUserData(_user!.id);
      return true;
    } catch (e) {
      _setError('Failed to add address.');
      return false;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.keyUserToken);
    _user = null;
    _status = AuthStatus.unauthenticated;
    _isAdmin = false;
    notifyListeners();
  }

  // Delete Account
  Future<bool> deleteAccount() async {
    if (_user == null) return false;
    try {
      await _firestore.collection(AppConstants.usersCollection).doc(_user!.id).delete();
      await _auth.currentUser!.delete();
      await signOut();
      return true;
    } catch (e) {
      _setError('Failed to delete account. Please re-authenticate and try again.');
      return false;
    }
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.keyUserToken, token);
  }

  void _setLoading() {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    _status = AuthStatus.error;
    _errorMessage = message;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  String _getAuthErrorMessage(String code) {
    switch (code) {
      case 'user-not-found': return 'No account found with this email.';
      case 'wrong-password': return 'Incorrect password. Please try again.';
      case 'email-already-in-use': return 'This email is already registered.';
      case 'weak-password': return 'Password should be at least 6 characters.';
      case 'invalid-email': return 'Please enter a valid email address.';
      case 'user-disabled': return 'This account has been disabled.';
      case 'too-many-requests': return 'Too many attempts. Please try again later.';
      case 'invalid-verification-code': return 'Invalid OTP. Please check and try again.';
      case 'session-expired': return 'OTP expired. Please request a new one.';
      default: return 'Authentication failed. Please try again.';
    }
  }

  String _generateReferralCode(String name) {
    final prefix = name.replaceAll(' ', '').toUpperCase().substring(0, name.length > 3 ? 3 : name.length);
    final suffix = DateTime.now().millisecondsSinceEpoch.toString().substring(8);
    return 'MSP$prefix$suffix';
  }
}