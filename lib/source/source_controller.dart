import 'package:get/get.dart';
import 'package:novel_read/dao/source_dao.dart';
import 'package:novel_read/global.dart';
import 'package:novel_read/model/entity/source.dart';

class SourceController extends GetxController {
  RxList sourceList = [].obs;

  searchDb(String? name) async {
    List<Source> sourceData = [];
    if (name == null) {
      sourceData = await Global.sourceDao.findAllSource(SourceDao.order);
    } else {
      sourceData = await Global.sourceDao
          .findAllSourceByName('%$name%', SourceDao.order);
    }
    sourceList.assignAll(sourceData);
  }

  Future<List<Source>> getEnabledSourceList() async {
    return await Global.sourceDao.findEnabledSource(SourceDao.order);
  }
}
