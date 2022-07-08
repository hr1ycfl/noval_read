import 'dart:async';

import 'package:floor/floor.dart';
import 'package:novel_read/dao/source_dao.dart';
import 'package:novel_read/model/entity/source.dart';
import 'package:novel_read/rule/type_convert/book_info_rule_type_convert.dart';
import 'package:novel_read/rule/type_convert/content_rule_type_convert.dart';
import 'package:novel_read/rule/type_convert/explore_rule_type_convert.dart';
import 'package:novel_read/rule/type_convert/search_rule_type_convert.dart';
import 'package:novel_read/rule/type_convert/toc_rule_type_convert.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'database.g.dart'; // the generated code will be there

@TypeConverters([
  ExploreRuleTypeConvert,
  BookInfoRuleTypeConvert,
  ContentRuleTypeConvert,
  SearchRuleTypeConvert,
  TocRuleTypeConvert
])
@Database(version: 1, entities: [Source])
abstract class AppDatabase extends FloorDatabase {
  SourceDao get sourceDao;
}
