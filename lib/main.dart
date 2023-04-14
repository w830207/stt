import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stt/data/services/api_service/service.dart';
import 'package:stt/routes/pages.dart';

import 'data/services/recording_record_service/service.dart';

void main() async {
  await initialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 667),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, widget) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: "/home",
          getPages: AppPages.pages,
          defaultTransition: Transition.fadeIn,
          builder: EasyLoading.init(),
        );
      },
    );
  }
}

initialized() async {
  Get.put(RecordingRecordsService());
  Get.put(ApiService());
}
