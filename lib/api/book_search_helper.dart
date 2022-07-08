import 'dart:io';

import 'package:dio/dio.dart';
import 'package:novel_read/dio_utils.dart';
import 'package:novel_read/model/entity/book.dart';
import 'package:novel_read/model/entity/source.dart';
import 'package:novel_read/rule/search_rule.dart';
import 'package:reader_parser2/h_parser/h_eval_parser.dart';
import 'package:reader_parser2/h_parser/h_parser.dart';
import 'package:worker_manager/worker_manager.dart';

class BookSearchHelper {
  final dio = DioUtils.createDioClient();

  searchBookFromEnabledSource(
      List<Source> sourceList, String searchKey, Function onSearch) async {
    var hEvalParser = HEvalParser({'page': 1, 'key': searchKey});

    var searchOptionList = sourceList.map((e) {
      var bean = e.mapSearchUrlBean();
      if (bean == null) {
        return null;
      }
      bean.url = hEvalParser.parse(bean.url);
      bean.body = hEvalParser.parse(bean.body);
      return bean;
    }).toList();
    var searchOption = searchOptionList[0];
    request(searchOption!, onSearch);
  }

  Future<dynamic> request(BookSearchUrlBean options, Function onSearch,
      {Source? source}) async {
    var headers = DioUtils.buildHeaders(
        options.url!, ContentType.html.toString(), options.headers);
    Options requestOptions = Options(
        method: options.method,
        headers: headers,
        sendTimeout: 5000,
        receiveTimeout: 5000,
        followRedirects: true);
    if (options.charset == 'gbk') {
      options.url = UrlGBKEncode().encode(options.url);
      options.body = UrlGBKEncode().encode(options.body);
    }
    requestOptions.responseDecoder = DioUtils.gbkDecoder;
    try {
      dio.options.connectTimeout = 10000;
      print('搜索书籍:$options,$headers');
      var response = await dio
          .request(options.url!, options: requestOptions, data: options.body)
          .timeout(const Duration(seconds: 8));
      if (response.statusCode == 200) {
        print('搜索请求成功[${options.url}]');
        await _parseResponse(response.data, options, onSearch, source: source);
      } else {
        print('搜索错误:书源错误${response.statusCode}');
      }
    } catch (e) {
      //POST导致的302重新处理
      if (e is DioError) {
        var rsp = (e).response;
        if (rsp?.statusCode == 302) {
          var location = rsp?.headers["location"];
          var linkRegexp = RegExp(r'http:.*\/');
          var sep = linkRegexp.stringMatch(options.url!);
          var nUrl = DioUtils.checkLink(sep ?? "", location?[0]);
          print("302 error 重构请求->$nUrl");
          options.url = nUrl;
          options.method = "GET";
          options.body = "";
          return request(options, onSearch);
        }
      }
      print('搜索错误[${options.url}]:$e');
    }

    return Future.value(0);
  }

  dynamic _parseResponse(
      String response, BookSearchUrlBean options, Function onBookSearch,
      {Source? source}) async {
    Source? bookSource;
    int sourceId = -1;
    if (options.sourceId == null) {
      bookSource = source;
    } else {
      bookSource = options.source;
    }

    var tempTime = DateTime.now();
    print('解析搜索返回内容：$sourceId|$tempTime');
    var ruleBean = bookSource!.ruleSearch;
    try {
      //填充需要传输的数据
      var kv = {
        'response': response,
        'baseUrl': options.url,
        'rule_bookList': ruleBean?.bookList,
        'rule_name': ruleBean?.name,
        'rule_author': ruleBean?.author,
        'rule_kind': ruleBean?.kind,
        'rule_intro': ruleBean?.intro,
        'rule_lastChapter': ruleBean?.lastChapter,
        'rule_wordCount': ruleBean?.wordCount,
        'rule_bookUrl': ruleBean?.bookUrl,
        'rule_tocUrl': ruleBean?.tocUrl,
        'rule_coverUrl': ruleBean?.coverUrl,
      };
      print(
          '解析搜索返回内容开始：$sourceId|${DateTime.now().difference(tempTime).inMilliseconds}');
      //用线程池执行解析，大概需要400ms
      var tmp = await Executor().execute(arg1: kv, fun1: _parse);
      print(
          '解析搜索返回内容结束：$sourceId|${DateTime.now().difference(tempTime).inMilliseconds}');
      List<Book> bookInfoList = [];
      for (var t in tmp) {
        bookInfoList.add(Book.fromJson(t));
      }
      print(
          '解析搜索返回内容完成：$sourceId|${DateTime.now().difference(tempTime).inMilliseconds}');
      for (var bookInfo in bookInfoList) {
        //链接修正
        bookInfo.bookUrl = DioUtils.checkLink(options.url!, bookInfo.bookUrl);
        bookInfo.coverUrl = DioUtils.checkLink(options.url!, bookInfo.coverUrl);
        //-------关联到书源-------------
        if (source == null) {
          bookInfo.sourceId = bookSource.id;
          bookInfo.source = bookSource;
          if (bookInfo.name == null || bookInfo.author == null) {
            continue;
          }
          if (bookInfo.bookUrl == null || bookInfo.bookUrl!.isEmpty) {
            continue;
          }
          bookInfo.name = bookInfo.name!.trim();
          bookInfo.author = bookInfo.author!.trim();
          if (options.exactSearch) {
            //精确搜索，要求书名和作者完全匹配
            if (bookInfo.name != options.bookName ||
                bookInfo.author != options.bookAuthor) {
              continue;
            }
          }
        }
        onBookSearch(bookInfo);
      }
    } catch (e) {
      print('搜索解析错误[${source?.bookSourceName},${source?.bookSourceUrl}]:$e');
    }
    return Future.value(0);
  }
}

