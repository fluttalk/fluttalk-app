import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttalk/core/api/single_response.dart';
import 'package:fluttalk/core/error/error.dart';
import 'package:fluttalk/core/network/end_points.dart';
import 'package:fluttalk/data/models/account_model.dart';
import 'package:fluttalk/data/models/token_model.dart';

class AuthRepository {
  final FirebaseAuth _auth;
  final Dio _dio;

  AuthRepository(
    this._auth,
    this._dio,
  );

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

  Future<SingleResponse<TokenModel>> refreshToken() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw NullUserException();
    }

    final token = await user.getIdToken();
    final response = await _dio.post(
      ApiEndpoints.refreshToken,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    return SingleResponse.fromJson(
      response.data,
      (json) => TokenModel.fromJson(json),
    );
  }

  Future<void> revokeToken() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw NullUserException();
    }

    final token = await user.getIdToken();
    await _dio.post(
      ApiEndpoints.revokeToken,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
  }
}
