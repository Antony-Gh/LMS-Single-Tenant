import 'package:flutter/material.dart';

class Constants {
  static const dommain = 'http://esoiegypt.cloud';
  static const baseUrl = '$dommain/api/development/';
  static const apiKey = '123456789';
  static const scheme = 'academyapp';
  static final RouteObserver<ModalRoute<void>> singleCourseRouteObserver = RouteObserver<ModalRoute<void>>();
  static final RouteObserver<ModalRoute<void>> contentRouteObserver = RouteObserver<ModalRoute<void>>();
  
}
