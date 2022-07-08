import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novel_read/component/search_text_field_widget.dart';
import 'package:novel_read/dio_utils.dart';
import 'package:novel_read/global.dart';
import 'package:novel_read/model/entity/source.dart';

import 'source_controller.dart';

class SourcePage extends StatelessWidget {
  SourcePage({Key? key}) : super(key: key);

  final controller = Get.put(SourceController());
  final String hintText = '输入书源名称搜索书源';

  @override
  Widget build(BuildContext context) {
    controller.searchDb(null);
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: false,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: IconButton(
                onPressed: () => Global.showInputConfirm(
                    "输入书源地址",
                    "确定",
                    "书源地址",
                    null,
                    (formKey, textController) async {
                      var formState = formKey.currentState;
                      //验证 Form表单
                      if (formState == null || !formState.validate()) {
                        return;
                      }
                      Navigator.of(context).pop(true);
                      String link = textController.text;
                      Global.showLoading(loadingText: "读取中");
                      try {
                        DioUtils.getHttp(link, onSuccess: (data) async {
                          Navigator.of(context).pop(true);
                          Global.showLoading(loadingText: "解析中");
                          List<dynamic> decodeSourceList = json.decode(data);
                          List<Source> sourceList = [];
                          for (var decodeSource in decodeSourceList) {
                            sourceList.add(Source.fromJson(decodeSource));
                          }
                          Navigator.of(context).pop(true);
                          Global.showLoading(loadingText: "导入中");
                          await Global.sourceDao
                              .insertOrUpdateRules(sourceList);
                          await controller.searchDb(null);
                          Navigator.of(context).pop(true);
                        });
                      } catch (e) {
                        Navigator.of(context).pop(true);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          duration: const Duration(minutes: 5),
                          content: Text(
                            '\n\n\n书源导入异常,书源地址：【$link】\n\n异常错误信息：$e',
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.red,
                        ));
                        return;
                      }
                    },
                    () => Navigator.of(context).pop(true),
                    validator: (value) {
                      if (!GetUtils.isURL(value)) {
                        return "请输入http链接地址";
                      }
                      return null;
                    }),
                icon: const Icon(
                  Icons.add_link_outlined,
                ),
              ),
            ),
          ],
          title: SearchTextFieldWidget(
              hintText: hintText,
              onSubmitted: (searchContent) {
                controller.searchDb(searchContent);
              }),
        ),
        body: Obx(() {
          return ListView.builder(
              physics: const ClampingScrollPhysics(),
              itemCount: controller.sourceList.length,
              itemBuilder: (itemContext, index) {
                Source source = controller.sourceList[index];
                return ListTile(
                  title: Text(source.bookSourceName),
                  trailing: Switch(
                    value: source.enabled,
                    onChanged: (value) => print(value),
                  ),
                );
              });
        }));
  }
}
