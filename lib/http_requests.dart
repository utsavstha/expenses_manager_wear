import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:expense_manager_wear/app_cache.dart';

class HttpRequest {
  static final HttpRequest _httpRequest = HttpRequest._internal();
  late Dio dio;
  factory HttpRequest() {
    return _httpRequest;
  }

  HttpRequest._internal() {
    dio = Dio();
  }

  Future<dynamic> get(url) async {
    Response response;
    try {
      response = await dio.get(url);
    } on SocketException {
      throw SocketException('No Internet connection');
    }
    return response.data;
  }

  Future<dynamic> post(url, Map param) async {
    Response response;
    try {
      print(param);
      print(url);
      response = await dio.post(url, data: param);
      print(response.data);
    } on SocketException {
      throw SocketException('No Internet connection');
    }
    return response.data;
  }

  Future<dynamic> getWithAuth(url) async {
    Response response;
    try {
      // final token = await SaveData.getToken();
      print(AppCache.token);
      response = await dio.get(
        url,
        options: Options(
          headers: {
            "authorization": "Bearer " + AppCache.token,
          },
        ),
      );
      return response.data;
    } on SocketException {
      throw SocketException('No Internet connection');
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> postWithAuth(url, Map param) async {
    Response response;
    try {
      print(param);
      print(url);
      // final token = await SaveData.getToken();
      response = await dio.post(
        url,
        data: param,
        options: Options(
          headers: {
            "authorization": "Bearer " + "",
          },
        ),
      );
      print(response.data);
      return response.data;
    } on SocketException {
      throw SocketException('No Internet connection');
    } catch (e) {
      print(e);
    }
  }
}
