import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novel_read/book_list/home_book_item_view.dart';
import 'package:novel_read/book_read_detail/book_read_detail_view.dart';
import 'package:novel_read/model/book.dart';
import 'package:novel_read/model/group.dart';

import 'book_list_controller.dart';

class HomeBookListPage extends StatelessWidget {
  final Group group;

  HomeBookListPage(this.group, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BookListController bookListController = Get.find();
    ColorScheme colorScheme = Get.theme.colorScheme;
    print("HomeBookListPage build");
    var itemPadding = 2.0;

    Set<Book> bookSet = bookListController.getBookListByGroupId(group.id);
    if (bookSet.isEmpty) {
      return const Center(
        child: Text("暂无数据"),
      );
    }
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: colorScheme.onBackground,
      backgroundColor: colorScheme.background,
      child: ListView.builder(
        itemCount: bookSet.length,
        itemBuilder: (context, index) {
          var book = bookSet.elementAt(index);
          return Container(
            padding: EdgeInsets.only(top: itemPadding, bottom: itemPadding),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: HomeBookItemPage(book),
              onTap: () {
                Get.to(() => BookReadDetailPage(book));
              },
              onLongPress: () {
                print("长按");
              },
            ),
          );
        },
      ),
    );
  }
  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(milliseconds: 5000));
    print("下拉刷新 ");
    return;
  }
}
