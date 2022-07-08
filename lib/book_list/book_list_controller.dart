import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:novel_read/constants/group_constant.dart';
import 'package:novel_read/model/book.dart';
import 'package:novel_read/model/group.dart';

class BookListController extends GetxController {
  Map<int, List<Book>> groupBookMap = <int, List<Book>>{}.obs;

  init() async {
    Map<int, List<Book>> map = {};
    String jsonData = await rootBundle.loadString("assets/data/book-list.json");
    List<dynamic> bookJsonStrList = json.decode(jsonData);
    for (var value in bookJsonStrList) {
      var book = Book.fromJson(value);
      List<int> group = book.group;
      for (var i = 0; i < group.length; i++) {
        var groupId = group[i];
        List<Book> bookList = map[groupId] ?? [];
        bookList.add(book);
        map[groupId] = bookList;
      }
    }
    groupBookMap = map;
  }

  Set<Book> getBookListByGroupId(int groupId) {
    Set<Book> bookSet = {};
    if (GroupConstant.allBooKGroupId == groupId) {
      Iterable<List<Book>> allBookList = groupBookMap.values;
      for (List<Book> element in allBookList) {
        bookSet.addAll(element);
      }
      return bookSet;
    }

    bookSet.addAll(groupBookMap[groupId] ?? []);
    return bookSet;
  }

}
