import 'dart:convert';

import 'package:floor/floor.dart';
import 'package:novel_read/constants/app_constant.dart';
import 'package:novel_read/constants/source_constant.dart';
import 'package:novel_read/dio_utils.dart';
import 'package:novel_read/rule/book_info_rule.dart';
import 'package:novel_read/rule/content_rule.dart';
import 'package:novel_read/rule/explore_rule.dart';
import 'package:novel_read/rule/search_rule.dart';
import 'package:novel_read/rule/toc_rule.dart';

@Entity(tableName: "source")
class Source {
  // 基本信息
  @PrimaryKey(autoGenerate: true)
  int? id;

  // 地址，包括 http/https
  String bookSourceUrl = "";

  // 名称
  String bookSourceName = "";

  // 分组
  String? bookSourceGroup;

  // 类型，0 文本，1 音频，2 图片，3 文件（指的是类似知轩藏书只提供下载的网站）
  int bookSourceType = SourceConstant.novel;

  // 详情页url正则
  String? bookUrlPattern;

  // 手动排序编号
  int customOrder = 0;

  // 是否启用
  bool enabled = true;

  // 启用发现
  bool enabledExplore = true;

  // 启用okhttp CookieJAr 自动保存每次请求的cookie
  bool enabledCookieJar = false;

  // 并发率
  String? concurrentRate;

  // 请求头
  String? header;

  // 登录地址
  String? loginUrl;

  // 登录UI
  String? loginUi;

  // 登录检测js
  String? loginCheckJs;

  // 注释
  String? bookSourceComment;

  // 最后更新时间，用于排序
  var lastUpdateTime = 0;

  // 响应时间，用于排序
  var respondTime = 180000;

  // 智能排序的权重
  int weight = 0;

  // 发现url
  String? exploreUrl;

  // 发现规则
  ExploreRule? ruleExplore;

  // 搜索url
  String? searchUrl;

  // 搜索规则
  SearchRule? ruleSearch;

  // 书籍信息页规则
  BookInfoRule? ruleBookInfo;

  // 目录页规则
  TocRule? ruleToc;

  // 正文页规则
  ContentRule? ruleContent;

  Source(
    this.id,
    this.bookSourceName,
    this.bookSourceComment,
    this.bookSourceGroup,
    this.bookSourceType,
    this.bookSourceUrl,
    this.customOrder,
    this.enabled,
    this.enabledExplore,
    this.exploreUrl,
    this.lastUpdateTime,
    this.respondTime,
    this.ruleToc,
    this.ruleBookInfo,
    this.ruleContent,
    this.ruleExplore,
    this.ruleSearch,
    this.searchUrl,
    this.weight,
  );

  String getKey() {
    return bookSourceUrl;
  }

  Source.fromJson(Map<String, dynamic> json) {
    bookSourceComment = json['bookSourceComment'];
    bookSourceGroup = json['bookSourceGroup'];
    bookSourceName = json['bookSourceName'];
    bookSourceType = json['bookSourceType'];
    bookSourceUrl = json['bookSourceUrl'];
    customOrder = json['customOrder'];
    enabled = json['enabled'];
    enabledExplore = json['enabledExplore'];
    exploreUrl = json['exploreUrl'];
    lastUpdateTime = json['lastUpdateTime'];
    respondTime = json['respondTime'];
    ruleBookInfo = json['ruleBookInfo'] != null
        ? BookInfoRule.fromJson(json['ruleBookInfo'])
        : null;
    ruleContent = json['ruleContent'] != null
        ? ContentRule.fromJson(json['ruleContent'])
        : null;
    ruleExplore = json['ruleExplore'] != null
        ? ExploreRule.fromJson(json['ruleExplore'])
        : null;
    ruleSearch = json['ruleSearch'] != null
        ? SearchRule.fromJson(json['ruleSearch'])
        : null;
    ruleToc =
        json['ruleToc'] != null ? TocRule.fromJson(json['ruleToc']) : null;
    searchUrl = json['searchUrl'];
    weight = json['weight'];
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['bookSourceName'] = bookSourceName;
    data['bookSourceComment'] = bookSourceComment;
    data['bookSourceGroup'] = bookSourceGroup;
    data['bookSourceType'] = bookSourceType;
    data['bookSourceUrl'] = bookSourceUrl;
    data['customOrder'] = customOrder;
    data['enabled'] = enabled;
    data['enabledExplore'] = enabledExplore;
    data['exploreUrl'] = exploreUrl;
    data['lastUpdateTime'] = lastUpdateTime;
    data['respondTime'] = respondTime;
    data['ruleBookInfo'] = ruleBookInfo != null ? ruleBookInfo!.toJson() : null;
    data['ruleContent'] = ruleContent != null ? ruleContent!.toJson() : null;
    data['ruleExplore'] = ruleExplore != null ? ruleExplore!.toJson() : null;
    data['ruleSearch'] = ruleSearch != null ? ruleSearch!.toJson() : null;
    data['ruleToc'] = ruleToc != null ? ruleToc!.toJson() : null;
    data['searchUrl'] = searchUrl;
    data['weight'] = weight;
    return data;
  }



