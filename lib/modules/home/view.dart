import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stt/widgets/float_button.dart';
import '../../widgets/scroll_update_list.dart';
import 'controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          return Stack(
            children: [
              ScrollUpdateList(
                onFetchMore: controller.onFetchMore,
                onReFetch: controller.onReFetch,
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.all(24.r),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.r),
                            child: ColoredBox(
                              color: Colors.black26,
                              child: SizedBox(
                                width: 1.sw - 48.r,
                                height: 1.sw - 48.r,
                              ),
                            ),
                          );
                        },
                        // ignore: invalid_use_of_protected_member
                        childCount: controller.list.value.length,
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: const Alignment(0, 0.9),
                child: FloatingButton(
                  onLongPressStart: controller.recordingOnStart,
                  onLongPressEnd: controller.recordingOnEnd,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
