/// 诗词数据模型
class PoemData {
  final String title;
  final String author;
  final String dynasty;
  final String content;
  final String? tags;

  const PoemData({
    required this.title,
    required this.author,
    required this.dynasty,
    required this.content,
    this.tags,
  });

  /// 作者与出处信息（如：唐·李白《静夜思》）
  String get fullInfo => '$dynasty·$author《$title》';
}
