import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novel_read/api/book_search_helper.dart';
import 'package:novel_read/component/search_text_field_widget.dart';
import 'package:novel_read/model/entity/source.dart';
import 'package:novel_read/source/source_controller.dart';

import 'search_controller.dart';

class SearchPage extends StatelessWidget {
  final controller = Get.put(SearchController());
  final sourceController = Get.put(SourceController());
  final bookSearchHelper = BookSearchHelper();

  SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: SearchTextFieldWidget(
            hintText: "输入关键字搜索书籍",
            onSubmitted: (searchKey) => _searchBookList(searchKey),
          )),
      body: Obx(() {
        var searchItemList = controller.searchItemList;
        if (searchItemList.isEmpty && controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return const Center(
            child: Text("测试"),
          );
        }
      }),
    );
  }

  _searchBookList(String searchKey) async {
    controller.isLoading.value = true;
    List<Source> enabledSourceList =
        await sourceController.getEnabledSourceList();
    bookSearchHelper.searchBookFromEnabledSource(
        enabledSourceList, searchKey, (book) {
          print(book.name);

    });

    await Future.delayed(const Duration(milliseconds: 5000));
    controller.isLoading.value = false;
  }
}
