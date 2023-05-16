import 'package:bhashantram/app/common/utils/language_code.dart';
import 'package:bhashantram/app/data/api_calls/bhashini_calls.dart';
import 'package:bhashantram/app/data/network_models/network_models.dart';
import 'package:get/get.dart';

class ConverseController extends GetxController {
  RxBool languageLoader = RxBool(false);
  Rxn<LanguageModels?> languages = Rxn<LanguageModels>();
  List<String> sourceLanguages = [];
  RxnString sourceLang = RxnString();
  RxnString targetLang = RxnString();
  int selectedSourceLangIndex = -1;
  int selectedTargetLangIndex = -1;

  Future<void> getLanguages() async {
    languageLoader.value = true;
    LanguageModels? response = await BhashiniCalls.instance.getLanguages();
    if (response != null) {
      languages.value = response;
    }
    // else {
    //   await showSnackBar();
    // }
    languageLoader.value = false;
  }

  String getLanguageName(String code) => LanguageCode.languageCode.entries
      .firstWhere((element) => element.key == code, orElse: () => MapEntry('', code))
      .value;

  int targetLanguageListLength() {
    return languages.value?.languages
            ?.firstWhere((element) => element.sourceLanguage == sourceLang.value)
            .targetLanguageList
            ?.length ??
        0;
  }

  @override
  void onInit() async {
    await getLanguages();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
