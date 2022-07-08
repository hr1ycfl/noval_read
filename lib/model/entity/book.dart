import 'package:floor/floor.dart';
import 'package:novel_read/constants/group_constant.dart';
import 'package:novel_read/model/entity/source.dart';

@Entity(tableName: "book")
class Book {
  // 基本信息
  @PrimaryKey(autoGenerate: true)
  int? id;
  String? name;
  String? author;
  String? bookUrl;
  String? coverUrl;
  String? intro;
  String? kind;
  String? lastChapter;
  String? wordCount;
  String? lastReadChapter;
  int? groupId;
  int? lastReadPage;

  //关联的书源
  int? sourceId = -1;
  @ignore
  Source? source;
  int? sourceCount = 0;

  Book(
      {this.id,
      this.name,
      this.author,
      this.bookUrl,
      this.coverUrl,
      this.intro,
      this.kind,
      this.lastChapter,
      this.wordCount,
      this.lastReadChapter,
      this.groupId = GroupConstant.unclassifiedGroupId,
      this.lastReadPage = 1,
      this.sourceId,
      this.sourceCount = 0});

  Book.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    author = json['author'];
    bookUrl = json['bookUrl'];
    coverUrl = json['coverUrl'];
    intro = json['intro'];
    kind = json['kind'];
    lastChapter = json['lastChapter'];
    wordCount = json['wordCount'];
    lastReadChapter = json['lastReadChapter'];
    groupId = json['groupId'];
    lastReadPage = json['lastReadPage'];
    sourceId = json['sourceId'];
    sourceCount = json['sourceCount'];
  }
}
