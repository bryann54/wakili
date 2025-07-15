// lib/core/di/register_modules.dart
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uuid/uuid.dart';

@module
abstract class RegisterModules {
  @preResolve
  Future<SharedPreferences> prefs() async =>
      await SharedPreferences.getInstance();

  @Named('BaseUrl')
  String get baseUrl => dotenv.env['BASE_URL']!;

  @Named('ApiKey')
  String get apiKey => dotenv.env['API_KEY']!;

  @lazySingleton
  Dio dio(@Named('BaseUrl') String url) => Dio(
        BaseOptions(baseUrl: url, connectTimeout: const Duration(seconds: 10)),
      );

  // <------------------------------>
  // Firebase and Google Sign-In related dependencies
  @lazySingleton
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;

  @lazySingleton
  GoogleSignIn get googleSignIn => GoogleSignIn();
    @lazySingleton 
  Uuid get uuid => const Uuid();
    @lazySingleton 
  FirebaseStorage get firebaseStorage => FirebaseStorage.instance;

  // <------------------------------>
}
