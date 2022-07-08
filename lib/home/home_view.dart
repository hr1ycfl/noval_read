import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novel_read/book_list/home_book_list_view.dart';
import 'package:novel_read/group/group_controller.dart';
import 'package:novel_read/group/group_manage_view.dart';
import 'package:novel_read/search/search_view.dart';
import 'package:novel_read/source/source_view.dart';

import 'home_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.find();
    GroupController groupController = Get.find();

    print("HomePage build");
    return Obx(() {
      var groupTabList = groupController.tabList;
      return DefaultTabController(
        initialIndex: homeController.selectGroupIndex.value,
        length: groupTabList.length,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                onPressed: () {
                  Get.to(() => SearchPage());
                },
                icon: const Icon(Icons.search),
              ),
              PopupMenuButton(
                  offset: const Offset(0, 50),
                  icon: const Icon(Icons.more_vert),
                  itemBuilder: (context) {
                    return [
                      const PopupMenuItem<int>(
                        value: 0,
                        child: Text("书架布局"),
                      ),
                      const PopupMenuItem<int>(
                        value: 1,
                        child: Text("分组管理"),
                      ),
                      const PopupMenuItem<int>(
                        value: 2,
                        child: Text("书源管理"),
                      ),
                    ];
                  },
                  onSelected: (value) {
                    if (value == 0) {
                      print("书架布局。");
                    } else if (value == 1) {
                      Get.to(() => GroupManagePage());
                    } else if (value == 2) {
                      Get.to(() => SourcePage());
                    }
                  }),
            ],
            title: TabBar(
              isScrollable: true,
              labelPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              indicatorSize: TabBarIndicatorSize.label,
              tabs: groupTabList.map((group) => Container(
                  height: 30,
                  alignment: Alignment.center,
                  child: Text(
                    group.name,
                  )))
                  .toList(),
            ),
          ),
          body: TabBarView(
            children:
                groupTabList.map((group) => HomeBookListPage(group)).toList(),
          ),
        ),
      );
    });
  }
}
