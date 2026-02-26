/// 诗词数据库
class PoemDatabase {
  /// 根据天气状况获取诗词
  static PoemData getPoemByWeather(String weatherCondition) {
    final condition = weatherCondition.toLowerCase();
    
    // 雨天诗词
    if (condition.contains('雨') || condition.contains('rain')) {
      return _rainPoems[DateTime.now().millisecond % _rainPoems.length];
    }
    
    // 雪天诗词
    if (condition.contains('雪') || condition.contains('snow')) {
      return _snowPoems[DateTime.now().millisecond % _snowPoems.length];
    }
    
    // 晴天诗词
    if (condition.contains('晴') || condition.contains('sunny') || condition.contains('clear')) {
      return _sunnyPoems[DateTime.now().millisecond % _sunnyPoems.length];
    }
    
    // 云/阴天诗词
    if (condition.contains('云') || condition.contains('阴') || 
        condition.contains('cloud') || condition.contains('overcast')) {
      return _cloudyPoems[DateTime.now().millisecond % _cloudyPoems.length];
    }
    
    // 雾天诗词
    if (condition.contains('雾') || condition.contains('fog') || condition.contains('mist')) {
      return _foggyPoems[DateTime.now().millisecond % _foggyPoems.length];
    }
    
    // 风天诗词
    if (condition.contains('风') || condition.contains('wind')) {
      return _windyPoems[DateTime.now().millisecond % _windyPoems.length];
    }
    
    // 默认诗词
    return _defaultPoems[DateTime.now().millisecond % _defaultPoems.length];
  }

  /// 根据节气获取诗词
  static PoemData getPoemBySolarTerm(String solarTerm) {
    return _solarTermPoems[solarTerm] ?? _defaultPoems[0];
  }

  /// 雨天诗词
  static final List<PoemData> _rainPoems = [
    PoemData(
      content: '好雨知时节，当春乃发生',
      author: '杜甫',
      title: '春夜喜雨',
      dynasty: '唐',
    ),
    PoemData(
      content: '天街小雨润如酥，草色遥看近却无',
      author: '韩愈',
      title: '早春呈水部张十八员外',
      dynasty: '唐',
    ),
    PoemData(
      content: '沾衣欲湿杏花雨，吹面不寒杨柳风',
      author: '志南',
      title: '绝句',
      dynasty: '宋',
    ),
    PoemData(
      content: '夜来风雨声，花落知多少',
      author: '孟浩然',
      title: '春晓',
      dynasty: '唐',
    ),
    PoemData(
      content: '空山新雨后，天气晚来秋',
      author: '王维',
      title: '山居秋暝',
      dynasty: '唐',
    ),
  ];

  /// 雪天诗词
  static final List<PoemData> _snowPoems = [
    PoemData(
      content: '忽如一夜春风来，千树万树梨花开',
      author: '岑参',
      title: '白雪歌送武判官归京',
      dynasty: '唐',
    ),
    PoemData(
      content: '窗含西岭千秋雪，门泊东吴万里船',
      author: '杜甫',
      title: '绝句',
      dynasty: '唐',
    ),
    PoemData(
      content: '孤舟蓑笠翁，独钓寒江雪',
      author: '柳宗元',
      title: '江雪',
      dynasty: '唐',
    ),
    PoemData(
      content: '晚来天欲雪，能饮一杯无',
      author: '白居易',
      title: '问刘十九',
      dynasty: '唐',
    ),
    PoemData(
      content: '北国风光，千里冰封，万里雪飘',
      author: '毛泽东',
      title: '沁园春·雪',
      dynasty: '现代',
    ),
  ];

