// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stt/common/theme.dart';
import 'package:stt/data/models/recording_record_model.dart';
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
                          if (index == controller.recordingRecordsList.length) {
                            return SizedBox(
                              height: 0.1.sh,
                            );
                          }

                          late final RecordingRecordModel record;
                          final item = controller.recordingRecordsList[index];
                          if (item.runtimeType == RecordingRecordModel) {
                            record = item;
                          } else {
                            record = RecordingRecordModel.fromJson(item);
                          }

                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.r),
                            child: SpeechToTextBox(
                              record: record,
                              computeOnPressed: controller.speechToText,
                              deleteOnPressed: controller.deleteRecord,
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
                onLongPressStart: controller.recordingOnStart,
                onLongPressEnd: controller.recordingOnEnd,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
