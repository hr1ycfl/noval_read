class TocRule {
  String? chapterList;
  String? chapterName;
  String? chapterUrl;
  String? isVolume;
  String? isVip;
  String? isPay;
  String? updateTime;
  String? nextTocUrl;

  TocRule({
    this.chapterList,
    this.chapterName,
    this.chapterUrl,
    this.isVolume,
    this.isVip,
    this.isPay,
    this.updateTime,
    this.nextTocUrl,
  });

  TocRule.fromJson(Map<String, dynamic> json) {
    chapterList = json['chapterList'];
    chapterName = json['chapterName'];
    chapterUrl = json['chapterUrl'];
    isVolume = json['isVolume'];
    isVip = json['isVip'];
    isPay = json['isPay'];
    updateTime = json['updateTime'];
    nextTocUrl = json['nextTocUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['chapterList'] = chapterList;
    data['chapterName'] = chapterName;
    data['chapterUrl'] = chapterUrl;
    data['isVolume'] = isVolume;
    data['isVip'] = isVip;
    data['isPay'] = isPay;
    data['updateTime'] = updateTime;
    data['nextTocUrl'] = nextTocUrl;
    return data;
  }
}
