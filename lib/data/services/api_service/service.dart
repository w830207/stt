import 'dart:io';

import 'package:get/get.dart';

import '../../models/response_model.dart';
import 'repository.dart';

class ApiService extends GetxService {
  static ApiService get to => Get.find();
  late ApiServiceRepository http;
  String huggingFaceModel = "/openai/whisper-tiny.en";

  @override
  void onInit() {
    super.onInit();
    http = ApiServiceRepository("https://api-inference.huggingface.co/models/");
  }

  /// 提供post方法
  Future<ResponseModel> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? query,
    int? length,
  }) async {
    if (length == null) {
      http.dio.options.headers['content-length'] = length;
    }

    final response = await http.dio.post(
      path,
      data: data,
      queryParameters: query,
    );
    return response.data;
  }

  Future<ResponseModel> automaticSpeechRecognition({
    required String filePath,
  }) async {
    var bytes = File(filePath).readAsBytesSync();
    return post(
      huggingFaceModel,
      data: Stream.fromIterable(bytes.map((e) => [e])),
      length: bytes.length,
    );
  }
}