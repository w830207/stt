import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:stt/common/popup.dart' as popup;

import '../../models/response_model.dart';

class ApiServiceRepository {
  final String baseUrl;
  late final Dio dio;
  int timeout = 10000;

  ApiServiceRepository(this.baseUrl) {
    dio = Dio();
    dio.options.baseUrl = baseUrl;
    dio.options.connectTimeout = timeout;
    dio.options.sendTimeout = timeout;
    headersInterceptor();
    prettyDioLog();
    modelLoadingError();
    transferInterceptor();
  }

  /// 添加攔截器
  _subscribe({
    InterceptorSendCallback? onRequest,
    InterceptorSuccessCallback? onResponse,
    InterceptorErrorCallback? onError,
  }) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: onRequest,
        onResponse: onResponse,
        onError: onError,
      ),
    );
  }

  /// 寫入 Bearer token：AccessToken
  headersInterceptor() {
    _subscribe(
      onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
        popup.loading();
        options.headers['Authorization'] =
            "Bearer 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";
        handler.next(options);
      },
    );
  }

  /// 美化Log
  prettyDioLog() {
    if (kReleaseMode) return;
    dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: false,
      responseHeader: false,
    ));
  }

  /// 把收到的內容轉換成ResponseModel
  transferInterceptor() {
    _subscribe(
      onResponse: (Response response, ResponseInterceptorHandler handler) {
        if (popup.isLoading()) {
          popup.stop();
        }
        handler.next(Response(
          headers: response.headers,
          data: ResponseModel.fromJson(response.data),
          requestOptions: response.requestOptions,
          statusCode: response.statusCode,
          statusMessage: response.statusMessage,
          isRedirect: response.isRedirect,
          redirects: response.redirects,
          extra: response.extra,
        ));
      },
    );
  }

  modelLoadingError() {
    _subscribe(
      onError: (DioError err, ErrorInterceptorHandler handler) async {
        int retry = err.requestOptions.extra['retry'] ?? 0;
        RequestOptions retryOptions = err.requestOptions;
        retryOptions.extra = {
          ...err.requestOptions.extra,
          'retry': retry + 1,
        };

        Timer(const Duration(seconds: 10), () {
          Dio()
            ..options = dio.options
            ..interceptors.addAll(dio.interceptors)
            ..fetch(retryOptions).then((value) {
              handler.resolve(value);
            });
        });
      },
    );
  }
}
