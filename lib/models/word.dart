class Word {
  final int id; // primaryKey
  final Category category;
  final String word;
  final String pinyin;
  final String meaning;

  Word(
      {required this.id,
      required this.category,
      required this.word,
      required this.pinyin,
      required this.meaning});

  // マップからWordオブジェクト作成
  factory Word.fromMap(Map<String, dynamic> map) => Word(
      id: map["id"],
      category: Category(id: map["category_id"], categoryName: map["category_name"]),
      word: map["word"],
      pinyin: map["pinyin"],
      meaning: map["meaning"]
      );
}

class Category {
  final int id;
  final String categoryName;

  Category({required this.id, required this.categoryName});

  // マップからCategoryオブジェクトを作成
  factory Category.fromMap(Map<String, dynamic> map) => Category(id: map["id"], categoryName: map["category_name"]);
}

class ExampleSentence {
  final int id;
  final int wordId;
  String sentence;

  ExampleSentence(
      {required this.id, required this.wordId, required this.sentence});

  // マップから例文オブジェクト作成
  factory ExampleSentence.fromMap(Map<String, dynamic> map) => ExampleSentence(
      id: map["id"], wordId: map["word_id"], sentence: map["example_sentence"]);
}

// 一覧表示用の単語リスト
class WordData {
  final int id;
  final String category;
  final String word;
  final String pinyin;
  final String meaning;
  final List<String> exampleSentences;

  WordData(
      {required this.id,
      required this.category,
      required this.word,
      required this.pinyin,
      required this.meaning,
      this.exampleSentences = const []});
}
