import 'package:get/get.dart';
import 'package:novel_read/api/AppPattern.dart';

class NetworkUtils {
  static String getAbsoluteURL(String? baseURL, String relativePath) {
    if (baseURL == null || baseURL.isEmpty) {
      return relativePath;
    }
    if (AppPattern.isAbsUrl(relativePath)) {
      return relativePath;
    }
    if (AppPattern.dataUriRegex.hasMatch(relativePath)) {
      return relativePath;
    }
    if (relativePath.startsWith("javascript")) {
      return "";
    }
    var relativeUrl = relativePath;
    var baseUrlIndexOf = baseURL.indexOf(",");
    var subBaseUrl =
    baseUrlIndexOf == -1 ? baseURL : baseURL.substring(0, baseUrlIndexOf);
    if (GetUtils.isURL(subBaseUrl + relativePath)) {
      relativeUrl = subBaseUrl + relativePath;
      return relativeUrl;
    }
    return relativeUrl;
  }

  static String? getBaseUrl(String? url) {
    if (url == null) {
      return null;
    }
    if (url.startsWith("http://") || url.startsWith("https://")) {
      var index = url.indexOf("/", 9);
      if (index == -1) {
        return url;
      } else {
        return url.substring(0, index);
      }
    }
    return null;
  }

}
