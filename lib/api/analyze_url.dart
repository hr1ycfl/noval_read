import 'dart:convert';
import 'dart:core';

import 'package:dio/dio.dart';
import 'package:novel_read/api/AppPattern.dart';
import 'package:novel_read/api/rule_analyzer.dart';
import 'package:novel_read/api/rule_data_interface.dart';
import 'package:novel_read/dio_utils.dart';
import 'package:novel_read/model/entity/source.dart';
import 'package:novel_read/utils/network_utils.dart';

class AnalyzeUrl {
  late String mUrl;
  String? key;
  int? page;
  String? speakText;
  int? speakSpeed;
  String baseUrl;
  Source? source;

  RuleDataInterface? ruleData;
  Map<String, String>? headerMapF;

  var ruleUrl = "";
  var url = "";
  String? body;
  String? type;
  Map<String, String> headerMap = {};
  String urlNoQuery = "";
  String? queryStr;
  Map<String, String> fieldMap = {};
  String? charset;
  String method = DioUtils.GET;
  String? proxy;
  int retry = 0;
  bool useWebView = false;
  String? webJs;
  bool enabledCookieJar = false;
  bool useJs = false;

  AnalyzeUrl(
    this.mUrl, {
    this.key,
    this.page,
    this.speakSpeed,
    this.speakText,
    this.baseUrl = "",
    this.ruleData,
    this.source,
    this.headerMapF,
  }) {
    if (source != null) {
      enabledCookieJar = source!.enabledCookieJar;
    }

    useJs = AppPattern.JS_PATTERN.hasMatch(ruleUrl);
    if (useJs) {
      print("待支持js");
      return;
    }

    if (!AppPattern.isDataUrl(mUrl)) {
      var firstMatch = AppPattern.paramPattern.firstMatch(baseUrl);
      if (firstMatch != null) {
        baseUrl = baseUrl.substring(0, firstMatch.start);
      }
      Map<String, String>? map =
          headerMapF ?? source?.getHeaderMap(hasLoginHeader: true);
      if (map != null) {
        headerMap.addAll(map);
        if (map.containsKey("proxy")) {
          proxy = map["proxy"];
        }
        headerMap.remove("proxy");
      }
      initUrl();
    }
  }

//   * 处理url
  initUrl() {
    ruleUrl = mUrl;
    //执行@js,<js></js>
    // analyzeJs();
    //替换参数
    replaceKeyPageJs();
    //处理URL
    analyzeUrl();
  }

  analyzeJs() {
    var start = 0;
    String tmp = "";
    var jsAllMatcher = AppPattern.JS_PATTERN.allMatches(ruleUrl);
    for (var jsMatcher in jsAllMatcher) {
      if (jsMatcher.start > start) {
        tmp = ruleUrl.substring(start, jsMatcher.start).trim();
      }
      if (tmp.isNotEmpty) {
        ruleUrl = tmp.replaceFirst("@result", ruleUrl);
      }
      // ruleUrl = evalJS(jsMatcher.group(2) ?: jsMatcher.group(1), ruleUrl) as String
      start = jsMatcher.end;
    }
    if (ruleUrl.length > start) {
      tmp = ruleUrl.substring(start).trim();
      if (tmp.isNotEmpty) {
        ruleUrl = tmp.replaceFirst("@result", ruleUrl);
      }
    }
  }

  getStrResponse(Function onSuccess,
      {String? jsStr, String? sourceRegex, useWebView = true}) async {
    if (useJs) {
      print("待支持js");
      return null;
    }
    if (proxy != null) {
      print("待支持 proxy");
      return null;
    }
    if (this.useWebView && useWebView) {
      print("待支持WebView");
      return null;
    }
    Dio dio = DioUtils.getInstance();
    Response response;
    var dioOptions = Options(headers: headerMap);
    if (method == DioUtils.POST) {
      if (fieldMap.isNotEmpty || (body == null || body!.isEmpty)) {
        var form = FormData.fromMap(fieldMap);
        response = await dio.post(urlNoQuery, data: form, options: dioOptions);
      } else {
        response = await dio.post(urlNoQuery, data: body, options: dioOptions);
      }
    } else {
      print(urlNoQuery);
      response = await dio.get(urlNoQuery,
          queryParameters: fieldMap, options: dioOptions);
    }
    if (response.statusCode == 200) {
      onSuccess(response.data);
    }
  }

