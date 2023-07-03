import 'package:get/get.dart';

import '../controllers/converse_controller.dart';

class ConverseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConverseController>(
      () => ConverseController(),
    );
  }
}