List<Map<String, dynamic>> _parse(Map map) {
  String response = map['response'];
  SearchRule ruleBean = SearchRule();
  ruleBean.bookList = map['rule_bookList'];
  ruleBean.name = map['rule_name'];
  ruleBean.author = map['rule_author'];
  ruleBean.kind = map['rule_kind'];
  ruleBean.intro = map['rule_intro'];
  ruleBean.lastChapter = map['rule_lastChapter'];
  ruleBean.wordCount = map['rule_wordCount'];
  ruleBean.bookUrl = map['rule_bookUrl'];
  ruleBean.tocUrl = map['rule_tocUrl'];
  ruleBean.coverUrl = map['rule_coverUrl'];

  print("搜索解析规则->[$ruleBean]");

  List<Map<String, dynamic>> result = [{}];

  try {
    var hparser = HParser(response);

    var bId = hparser.parseRuleRaw(ruleBean.bookList!);
    var batchSize = hparser.queryBatchSize(bId);
    for (var i = 0; i < batchSize; i++) {
      var bookInfo = <String, dynamic>{};

      bookInfo["name"] =
          hparser.parseRuleStringForParent(bId, ruleBean.name, i);
      bookInfo["author"] =
          hparser.parseRuleStringForParent(bId, ruleBean.author, i);
      var kinds = hparser.parseRuleStringForParent(bId, ruleBean.kind, i);
      bookInfo["kind"] = kinds == null ? '' : kinds.replaceAll('\n', '|');
      bookInfo["intro"] =
          hparser.parseRuleStringForParent(bId, ruleBean.intro, i);
      bookInfo["lastChapter"] =
          hparser.parseRuleStringForParent(bId, ruleBean.lastChapter, i);
      bookInfo["wordCount"] =
          hparser.parseRuleStringForParent(bId, ruleBean.wordCount, i);
      var url = hparser.parseRuleStringsForParent(bId, ruleBean.bookUrl, i);
      bookInfo["bookUrl"] = url.isNotEmpty ? url[0] : null;
      if (bookInfo["bookUrl"] == null) {
        bookInfo["bookUrl"] =
            hparser.parseRuleStringForParent(bId, ruleBean.tocUrl, i);
      }
      var coverUrl =
          hparser.parseRuleStringsForParent(bId, ruleBean.coverUrl, i);
      bookInfo["coverUrl"] = coverUrl.isNotEmpty ? coverUrl[0] : null;
      if (bookInfo["name"] == null ||
          bookInfo["author"] == null ||
          bookInfo["bookUrl"] == null) {
        continue;
      }
      bookInfo["name"] = bookInfo["name"]!.trim();
      bookInfo["author"] = bookInfo["author"]!.trim();
      if (bookInfo["name"]!.isEmpty ||
          bookInfo["author"]!.isEmpty ||
          bookInfo["bookUrl"]!.isEmpty) {
        continue;
      }
      result.add(bookInfo);
    }

    hparser.destoryBatch(bId);
    hparser.destory();
  } catch (e) {
    print('搜索解析错误:$e');
  }
  return result;
}
