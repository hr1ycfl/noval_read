class SearchRule {
  // 校验关键字
  String? checkKeyWord;
  String? bookList;
  String? name;
  String? author;
  String? intro;
  String? kind;
  String? lastChapter;
  String? updateTime;
  String? bookUrl;
  String? coverUrl;
  String? tocUrl;
  String? wordCount;

  SearchRule({
    this.checkKeyWord,
    this.bookList,
    this.name,
    this.author,
    this.intro,
    this.kind,
    this.lastChapter,
    this.updateTime,
    this.bookUrl,
    this.coverUrl,
    this.wordCount,
    this.tocUrl,
  });

  SearchRule.fromJson(Map<String, dynamic> json) {
    checkKeyWord = json['checkKeyWord'];
    bookList = json['bookList'];
    name = json['name'];
    author = json['author'];
    intro = json['intro'];
    kind = json['kind'];
    lastChapter = json['lastChapter'];
    updateTime = json['updateTime'];
    bookUrl = json['bookUrl'];
    coverUrl = json['coverUrl'];
    wordCount = json['wordCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['checkKeyWord'] = checkKeyWord;
    data['bookList'] = bookList;
    data['name'] = name;
    data['author'] = author;
    data['intro'] = intro;
    data['kind'] = kind;
    data['lastChapter'] = lastChapter;
    data['updateTime'] = updateTime;
    data['bookUrl'] = bookUrl;
    data['coverUrl'] = coverUrl;
    data['wordCount'] = wordCount;
    return data;
  }
}
