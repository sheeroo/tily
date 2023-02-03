import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/infrastructure/dio_extensions.dart';
import '../../core/infrastructure/exceptions.dart';
import 'auth_response.dart';

class AuthRemoteService {
  AuthRemoteService(this._dio);

  final Dio _dio;

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } on DioError catch (e) {
      if (e.isNoConnectionError || e.isConnectionTimeout) {
        throw NoConnectionException();
      } else if (e.response != null) {
        throw RestApiException(e.response?.statusCode);
      } else {
        rethrow;
      }
    }
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      final user = userCredential.user;
      if (user != null) {
        final user = userCredential.user;
        final token = await user!.getIdToken();

        return AuthResponse.withToken(token);
      } else {
        return const AuthResponse.failure();
      }
    } on DioError catch (e) {
      if (e.isNoConnectionError || e.isConnectionTimeout) {
        throw NoConnectionException();
      } else if (e.response != null) {
        throw RestApiException(e.response?.statusCode);
      } else {
        rethrow;
      }
    }
  }
}
