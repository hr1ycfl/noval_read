import 'package:get/get.dart';

class HomeController extends GetxController {

  var selectGroupIndex = 0.obs;


  setSelectGroupIndex(int groupIndex) {
    selectGroupIndex = groupIndex.obs;
  }


}