  Map<String, String> getHeaderMap({hasLoginHeader = false}) {
    Map<String, String> map = {};
    map[AppConst.UA_NAME] = AppConst.UA_VALUE;
    if (header != null) {
      Map<String, String> headerMap = json.decode(header!);
      headerMap.forEach((key, value) {
        if (value.startsWith("@js:")) {
          // evalJS(it.substring(4)).toString()
        } else if (value.startsWith("<js>")) {
          // evalJS(it.substring(4, it.lastIndexOf("<"))).toString()
        } else {
          map[key] = value;
        }
      });
    }
    if (hasLoginHeader) {
      /*getLoginHeaderMap()?.let {
        putAll(it)
      }*/
    }
    return map;
  }

  BookSearchUrlBean? mapSearchUrlBean() {
    if (searchUrl == null || searchUrl!.isEmpty) {
      return null;
    }
    var bean = BookSearchUrlBean();
    bean.sourceId = id;
    bean.source = this;
    var index = searchUrl!.indexOf(',');
    var temp = [searchUrl];
    if (index > 0) {
      temp[0] = searchUrl!.substring(0, index);
      temp.add(searchUrl!.substring(index + 1));
    }
    bean.url = temp[0];
    if (!bean.url!.startsWith('http')) {
      bean.url = bookSourceUrl + bean.url!;
    }
    bean.method = 'GET';
    bean.charset = 'utf8';
    bean.headers = {};

    if (temp.length == 2) {
      Map<String, dynamic> map;
      var trans = temp[1]!;
      var needTrans = trans.contains("'method'");
      try {
        if (needTrans) {
          //单引号
          trans = trans.replaceAll("\"", "^");
          trans = trans.replaceAll("'", "\"");
        }
        map = json.decode(trans); //有些奇怪的会用单引号
      } catch (e) {
        print("book source map search error->$e");
        return null;
      }
      bean.method = map['method'] ?? DioUtils.GET;
      try {
        var headerStr = map['headers'] as String?;
        if (needTrans) {
          headerStr = headerStr?.replaceAll("^", "\"");
        }
        bean.headers = headerStr == null ? {} : json.decode(headerStr);
        if (bean.method == 'POST' && bean.headers!.isEmpty) {
          bean.headers = {'content-type': r"application/x-www-form-urlencoded"};
        }
      } catch (e) {
        //pass 有些headers没有双引号，不兼容
        print("book source map headers error->$e");
      }
      var bodyStr = map['body'] as String?;
      if (needTrans) {
        bodyStr = bodyStr?.replaceAll("^", "\"");
      }
      bean.body = bodyStr;
      bean.charset = map['charset'] ?? 'utf8';
      if (bean.charset!.startsWith('gb')) {
        bean.charset = 'gbk';
      } else {
        bean.charset = 'utf8';
      }
    }
    return bean;
  }
}

class BookSearchUrlBean {
  String? url;
  Map<String, String>? headers;
  String? method;
  String? body;
  String? charset;
  int? sourceId = -1;
  Source? source;

  //参数
  bool exactSearch = false;
  String? bookName;
  String? bookAuthor;

  @override
  String toString() {
    return 'BookSearchUrlBean{url: $url, headers: $headers, method: $method, body: $body, charset: $charset}';
  } //gbk gb2312,utf8

}
