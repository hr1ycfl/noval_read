import 'package:flutter/material.dart';
import 'package:novel_read/model/book.dart';

class BookDefaultImgWidget extends StatelessWidget {
  Book book;
  double imgHeight;
  double imgWidth;

  BookDefaultImgWidget(this.book, this.imgWidth, this.imgHeight, {Key? key})
      : super(key: key);

  String convertDisplayName(String name, int subLength) {
    var displayBookName = "";
    List<String> splitBookNameArray = name.split("");

    for (var i = 0; i < splitBookNameArray.length; i++) {
      var str = splitBookNameArray[i];
      if (displayBookName.isNotEmpty && i % subLength == 0) {
        str = '\n' + str;
      }
      displayBookName += str;
    }

    return displayBookName;
  }

  @override
  Widget build(BuildContext context) {
    String displayBookName = convertDisplayName(book.name, 5);
    String displayAuthorName = convertDisplayName(book.author ?? '', 7);

    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          "assets/images/default-book-image.png",
          height: imgHeight,
          width: imgWidth,
        ),
        Positioned(
          top: 10,
          child: Text(
            displayBookName,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
          ),
        ),
        Positioned(
          bottom: 8,
          child: Text(
            displayAuthorName,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 6, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