  /// 晴天诗词
  static final List<PoemData> _sunnyPoems = [
    PoemData(
      content: '春风得意马蹄疾，一日看尽长安花',
      author: '孟郊',
      title: '登科后',
      dynasty: '唐',
    ),
    PoemData(
      content: '日出江花红胜火，春来江水绿如蓝',
      author: '白居易',
      title: '忆江南',
      dynasty: '唐',
    ),
    PoemData(
      content: '接天莲叶无穷碧，映日荷花别样红',
      author: '杨万里',
      title: '晓出净慈寺送林子方',
      dynasty: '宋',
    ),
    PoemData(
      content: '春色满园关不住，一枝红杏出墙来',
      author: '叶绍翁',
      title: '游园不值',
      dynasty: '宋',
    ),
    PoemData(
      content: '等闲识得东风面，万紫千红总是春',
      author: '朱熹',
      title: '春日',
      dynasty: '宋',
    ),
  ];

  /// 云/阴天诗词
  static final List<PoemData> _cloudyPoems = [
    PoemData(
      content: '黑云翻墨未遮山，白雨跳珠乱入船',
      author: '苏轼',
      title: '六月二十七日望湖楼醉书',
      dynasty: '宋',
    ),
    PoemData(
      content: '远上寒山石径斜，白云生处有人家',
      author: '杜牧',
      title: '山行',
      dynasty: '唐',
    ),
    PoemData(
      content: '黄梅时节家家雨，青草池塘处处蛙',
      author: '赵师秀',
      title: '约客',
      dynasty: '宋',
    ),
    PoemData(
      content: '山色空蒙雨亦奇',
      author: '苏轼',
      title: '饮湖上初晴后雨',
      dynasty: '宋',
    ),
  ];

  /// 雾天诗词
  static final List<PoemData> _foggyPoems = [
    PoemData(
      content: '雾失楼台，月迷津渡',
      author: '秦观',
      title: '踏莎行',
      dynasty: '宋',
    ),
    PoemData(
      content: '烟笼寒水月笼沙，夜泊秦淮近酒家',
      author: '杜牧',
      title: '泊秦淮',
      dynasty: '唐',
    ),
    PoemData(
      content: '山色空蒙雨亦奇',
      author: '苏轼',
      title: '饮湖上初晴后雨',
      dynasty: '宋',
    ),
  ];

  /// 风天诗词
  static final List<PoemData> _windyPoems = [
    PoemData(
      content: '昨夜西风凋碧树，独上高楼',
      author: '晏殊',
      title: '蝶恋花',
      dynasty: '宋',
    ),
    PoemData(
      content: '野火烧不尽，春风吹又生',
      author: '白居易',
      title: '赋得古原草送别',
      dynasty: '唐',
    ),
    PoemData(
      content: '春风又绿江南岸，明月何时照我还',
      author: '王安石',
      title: '泊船瓜洲',
      dynasty: '宋',
    ),
    PoemData(
      content: '羌笛何须怨杨柳，春风不度玉门关',
      author: '王之涣',
      title: '凉州词',
      dynasty: '唐',
    ),
  ];

  /// 默认诗词
  static final List<PoemData> _defaultPoems = [
    PoemData(
      content: '天气常如二三月，花枝不断四时春',
      author: '佚名',
      title: '昆明竹枝词',
      dynasty: '清',
    ),
    PoemData(
      content: '人间四月芳菲尽，山寺桃花始盛开',
      author: '白居易',
      title: '大林寺桃花',
      dynasty: '唐',
    ),
    PoemData(
      content: '采菊东篱下，悠然见南山',
      author: '陶渊明',
      title: '饮酒',
      dynasty: '晋',
    ),
  ];

