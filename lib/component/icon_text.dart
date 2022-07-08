import 'package:flutter/material.dart';

class IconText extends StatelessWidget {
  final String text;
  final IconData icon;

  final TextStyle? style;
  final double? iconSize;
  final int? maxLines;
  final TextOverflow overflow;

  const IconText(this.text, this.icon,
      {Key? key,
      this.iconSize,
      this.style,
      this.maxLines,
      this.overflow = TextOverflow.ellipsis})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(style: style, children: [
          WidgetSpan(child: Container(
            padding: const EdgeInsets.only(right: 4.0, bottom: 0.8),
            child: Icon(
              icon,
              size: iconSize ?? style?.fontSize,
              color: style?.color,
            ),
          )),
          TextSpan(text: text),
        ]),
        maxLines: maxLines,
        overflow: overflow);
  }
}
