import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants {
  static const dommain = 'http://esoiegypt.cloud';
  static String get baseUrl => dotenv.env['BASE_URL'] ?? '$dommain/api/development/';
  static String get apiKey => dotenv.env['API_KEY'] ?? '123456789';
  static const scheme = 'academyapp';
  static final RouteObserver<ModalRoute<void>> singleCourseRouteObserver = RouteObserver<ModalRoute<void>>();
  static final RouteObserver<ModalRoute<void>> contentRouteObserver = RouteObserver<ModalRoute<void>>();
  
}
