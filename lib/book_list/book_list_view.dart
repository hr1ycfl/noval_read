import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'book_list_controller.dart';

class BookListPage extends StatelessWidget {
  final controller = Get.put(BookListController());

  BookListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
