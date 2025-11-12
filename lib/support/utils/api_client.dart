import 'dart:io';

import 'package:dio/dio.dart';

import 'result.dart';

abstract class ApiClientProtocol {
  Future<Result> get(String path, {Map<String, dynamic>? queryParameters});
  Future<Result> post(String path, dynamic body);
  Future<Result> put(String path, dynamic body);
  Future<Result> delete(String path);
}

class ApiClient extends ApiClientProtocol {
  final Dio _client = Dio()
    ..options.baseUrl = 'http://localhost:3000'
    ..options.contentType = ContentType.json.value;

  @override
  Future<Result> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _client.get(path, queryParameters: queryParameters);
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

  @override
  Future<Result> put(String path, dynamic body) async {
    try {
      final response = await _client.put(path, data: body);
      return Result.ok(response);
    } on DioException catch (error) {
      return Result.error(error);
    }
  }

  @override
  Future<Result> delete(String path) async {
    try {
      final response = await _client.delete(path);
      return Result.ok(response);
    } on DioException catch (error) {
      return Result.error(error);
    }
  }
}
