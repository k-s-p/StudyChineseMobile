class Word {
  final int id; // primaryKey
  final String category; // hskレベルなどのカテゴリで単語を分ける
  final String word;
  final String pinyin;
  final String meaning;

  Word({required this.id, required this.category, required this.word, required this.pinyin, required this.meaning});
}

class ExampleSentence {
  final int id;
  final int wordId;
  final String sentence;

  ExampleSentence({required this.id, required this.wordId, required this.sentence});
}

// 一覧表示用の単語リスト
class WordData {
  final int id;
  final String category;
  final String word;
  final String pinyin;
  final String meaning;
  final List<String> exampleSentences;

  WordData({required this.id, required this.category,required this.word, required this.pinyin,required this.meaning, this.exampleSentences = const []});
}