import 'package:get/get.dart';
import 'package:elecktro_ecommerce/app/modules/profile/account%20options/account_settings/controller.dart';

class AccountSettingsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AccountSettingsController>(
      () => AccountSettingsController(),
    );
  }
}
