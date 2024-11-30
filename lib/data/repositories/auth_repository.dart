import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:fluttalk/data/models/user.dart';

class AuthRepository {
  final Dio _dio;
  final FirebaseAuth _auth;

  AuthRepository(this._dio, this._auth);

  Future<User> getMe() async {
    final response = await _dio.get('getMe');
    return User.fromJson(response.data['result']);
  }

  Future<User> updateMe(UpdateMeRequest request) async {
    final response = await _dio.post(
      'updateMe',
      data: request.toJson(),
    );
    return User.fromJson(response.data['result']);
  }

  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    return _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}

class UpdateMeRequest {
  final String name;

  const UpdateMeRequest({required this.name});

  Map<String, dynamic> toJson() => {'name': name};
}
