import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novel_read/model/book.dart';

import 'book_read_detail_controller.dart';

class BookReadDetailPage extends StatelessWidget {
  final controller = Get.put(BookReadDetailController());

  Book book;

  BookReadDetailPage(this.book, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(book.name),
    );
  }
}
