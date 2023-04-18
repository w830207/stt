// ignore_for_file: invalid_use_of_protected_member

import 'package:animated_list_item/animated_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stt/common/theme.dart';
import 'package:stt/data/models/recording_record_model.dart';
import 'package:stt/data/services/api_service/service.dart';
import 'package:stt/widgets/float_button.dart';
import 'package:stt/widgets/speech_to_text_box.dart';
import '../../widgets/scroll_update_list.dart';
import 'controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.blueGrey,
      appBar: AppBar(
        centerTitle: false,
        title: Obx(() {
          return Text(
            controller.title.value,
            style: AppTheme.appbarTitle,
          );
        }),
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return ApiService.to.speechToTextModelsList
                  .map((modelName) => PopupMenuItem(
                        value: modelName,
                        child: Text(modelName),
                      ))
                  .toList();
            },
            onSelected: controller.selectModel,
            child: Container(
              width: 40.0,
              margin: const EdgeInsets.all(8),
              decoration: AppTheme.decoration,
              child: const Icon(
                Icons.change_circle_outlined,
                color: Colors.black,
              ),
            ),
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Obx(() {
              return ScrollUpdateList(
                onFetchMore: controller.onFetchMore,
                onReFetch: controller.onReFetch,
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.all(24.r),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          if (controller.recordingRecordsList.isEmpty) {
                            return TextButton(
                                onPressed: controller.getSample,
                                child: const Text("add Sample"));
                          }

                          if (index == controller.recordingRecordsList.length) {
                            return SizedBox(
                              height: 0.1.sh,
                            );
                          }

                          late final RecordModel record;
                          final item = controller.recordingRecordsList[index];
                          if (item.runtimeType == RecordModel) {
                            record = item;
                          } else {
                            record = RecordModel.fromJson(item);
                          }

                          return AnimatedListItem(
                            index: index,
                            length: controller.recordingRecordsList.length,
                            aniController: controller.animationController,
                            animationType: AnimationType.zoomIn,
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.r),
                              child: SpeechToTextBox(
                                record: record,
                                computeOnPressed: controller.speechToText,
                                deleteOnPressed: controller.deleteRecord,
                                chineseToEnglish: controller.chineseToEnglish,
                                englishToChinese: controller.englishToChinese,
                                chineseToPinyin: controller.chineseToPinyin,
                                chineseToZhuyin: controller.chineseToZhuyin,
                              ),
                            ),
                          );
                        },
                        childCount:
                            controller.recordingRecordsList.value.length + 1,
                      ),
                    ),
                  ),
                ],
              );
            }),
            Align(
              alignment: const Alignment(0, 0.9),
              child: FloatingButton(
                micOnLongPressStart: controller.recordingOnStart,
                micOnLongPressEnd: controller.recordingOnEnd,
                fileOnPressed: controller.choseFile,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
