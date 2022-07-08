class BookInfoRule {
  String? init;
  String? name;
  String? author;
  String? intro;
  String? kind;
  String? lastChapter;
  String? updateTime;
  String? coverUrl;
  String? tocUrl;
  String? wordCount;
  String? canReName;
  String? downloadUrls;

  BookInfoRule({
    this.init,
    this.name,
    this.author,
    this.intro,
    this.kind,
    this.lastChapter,
    this.updateTime,
    this.coverUrl,
    this.tocUrl,
    this.wordCount,
    this.canReName,
    this.downloadUrls,
  });

  BookInfoRule.fromJson(Map<String, dynamic> json) {
    author = json['author'];
    coverUrl = json['coverUrl'];
    init = json['init'];
    intro = json['intro'];
    kind = json['kind'];
    lastChapter = json['lastChapter'];
    name = json['name'];
    tocUrl = json['tocUrl'];
    wordCount = json['wordCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['author'] = author;
    data['coverUrl'] = coverUrl;
    data['init'] = init;
    data['intro'] = intro;
    data['kind'] = kind;
    data['lastChapter'] = lastChapter;
    data['name'] = name;
    data['tocUrl'] = tocUrl;
    data['wordCount'] = wordCount;
    return data;
  }
}
