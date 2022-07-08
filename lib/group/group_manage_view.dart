import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:novel_read/global.dart';
import 'package:novel_read/group/group_controller.dart';
import 'package:novel_read/model/group.dart';

class GroupManagePage extends StatefulWidget {
  GroupManagePage({Key? key}) : super(key: key);
  final GroupController groupController = Get.find();

  @override
  State<GroupManagePage> createState() => _GroupManagePageState();
}

class _GroupManagePageState extends State<GroupManagePage> {
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Get.theme.colorScheme;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("分组管理"),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Global.showInputConfirm("添加分组", "添加", "分组名称", null,
            (formKey, textController) {
          var form = formKey.currentState;
          //验证 Form表单
          if (form == null || !form.validate()) {
            return;
          }
          String groupName = textController.text;
          widget.groupController.newGroup(groupName);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              '分组[$groupName]添加成功',
              style: TextStyle(color: colorScheme.onPrimary),
            ),
            backgroundColor: colorScheme.primary,
          ));
          Navigator.of(context).pop(true); //关闭对话框
        }, () => Navigator.of(context).pop(true)),
      ),
      body: Obx(() {
        var groupList = widget.groupController.getAllSortGroupList(false);

        return SlidableAutoCloseBehavior(
          child: ReorderableListView(
            physics: const ClampingScrollPhysics(),
            children: <Widget>[
              for (Group group in groupList)
                Slidable(
                  groupTag: "group-manage",
                  key: ValueKey(group),
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(width: 1, color: Colors.grey)),
                    ),
                    child: GestureDetector(
                      onDoubleTap: () => Global.showInputConfirm(
                          "修改分组", "确定", "分组名称", group.name,
                          (formKey, textController) {
                        var form = formKey.currentState;
                        //验证 Form表单
                        if (form == null || !form.validate()) {
                          return;
                        }
                        String groupName = textController.text;
                        if (group.name != groupName) {
                          //调整数据.
                          widget.groupController
                              .updateGroupName(group, groupName);
                        }
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            '分组[$groupName]修改成功',
                            style: TextStyle(color: colorScheme.onPrimary),
                          ),
                          backgroundColor: colorScheme.primary,
                        ));
                        Navigator.of(context).pop(true);
                      }, () => Navigator.of(context).pop(true)),
                      child: ListTile(
                        leading: const Icon(Icons.menu),
                        title: Text(
                          group.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: Switch(
                          value: group.show,
                          activeColor: colorScheme.primary,
                          onChanged: (value) =>
                              widget.groupController.changeGroupShow(group),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 20.0),
                      ),
                    ),
                  ),
                  endActionPane: ActionPane(
                    extentRatio: 0.3,
                    motion: const DrawerMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (actionContext) =>
                            Global.showConfirm("提示", "确定", "是否确定要删除分组？", () {
                          if (group.id < 0) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                '系统分组[${group.name}]不可进行删除',
                                style: TextStyle(color: colorScheme.onPrimary),
                              ),
                              backgroundColor: colorScheme.primary,
                            ));
                            Navigator.of(context).pop(true);
                            return;
                          }
                          widget.groupController.deleteGroup(group);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              '分组[${group.name}]删除成功',
                              style: TextStyle(color: colorScheme.onPrimary),
                            ),
                            backgroundColor: colorScheme.primary,
                          ));
                          Navigator.of(context).pop(true);
                        }, () => Navigator.of(context).pop()),
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: '删除',
                      ),
                    ],
                  ),
                )
            ],
            onReorder: (int oldIndex, int newIndex) => widget.groupController
                .changeGroupOrder(groupList, oldIndex, newIndex),
          ),
        );
      }),
    );
  }
}
