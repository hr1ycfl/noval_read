import 'package:floor/floor.dart';
import 'package:novel_read/model/entity/source.dart';

@dao
abstract class SourceDao {
  static String get order => "$sortName $sortOrder";
  static String sortName = sortMap["更新时间"]!;
  static String sortOrder = desc;

  // 逆序
  static const String desc = "desc";

  // 正序
  static const String asc = "asc";

  static const sortMap = {
    "手动排序": "customOrder",
    "更新时间": "lastUpdateTime",
    "响应时间": "respondTime",
    "智能排序": "weight"
  };

  @Query('SELECT * FROM source ORDER BY :order')
  Future<List<Source>> findAllSource(String order);

  @Query('SELECT * FROM source where enabled = 1 ORDER BY :order')
  Future<List<Source>> findEnabledSource(String order);

  @Query('SELECT * FROM source where bookSourceName like :name ORDER BY :order')
  Future<List<Source>> findAllSourceByName(String name, String order);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insertOrUpdateRule(Source source);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>> insertOrUpdateRules(List<Source> sources);
}
