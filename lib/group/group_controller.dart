import 'dart:convert';

import 'package:get/get.dart';
import 'package:novel_read/constants/group_constant.dart';
import 'package:novel_read/global.dart';
import 'package:novel_read/model/group.dart';

class GroupController extends GetxController {
  var lastId = -99999;
  var lastOrder = -99999;
  var allGroupMap = {}.obs;
  List<Group> tabList = <Group>[].obs;

  @override
  void onInit() {
    interval(allGroupMap, (callback) {
      List<Group> groupList = [];
      for(Group group in allGroupMap.values) {
        groupList.add(group);
      }
      var encodeGroupJson = json.encode(groupList);
      Global.prefs.setString("group-list", encodeGroupJson);
    });
    debounce(allGroupMap, (callback) => setTabList());
    super.onInit();
  }

  init() async {
    var groupListStr = Global.prefs.getString("group-list");
    if (groupListStr == null) {
      addGroupToAll(Group(
          GroupConstant.allBooKGroupId, GroupConstant.allBooKGroupName,
          order: 1));
      addGroupToAll(Group(GroupConstant.unclassifiedGroupId,
          GroupConstant.unclassifiedGroupName,
          order: 2));
    } else {
/*    String jsonData =
        await rootBundle.loadString("assets/data/group-list.json");*/
      List<dynamic> groupJsonStrList = json.decode(groupListStr);
      for (var value in groupJsonStrList) {
        addGroupToAll((Group.fromJson(value)));
      }
    }
  }

  addGroupToAll(Group group) {
    var groupId = group.id;
    if (groupId > lastId) {
      lastId = groupId;
    }
    var groupOrder = group.order;
    if (groupOrder > lastOrder) {
      lastOrder = groupOrder;
    }
    allGroupMap[groupId] = group;
  }

  setTabList() {
    List<Group> groupList = getAllSortGroupList(true);
    tabList.clear();
    tabList.addAll(groupList);
  }

  List<Group> getAllSortGroupList(bool filterShow) {
    List<Group> groupList = [];
    for (var value in allGroupMap.values) {
      if (!filterShow) {
        groupList.add(value);
      } else if (value.show) {
        groupList.add(value);
      }
    }

    groupList.sort((left, right) => left.order.compareTo(right.order));
    return groupList;
  }

  newGroup(String groupName) {
    var id = lastId + 1;
    if (id <= 0) {
      id = 1;
    }
    var groupOrder = lastOrder + 1;
    if (groupOrder <= 0) {
      groupOrder = 1;
    }

    Group group = Group(id, groupName, order: groupOrder);
    addGroupToAll(group);
  }

  changeGroupShow(Group group) {
    group.show = !group.show;
    allGroupMap[group.id] = group;
  }

  updateGroupName(Group group, String newGroupName) {
    group.name = newGroupName;
    allGroupMap[group.id] = group;
  }

  deleteGroup(Group group) {
    allGroupMap.remove(group.id);
  }

  changeGroupOrder(List<Group> groupList, int oldIndex, int newIndex) {
    if (oldIndex == newIndex) {
      return;
    }
    List<Group> updateOrderGroupList = [];
    if (oldIndex < newIndex) {
      var endIndex = newIndex - 1;
      for (var i = endIndex; i >= oldIndex; i--) {
        Group nowGroup = groupList[i];
        int offset = i - 1;
        if (i == oldIndex) {
          offset = endIndex;
        }
        Group nextGroup = groupList[offset];
        Group newGroup = nowGroup.copy();
        newGroup.order = nextGroup.order;
        updateOrderGroupList.add(newGroup);
      }
    } else {
      for (var i = newIndex; i <= oldIndex; i++) {
        Group nowGroup = groupList[i];
        int offset = i + 1;
        if (i == oldIndex) {
          offset = newIndex;
        }
        Group nextGroup = groupList[offset];
        Group newGroup = nowGroup.copy();
        newGroup.order = nextGroup.order;
        updateOrderGroupList.add(newGroup);
      }
    }

    for (var group in updateOrderGroupList) {
      allGroupMap[group.id] = group;
    }
  }
}