  replaceKeyPageJs() {
    if (ruleUrl.contains("{{") && ruleUrl.contains("}}")) {
      var analyze = RuleAnalyzer(ruleUrl);
      var url = analyze.innerRuleStr("{{", "}}", fr: (str) {
        if (str == 'key') {
          return key;
        } else if (str == 'page') {
          return page?.toString();
        }
        return null;
      });
      if (url.isNotEmpty) {
        ruleUrl = url;
      }
    }
    if (page != null) {
      var matchers = AppPattern.pagePattern.allMatches(ruleUrl);
      for (var matcher in matchers) {
        var pages = matcher.group(1)?.split(",") ?? [];
        //pages[pages.size - 1]等同于pages.last()
        if (page! < pages.length) {
          var group = matcher.group(0);
          if (group != null) {
            ruleUrl = ruleUrl.replaceAll(group, pages[page! - 1].trim());
          }
        } else {
          var group = matcher.group(0);
          if (group != null) {
            ruleUrl.replaceAll(group, pages[pages.length - 1].trim());
          }
        }
      }
    }
  }

  analyzeUrl() {
    var urlMatcher = AppPattern.paramPattern.firstMatch(ruleUrl);
    String urlNoOption;
    if (urlMatcher != null) {
      urlNoOption = ruleUrl.substring(0, urlMatcher.start);
    } else {
      urlNoOption = ruleUrl;
    }
    url = NetworkUtils.getAbsoluteURL(baseUrl, urlNoOption);
    var getBaseUrl = NetworkUtils.getBaseUrl(url);
    if (getBaseUrl != null) {
      baseUrl = getBaseUrl;
    }
    if (urlMatcher != null && urlNoOption.length != ruleUrl.length) {
      var option =
          UrlOption.fromJson(json.decode(ruleUrl.substring(urlMatcher.end)));
      if (option.method?.toUpperCase() == DioUtils.POST) {
        method = DioUtils.POST;
      }
      option.headers?.forEach((key, value) {
        headerMap[key] = value.toString();
      });

      if (option.getBody() != null) {
        body = option.getBody();
      }

      type = option.type;
      charset = option.charset;
      retry = option.getRetry();
      useWebView = option.useWebView();
      webJs = option.webJs;
      /*option.getJs()?.let { jsStr ->
        evalJS(jsStr, url)?.toString()?.let {
        url = it
        }
      }*/
    }
    urlNoQuery = url;
    if (method == DioUtils.GET) {
      var pos = url.indexOf('?');
      if (pos != -1) {
        analyzeFields(url.substring(pos + 1));
        urlNoQuery = url.substring(0, pos);
      }
    } else if (method == DioUtils.POST) {
      if (!AppPattern.isJson(body ?? '') &&
          !AppPattern.isXml(body ?? '') &&
          (headerMap["Content-Type"] == null ||
              headerMap["Content-Type"]!.isEmpty)) {
        analyzeFields(body);
      }
    }
  }

  analyzeFields(fieldsTxt) {
    queryStr = fieldsTxt;
    var queryS = fieldsTxt.split("&");
    for (var query in queryS) {
      var queryM = query.split("=");
      var value = queryM.length > 1 ? queryM[1] : "";
      if (charset == null || charset!.isEmpty) {
        fieldMap[queryM[0]] = Uri.encodeFull(value);
      } else {
        fieldMap[queryM[0]] =
            UriData.fromString(value, encoding: Encoding.getByName(charset))
                .toString();
      }
    }
  }
}

class UrlOption {
  String? method;
  String? charset;
  Map<String, dynamic>? headers;
  dynamic body;
  int? retry;
  String? type;
  dynamic webView;
  String? webJs;
  String? js;

  UrlOption(this.method, this.charset, this.headers, this.body, this.retry,
      this.type, this.webView, this.webJs, this.js);

  UrlOption.fromJson(Map<String, dynamic> json) {
    method = json['method'];
    charset = json['charset'];
    headers = json['headers'];
    body = json['body'];
    retry = json['retry'];
    type = json['type'];
    webView = json['webView'];
    webJs = json['webJs'];
    js = json['js'];
  }

  String? getBody() {
    if (body == null) {
      return null;
    }
    if (body is String) {
      return body;
    }
    return json.encode(body);
  }

  int getRetry() {
    return retry ?? 0;
  }

  bool useWebView() {
    switch (webView) {
      case null:
      case "":
      case false:
      case "false":
        return false;
    }
    return true;
  }
}
