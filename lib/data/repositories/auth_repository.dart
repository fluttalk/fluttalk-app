import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttalk/core/error/error.dart';
import 'package:fluttalk/data/models/account_model.dart';

class AuthRepository {
  final FirebaseAuth _auth;

  AuthRepository(this._auth);

  Future<AccountModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user;
    if (user == null) {
      throw NullUserException();
    }
    return AccountModel.fromFirebaseUser(user);
  }

  Future<AccountModel> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user;
    if (user == null) {
      throw NullUserException();
    }
    return AccountModel.fromFirebaseUser(user);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  AccountModel? get currentUser {
    final user = _auth.currentUser;
    return user != null ? AccountModel.fromFirebaseUser(user) : null;
  }

  Stream<AccountModel?> authStateChanges() {
    return _auth.authStateChanges().map((user) {
      return user != null ? AccountModel.fromFirebaseUser(user) : null;
    });
  }
}
