import 'dart:io';

import 'package:dio/dio.dart';

import 'result.dart';

abstract class ApiClientProtocol {
  Future<Result> get(String path);
  Future<Result> post(String path, dynamic body);
}

class ApiClient extends ApiClientProtocol {
  final Dio _client = Dio()
    ..options.baseUrl = ''
    ..options.headers = {}
    ..options.contentType = ContentType.json.value;

  @override
  Future<Result> get(String path) async {
    try {
      final response = await _client.get(path);
      return Result.ok(response);
    } on DioException catch (error) {
      return Result.error(error);
    }
  }

  @override
  Future<Result> post(String path, dynamic body) async {
    try {
      final response = await _client.post(path, data: body);
      return Result.ok(response);
    } on DioException catch (error) {
      return Result.error(error);
    }
  }
}
