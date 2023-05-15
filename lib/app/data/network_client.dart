import 'dart:developer';
import 'package:bhashantram/app/common/widget/snackbar/custom_snackbar.dart';
import 'package:dio/dio.dart';

enum RestApiMethod { get, post }

class NetworkClient {
  static final NetworkClient instance = NetworkClient._();

  NetworkClient._();

  Dio dio = Dio();

  showError(DioError e) {
    try {
      // showSnackBar(jsonDecode(e.response.toString())['message'] ?? e.message, isError: true);
    } catch (error) {
      // showSnackBar(e.message, isError: true);
    }
  }

  Future<Map<String, dynamic>?> _restApi<T>(
    String path, {
    required RestApiMethod apiMethod,
    Map<String, dynamic>? headers,
    dynamic body = const {},
    bool isBearerToken = false,
    bool showError = true,
    bool showResponseLog = true,
  }) async {
    try {
      ///logging the POST endpoint and PAYLOAD
      log(path, name: '$apiMethod');
      if (body is! FormData) log(body.toString(), name: "PAYLOAD");

      ///Hitting the POST request
      Response<T>? response;
      switch (apiMethod) {
        case RestApiMethod.post:
          response = await dio.post(
            path,
            data: body,
            options: Options(headers: headers),
          );
          break;
        case RestApiMethod.get:
          response = await dio.get(
            path,
            data: body,
            options: Options(headers: headers),
          );
          break;
        default:
          break;
      }

      ///logging the RESPONSE details
      if(showResponseLog){
        log('${response?.data}', name: "RESPONSE");
        log('${response?.statusCode}', name: "RESPONSE STATUS CODE");
      }

      ///if nor error then return response else return NUll
      if (response?.data is Map?) {
        Map<String, dynamic>? x = response?.data as Map<String, dynamic>?;
        if (x != null && (x['status'] != false)) {
          return x;
        } else {
          if (showError) {
            String errorMessage = '${x?['message'].toString()}';
            if (!errorMessage.contains('SocketException') && !errorMessage.contains('HttpException')) {
              showSnackBar(errorMessage, isError: true);
            } else {
              showSnackBar('Something went wrong!', isError: true);
            }
          }
        }
      }
    } on DioError catch (e) {
      ///if exception show the error
      log('${e.response}', name: 'DIO EXCEPTION');
      if (showError) {
        if (!e.toString().contains('SocketException') && !e.toString().contains('HttpException')) {
          this.showError(e);
        } else {
          // showSnackBar('Something went wrong!', isError: true);
        }
      }
    }
    return null;
  }

  Future<Map<String, dynamic>?> postApi<T>(
    String path, {
    required dynamic body,
    bool showError = true,
    Map<String, dynamic>? header,
  }) async {
    return await _restApi(
      path,
      body: body,
      apiMethod: RestApiMethod.post,
      showError: showError,
      headers: header,
    );
  }

  Future<Map<String, dynamic>?> getApi<T>(
    String path, {
    bool showError = true,
    Map<String, dynamic>? header,
  }) async {
    return await _restApi(
      path,
      apiMethod: RestApiMethod.get,
      showError: showError,
      headers: header,
    );
  }
}
