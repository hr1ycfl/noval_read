import 'package:flutter/material.dart';
import 'package:get/get.dart';

///文本搜索框
class SearchTextFieldWidget extends StatelessWidget {
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTab;
  final String? hintText;
  final EdgeInsetsGeometry? margin;

  const SearchTextFieldWidget(
      {Key? key, this.hintText, this.onSubmitted, this.onTab, this.margin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Get.theme.colorScheme;

    return Container(
      margin: margin ?? const EdgeInsets.all(0.0),
      width: MediaQuery.of(context).size.width,
      alignment: AlignmentDirectional.center,
      height: 37.0,
      decoration: BoxDecoration(
          color: colorScheme.background,
          borderRadius: BorderRadius.circular(24.0)),
      child: TextField(
        onSubmitted: onSubmitted,
        cursorColor: colorScheme.tertiary,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(top: 0.0),
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: TextStyle(fontSize: 17, color: colorScheme.onBackground),
            prefixIcon: Icon(
              Icons.search,
              size: 25,
              color: colorScheme.onBackground,
            )),
        style: TextStyle(fontSize: 17, color: colorScheme.onBackground),
      ),
    );
  }

  getContainer(BuildContext context, ValueChanged<String> onSubmitted) {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: AlignmentDirectional.center,
      height: 40.0,
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 237, 236, 237),
          borderRadius: BorderRadius.circular(24.0)),
      child: TextField(
        onSubmitted: onSubmitted,
        cursorColor: const Color.fromARGB(255, 0, 189, 96),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: const TextStyle(fontSize: 20),
            prefixIcon: const Icon(
              Icons.search,
              size: 29,
              color: Color.fromARGB(255, 128, 128, 128),
            )),
        style: const TextStyle(fontSize: 20),
      ),
    );
  }
}
