class ContentRule {
  String? content;
  String? nextContentUrl;
  String? webJs;
  String? sourceRegex;
  String? replaceRegex; //替换规则
  String? imageStyle; //默认大小居中,FULL最大宽度
  String? payAction; //购买操作,js或者包含{{js}}的url

  ContentRule({
    this.content,
    this.nextContentUrl,
    this.webJs,
    this.sourceRegex,
    this.replaceRegex,
    this.imageStyle,
    this.payAction,
  });

  ContentRule.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    nextContentUrl = json['nextContentUrl'];
    webJs = json['webJs'];
    sourceRegex = json['sourceRegex'];
    replaceRegex = json['replaceRegex'];
    imageStyle = json['imageStyle'];
    payAction = json['payAction'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['content'] = content;
    data['nextContentUrl'] = nextContentUrl;
    data['webJs'] = webJs;
    data['sourceRegex'] = sourceRegex;
    data['replaceRegex'] = replaceRegex;
    data['imageStyle'] = imageStyle;
    data['payAction'] = payAction;
    return data;
  }
}
