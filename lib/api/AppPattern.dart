class AppPattern {
  //dataURL图片类型
  static var dataUriRegex = RegExp("data:.*?;base64,(.*)");

  static var JS_PATTERN =
      RegExp("<js>([\\w\\W]*?)</js>|@js:([\\w\\W]*)", caseSensitive: false);

  static var pagePattern = RegExp("<(.*?)>");

  static var paramPattern = RegExp("\\s*,\\s*(?=\\{)");

  static bool isDataUrl(String? url) {
    if (url == null) {
      return false;
    }
    return dataUriRegex.hasMatch(url);
  }

  static bool isAbsUrl(String url) {
    return url.startsWith("http://") || url.startsWith("https://");
  }

  static bool isJson(String value) {
    var str = value.trim();
    if (str.startsWith("{") && str.endsWith("}")) {
      return true;
    } else if (str.startsWith("[") && str.endsWith("]")) {
      return true;
    }
    return false;
  }

  static bool isXml(String value) {
    var str = value.trim();
    return str.startsWith("<") && str.endsWith(">");
  }
}
