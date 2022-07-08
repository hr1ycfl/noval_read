import 'package:novel_read/constants/book_constant.dart';

class Book {
  late String name;
  late int id;
  late List<int> group;
  String? author;
  String? imgUrl;
  String? currentChapterTitle;
  int? currentChapterIndex;
  int? totalChapterNum;
  String? latestChapterTitle;
  String? kind;
  int? order;

  Book(this.name, this.id,
      {this.author,
      this.imgUrl,
      this.currentChapterTitle,
      this.currentChapterIndex,
      this.totalChapterNum,
      this.latestChapterTitle,
      this.kind,
      this.group = BookConstant.nullIfDefaultBookGroupList,
      this.order});

  Book.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    author = json['author'];
    imgUrl = json['imgUrl'];
    currentChapterTitle = json['currentChapterTitle'];
    currentChapterIndex = json['currentChapterIndex'];
    totalChapterNum = json['totalChapterNum'];
    latestChapterTitle = json['latestChapterTitle'];
    kind = json['kind'];
    var groupList = json['group'];
    if (groupList != null) {
      group = [];
      for (var i = 0; i < groupList.length; i++) {
        var groupId = groupList[i];
        group.add(groupId);
      }
    } else {
      group = BookConstant.nullIfDefaultBookGroupList;
    }
    id = json['id'];
    order = json['order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = name;
    data['author'] = author;
    data['imgUrl'] = imgUrl;
    data['currentChapterTitle'] = currentChapterTitle;
    data['currentChapterIndex'] = currentChapterIndex;
    data['totalChapterNum'] = totalChapterNum;
    data['latestChapterTitle'] = latestChapterTitle;
    data['kind'] = kind;
    data['group'] = group;
    data['id'] = id;
    data['order'] = order;
    return data;
  }
}