  /// 节气诗词
  static final Map<String, PoemData> _solarTermPoems = {
    '立春': PoemData(
      content: '律回岁晚冰霜少，春到人间草木知',
      author: '张栻',
      title: '立春偶成',
      dynasty: '宋',
    ),
    '雨水': PoemData(
      content: '天街小雨润如酥，草色遥看近却无',
      author: '韩愈',
      title: '早春呈水部张十八员外',
      dynasty: '唐',
    ),
    '惊蛰': PoemData(
      content: '微雨众卉新，一雷惊蛰始',
      author: '韦应物',
      title: '观田家',
      dynasty: '唐',
    ),
    '春分': PoemData(
      content: '春分雨脚落声微，柳岸斜风带客归',
      author: '徐铉',
      title: '春分',
      dynasty: '宋',
    ),
    '清明': PoemData(
      content: '清明时节雨纷纷，路上行人欲断魂',
      author: '杜牧',
      title: '清明',
      dynasty: '唐',
    ),
    '谷雨': PoemData(
      content: '谷雨春光晓，山川黛色青',
      author: '佚名',
      title: '谷雨',
      dynasty: '唐',
    ),
    '立夏': PoemData(
      content: '绿树阴浓夏日长，楼台倒影入池塘',
      author: '高骈',
      title: '山亭夏日',
      dynasty: '唐',
    ),
    '小满': PoemData(
      content: '小满天逐热，温风沐麦圆',
      author: '欧阳修',
      title: '小满',
      dynasty: '宋',
    ),
    '芒种': PoemData(
      content: '时雨及芒种，四野皆插秧',
      author: '陆游',
      title: '时雨',
      dynasty: '宋',
    ),
    '夏至': PoemData(
      content: '昼晷已云极，宵漏自此长',
      author: '韦应物',
      title: '夏至避暑北池',
      dynasty: '唐',
    ),
    '小暑': PoemData(
      content: '倏忽温风至，因循小暑来',
      author: '元稹',
      title: '小暑六月节',
      dynasty: '唐',
    ),
    '大暑': PoemData(
      content: '赤日几时过，清风无处寻',
      author: '曾几',
      title: '大暑',
      dynasty: '宋',
    ),
    '立秋': PoemData(
      content: '乳鸦啼散玉屏空，一枕新凉一扇风',
      author: '刘翰',
      title: '立秋',
      dynasty: '宋',
    ),
    '处暑': PoemData(
      content: '一度暑出处暑时，秋风送爽已觉迟',
      author: '左河水',
      title: '处暑',
      dynasty: '现代',
    ),
    '白露': PoemData(
      content: '蒹葭苍苍，白露为霜',
      author: '佚名',
      title: '诗经·蒹葭',
      dynasty: '先秦',
    ),
    '秋分': PoemData(
      content: '暑退秋澄转爽凉，日光夜色两均长',
      author: '佚名',
      title: '秋分',
      dynasty: '唐',
    ),
    '寒露': PoemData(
      content: '空庭得秋长漫漫，寒露入暮愁衣单',
      author: '王安石',
      title: '八月十九日试院梦冲卿',
      dynasty: '宋',
    ),
    '霜降': PoemData(
      content: '霜降水痕收，浅碧鳞鳞露远洲',
      author: '苏轼',
      title: '南乡子·霜降水痕收',
      dynasty: '宋',
    ),
    '立冬': PoemData(
      content: '细雨生寒未有霜，庭前木叶半青黄',
      author: '陆游',
      title: '立冬',
      dynasty: '宋',
    ),
    '小雪': PoemData(
      content: '久雨重阳后，清寒小雪前',
      author: '李白',
      title: '小雪',
      dynasty: '唐',
    ),
    '大雪': PoemData(
      content: '大雪纷纷何所有，明年春色倍还人',
      author: '杜甫',
      title: '对雪',
      dynasty: '唐',
    ),
    '冬至': PoemData(
      content: '天时人事日相催，冬至阳生春又来',
      author: '杜甫',
      title: '小至',
      dynasty: '唐',
    ),
    '小寒': PoemData(
      content: '小寒连大吕，欢鹊垒新巢',
      author: '元稹',
      title: '小寒',
      dynasty: '唐',
    ),
    '大寒': PoemData(
      content: '蜡树银山炫皎光，朔风独啸静三江',
      author: '邵雍',
      title: '大寒吟',
      dynasty: '宋',
    ),
  };
}

/// 诗词数据
class PoemData {
  final String content;
  final String author;
  final String title;
  final String dynasty;

  PoemData({
    required this.content,
    required this.author,
    required this.title,
    required this.dynasty,
  });

  String get fullInfo => '《$title》 $dynasty·$author';
}
