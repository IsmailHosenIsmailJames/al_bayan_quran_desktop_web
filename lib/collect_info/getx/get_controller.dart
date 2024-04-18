import 'package:get/get.dart';

class InfoController extends GetxController {
  RxInt selectedOptionTranslation = (-1).obs;
  RxString translationLanguage = "null".obs;
  RxString bookIDTranslation = "-1".obs;
  RxInt bookNameIndex = (-1).obs;
  RxInt recitationIndex = (-1).obs;
  RxString recitationName = "-1".obs;
  RxString translationBookName = "null".obs;
  RxBool isPreviousEnaviled = false.obs;
}
