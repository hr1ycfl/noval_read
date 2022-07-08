class RuleAnalyzer {
  static var ESC = '\\';

  bool code;
  String data;

  //被处理字符串
  late String queue;

  //当前处理到的位置
  var pos = 0;

  //当前处理字段的开始
  var start = 0;

  //当前规则的开始
  var startX = 0;

  //分割出的规则列表
  List<String> rule = [];

  //分割字符的长度
  int step = 0;

  //当前分割字符串
  var elementsType = "";

  RuleAnalyzer(this.data, {this.code = false}) {
    queue = data;
  }

  trim() {
    // 修剪当前规则之前的"@"或者空白符
    //在while里重复设置start和startX会拖慢执行速度，所以先来个判断是否存在需要修剪的字段，最后再一次性设置start和startX
    if (queue[pos] == '@' || queue[pos] == ' ') {
      pos++;
      while (queue[pos] == '@' || queue[pos] == ' ') {
        pos++;
      }
      //开始点推移
      start = pos;
      //规则起始点推移
      startX = pos;
    }
  }

  reSetPos() {
    pos = 0;
    startX = 0;
  }

  bool consumeTo(String seq) {
    //将处理到的位置设置为规则起点
    start = pos;
    var offset = queue.indexOf(seq, pos);
    if (offset != -1) {
      pos = offset;
      return true;
    }
    return false;
  }

  bool consumeToAny(List<String> seq) {
    //声明新变量记录匹配位置，不更改类本身的位置
    var varPos = pos;

    while (varPos != queue.length) {
      for (var s in seq) {
        if (queue.length > (varPos + s.length) ? queue.substring(
            varPos, (varPos + s.length)) == s : false) {
          //间隔数
          step = s.length;
          //匹配成功, 同步处理位置到类
          pos = varPos;
          //匹配就返回 true
          return true;
        }
      }
      //逐个试探
      varPos++;
    }
    return false;
  }

  int findToAny(List<String> seq) {
    //声明新变量记录匹配位置，不更改类本身的位置;
    var varPos = pos;

    while (varPos != queue.length) {
      for (var s in seq) {
        if (queue[varPos] == s) {
          //匹配则返回位置
          return varPos;
        }
      }

      //逐个试探
      varPos++;
    }

    return -1;
  }

  bool chompCodeBalanced(String open, String close) {
    var varPos = pos; //声明临时变量记录匹配位置，匹配成功后才同步到类的pos

    var depth = 0; //嵌套深度
    var otherDepth = 0; //其他对称符合嵌套深度

    var inSingleQuote = false; //单引号
    var inDoubleQuote = false; //双引号

    do {
      if (varPos == queue.length) {
        break;
      }
      var c = queue[varPos++];
      if (c != ESC) { //非转义字符
        if (c == '\'' && !inDoubleQuote) {
          inSingleQuote = !inSingleQuote;
        } else if (c == '"' && !inSingleQuote) {
          inDoubleQuote = !inDoubleQuote;
        } //匹配具有语法功能的双引号

        if (inSingleQuote || inDoubleQuote) continue; //语法单元未匹配结束，直接进入下个循环

        if (c == '[') {
          depth++;
        } else if (c == ']') {
          depth--;
        } else if (depth == 0) {
          //处于默认嵌套中的非默认字符不需要平衡，仅depth为0时默认嵌套全部闭合，此字符才进行嵌套
          if (c == open) {
            otherDepth++;
          } else if (c == close) {
            otherDepth--;
          }
        }
      } else {
        varPos++;
      }
    } while (depth > 0 || otherDepth > 0); //拉出一个平衡字串
    if (depth > 0 || otherDepth > 0) {
      return false;
    }

    pos = varPos; //同步位置
    return true;
  }


  bool chompRuleBalanced(String open, String close) {
    var varPos = pos; //声明临时变量记录匹配位置，匹配成功后才同步到类的pos
    var depth = 0; //嵌套深度
    var inSingleQuote = false; //单引号
    var inDoubleQuote = false; //双引号

    do {
      if (varPos == queue.length) break;
      var c = queue[varPos++];
      if (c == '\'' && !inDoubleQuote) {
        inSingleQuote = !inSingleQuote;
      } else if (c == '"' && !inSingleQuote) {
        inDoubleQuote = !inDoubleQuote;
      } //匹配具有语法功能的双引号

      if (inSingleQuote || inDoubleQuote) {
        continue;
      } else if (c == '\\') { //不在引号中的转义字符才将下个字符转义
        varPos++;
        continue;
      }

      if (c == open) {
        depth++;
      } else if (c == close) {
        depth--;
      } //闭合一层嵌套

    } while (depth > 0); //拉出一个平衡字串

    if (depth > 0) return false;
    pos = varPos; //同步位置
    return true;
  }

  List<String> splitRule(List<String> split) {
    if (split.length == 1) {
      elementsType = split[0]; //设置分割字串
      if (!consumeTo(elementsType)) {
        rule.add(queue.substring(startX));
        return rule;
      } else {
        step = elementsType.length; //设置分隔符长度
        return splitRuleNoArg();
      } //递归匹配
    } else if (!consumeToAny(split)) { //未找到分隔符
      rule.add(queue.substring(startX));
      return rule;
    }

    var end = pos; //记录分隔位置
    pos = start; //重回开始，启动另一种查找

    do {
      var st = findToAny(['[', '(']); //查找筛选器位置

      if (st == -1) {
        rule = [queue.substring(startX, end)]; //压入分隔的首段规则到数组

        elementsType = queue.substring(end, end + step); //设置组合类型
        pos = end + step; //跳过分隔符

        while (consumeTo(elementsType)) { //循环切分规则压入数组
          rule.add(queue.substring(start, pos));
          pos += step; //跳过分隔符
        }

        rule.add(queue.substring(pos)); //将剩余字段压入数组末尾

        return rule;
      }

      if (st > end) { //先匹配到st1pos，表明分隔字串不在选择器中，将选择器前分隔字串分隔的字段依次压入数组

        rule = [queue.substring(startX, end)]; //压入分隔的首段规则到数组

        elementsType = queue.substring(end, end + step); //设置组合类型
        pos = end + step; //跳过分隔符

        while (consumeTo(elementsType) && pos < st) { //循环切分规则压入数组
          rule.add(queue.substring(start, pos));
          pos += step; //跳过分隔符
        }

        if (pos > st) {
          startX = start;
          return splitRuleNoArg(); //首段已匹配,但当前段匹配未完成,调用二段匹配
        } else { //执行到此，证明后面再无分隔字符
          rule.add(queue.substring(pos)); //将剩余字段压入数组末尾
          return rule;
        }
      }

      pos = st; //位置推移到筛选器处
      var next = queue[pos] == '[' ? ']' : ')'; //平衡组末尾字符
      bool result;
      if (code) {
        result = chompCodeBalanced(queue[pos], next);
      } else {
        result = chompRuleBalanced(queue[pos], next);
      }
      if (!result) {
        throw Exception(queue.substring(0, start) + "后未平衡");
      }
    } while (end > pos);

    start = pos; //设置开始查找筛选器位置的起始位置

    return splitRule(split); //递归调用首段匹配
  }

  List<String> splitRuleNoArg() {
    var end = pos; //记录分隔位置
    pos = start; //重回开始，启动另一种查找

    do {
      var st = findToAny(['[', '(']); //查找筛选器位置

      if (st == -1) {
        rule.add(queue.substring(startX, end)); //压入分隔的首段规则到数组
        pos = end + step; //跳过分隔符

        while (consumeTo(elementsType)) { //循环切分规则压入数组
          rule.add(queue.substring(start, pos));
          pos += step; //跳过分隔符
        }

        rule.add(queue.substring(pos)); //将剩余字段压入数组末尾

        return rule;
      }

      if (st > end) { //先匹配到st1pos，表明分隔字串不在选择器中，将选择器前分隔字串分隔的字段依次压入数组

        rule.add(queue.substring(startX, end)); //压入分隔的首段规则到数组
        pos = end + step; //跳过分隔符

        while (consumeTo(elementsType) && pos < st) { //循环切分规则压入数组
          rule.add(queue.substring(start, pos));
          pos += step; //跳过分隔符
        }

        if (pos > st) {
          startX = start;
          return splitRuleNoArg(); //首段已匹配,但当前段匹配未完成,调用二段匹配
        } else { //执行到此，证明后面再无分隔字符
          rule.add(queue.substring(pos)); //将剩余字段压入数组末尾
          return rule;
        }
      }

      pos = st; //位置推移到筛选器处
      var next = queue[pos] == '[' ? ']' : ')'; //平衡组末尾字符

      bool result;
      if (code) {
        result = chompCodeBalanced(queue[pos], next);
      } else {
        result = chompRuleBalanced(queue[pos], next);
      }
      if (!result) {
        throw Exception(queue.substring(0, start) + "后未平衡");
      }
    } while (end > pos);

    start = pos; //设置开始查找筛选器位置的起始位置

    if (!consumeTo(elementsType)) {
      rule.add(queue.substring(startX));
      return rule;
    }
    return splitRuleNoArg(); //递归匹配
  }

  String innerRule(String inner,
      { startStep = 1, endStep = 1, String? Function(String e)? fr}) {
    var sb = StringBuffer();

    while (consumeTo(
        inner)) { //拉取成功返回true，ruleAnalyzes里的字符序列索引变量pos后移相应位置，否则返回false,且isEmpty为true
      var posPre = pos; //记录consumeTo匹配位置
      if (chompCodeBalanced('{', '}')) {
        var substring = queue.substring(
            (posPre + startStep).toInt(), (pos - endStep).toInt());
        var frv = fr == null ? null : fr(substring);
        if (frv != null && frv.isNotEmpty) {
          sb.write(queue.substring(startX, posPre) +
              frv); //压入内嵌规则前的内容，及内嵌规则解析得到的字符串
          startX = pos; //记录下次规则起点
          continue; //获取内容成功，继续选择下个内嵌规则
        }
      }
      pos += inner.length; //拉出字段不平衡，inner只是个普通字串，跳到此inner后继续匹配
    }

    if (startX == 0) {
      return "";
    }
    sb.write(queue.substring(startX));
    return sb.toString();
  }

  String innerRuleStr(String startStr, String endStr,
      {String? Function(String e)? fr}) {
    var st = StringBuffer();
    while (consumeTo(
        startStr)) { //拉取成功返回true，ruleAnalyzes里的字符序列索引变量pos后移相应位置，否则返回false,且isEmpty为true
      pos += startStr.length; //跳过开始字符串
      var posPre = pos; //记录consumeTo匹配位置
      if (consumeTo(endStr)) {
        var frv = fr == null ? null : fr(queue.substring(posPre, pos));
        st.write(queue.substring(startX, posPre - startStr.length) +
            (frv ?? '')); //压入内嵌规则前的内容，及内嵌规则解析得到的字符串
        pos += endStr.length; //跳过结束字符串
        startX = pos; //记录下次规则起点
      }
    }

    if (startX == 0) return queue;
    st.write(queue.substring(startX));
    return st.toString();
  }


}
