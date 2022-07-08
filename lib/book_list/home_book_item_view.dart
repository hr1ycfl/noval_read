import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novel_read/book/book_default_img_view.dart';
import 'package:novel_read/component/icon_text.dart';
import 'package:novel_read/model/book.dart';

import '../theme.dart';

class HomeBookItemPage extends StatelessWidget {
  Book book;

  HomeBookItemPage(this.book, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double imgWidth = 60;
    double imgHeight = 80;

    var itemPadding = 4.0;
    ColorScheme colorScheme = Get.theme.colorScheme;
    int totalChapterNum = book.totalChapterNum ?? 0;
    int currentChapterIndex = book.currentChapterIndex ?? 0;

    var remainingNum = totalChapterNum - currentChapterIndex;
    var remainingNumChar = "$remainingNum";
    if (remainingNum < 0) {
      remainingNumChar = '0';
    }
    var bookDefaultImgWidget = BookDefaultImgWidget(book, imgWidth, imgHeight);
    return Container(
      padding: EdgeInsets.only(
          left: itemPadding, top: itemPadding, bottom: itemPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Card(
            child: CachedNetworkImage(
              imageUrl: book.imgUrl ?? '',
              placeholder: (context, url) {
                return bookDefaultImgWidget;
              },
              errorWidget: (context, url, error) {
                return bookDefaultImgWidget;
              },
              fit: BoxFit.cover,
              height: imgHeight,
              width: imgWidth,
            ),
            clipBehavior: Clip.antiAlias,
            elevation: 5.0,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(3.0))),
          ),
          const Padding(
            padding: EdgeInsets.all(5.0),
          ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 3.0, top: 2.0),
                        child: Text(book.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: getStyle(colorScheme.onBackground, 15.0,
                                bold: true)),
                      ),
                    ),
                    Badge(
                      toAnimate: true,
                      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                      shape: BadgeShape.square,
                      badgeColor: colorScheme.primary,
                      borderRadius: BorderRadius.circular(20),
                      badgeContent: Text(remainingNumChar,
                          style: TextStyle(color: colorScheme.onPrimary)),
                    ),
                    const Padding(padding: EdgeInsets.all(5))
                  ],
                ),
                IconText(book.author ?? '', Icons.account_circle_outlined,
                    iconSize: 13,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getStyle(
                      colorScheme.outline,
                      13.0,
                    )),
                IconText(
                    book.currentChapterTitle ?? '', Icons.watch_later_outlined,
                    iconSize: 13,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getStyle(colorScheme.outline, 13.0)),
                IconText(
                    book.latestChapterTitle ?? '', Icons.explore_outlined,
                    maxLines: 1,
                    iconSize: 13,
                    overflow: TextOverflow.ellipsis,
                    style: getStyle(colorScheme.outline, 13.0)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TextStyle getStyle(Color color, double fontSize, {bool bold = false}) {
    return TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal);
  }
}
