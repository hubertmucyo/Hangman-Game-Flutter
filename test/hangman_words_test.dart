import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_hangman/utilities/hangman_words.dart';

void main() {
  group('HangmanWords Tests', () {
    late HangmanWords hangmanWords;

    setUp(() {
      hangmanWords = HangmanWords();
    });

    test('getWord should return a Map with word and category', () async {
      // Initialize words first
      await hangmanWords.readWords();
      
      // Get a word
      Map<String, String> result = hangmanWords.getWord();
      
      // Verify the result structure
      expect(result, isA<Map<String, String>>());
      expect(result.containsKey('word'), true);
      expect(result.containsKey('category'), true);
      expect(result['word'], isNotEmpty);
      expect(result['category'], isNotEmpty);
    });

    test('getWord should return different words on multiple calls', () async {
      await hangmanWords.readWords();
      
      Map<String, String> word1 = hangmanWords.getWord();
      Map<String, String> word2 = hangmanWords.getWord();
      
      // Words should be different (with high probability)
      expect(word1['word'] != word2['word'] || word1['category'] != word2['category'], true);
    });

    test('resetWords should reset the word counter', () async {
      await hangmanWords.readWords();
      
      // Get some words
      hangmanWords.getWord();
      hangmanWords.getWord();
      
      // Reset
      hangmanWords.resetWords();
      
      // Counter should be reset
      expect(hangmanWords.wordCounter, 0);
    });
  });
}