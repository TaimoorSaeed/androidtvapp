import 'package:dio/dio.dart';

class AndroidTVApi {
  static final BaseOptions _baseOptions = BaseOptions(
    baseUrl: "https://youtube.googleapis.com/youtube/v3/",
  );

  // For unauthenticated routes
  static Dio dio = Dio(_baseOptions);

  // For authenticated routes
  static Dio dioAuth() {
    return Dio();
  }
}
