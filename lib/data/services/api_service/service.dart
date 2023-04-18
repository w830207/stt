import 'dart:io';

import 'package:get/get.dart';

import '../../models/response_model.dart';
import 'repository.dart';

class ApiService extends GetxService {
  static ApiService get to => Get.find();
  late ApiServiceRepository http;
  late String speechToTextModel;
  List speechToTextModelsList = [
    "openai/whisper-tiny.en",
    "kevin51jiang/whisper-tiny-zh-CN",
  ];

  @override
  void onInit() {
    super.onInit();
    http = ApiServiceRepository("https://api-inference.huggingface.co/models/");
    speechToTextModel = speechToTextModelsList.first;
  }

  changeSpeechToTextModel(String modelName) {
    speechToTextModel = modelName;
  }

  /// 提供post方法
  Future<ResponseModel> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? query,
    int? length,
  }) async {
    if (length != null) {
      http.dio.options.headers['content-length'] = length;
    }

    final response = await http.dio.post(
      path,
      data: data,
      queryParameters: query,
    );
    return response.data;
  }

  Future<ResponseModel> speechToText({
    required String filePath,
  }) async {
    var bytes = File(filePath).readAsBytesSync();
    return post(
      speechToTextModel,
      data: Stream.fromIterable(bytes.map((e) => [e])),
      length: bytes.length,
    );
  }

  Future<ResponseModel> chineseToEnglish({
    required String text,
  }) async {
    return post(
      "Helsinki-NLP/opus-mt-zh-en",
      data: {"inputs": text},
    );
  }

  Future<ResponseModel> englishToChinese({
    required String text,
  }) async {
    return post(
      "liam168/trans-opus-mt-en-zh",
      data: {"inputs": text},
    );
  }
}
