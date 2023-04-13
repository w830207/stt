import 'package:get/get.dart';

import '../modules/home/binding.dart';
import '../modules/home/view.dart';

abstract class AppPages {
  static final pages = [
    GetPage(
      name: "/home",
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
  ];
}
