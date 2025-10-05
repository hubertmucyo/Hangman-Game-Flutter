import 'dart:math';

import 'package:flutter/services.dart' show rootBundle;

class HangmanWords {
  int wordCounter = 0;
  List<int> _usedNumbers = [];
  List<String> _words = [];

  Future readWords() async {
    String fileText = await rootBundle.loadString('res/hangman_words.txt');
    _words = fileText.split('\n');
  }

  void resetWords() {
    wordCounter = 0;
    _usedNumbers = [];
//    _words = [];
  }

  Map<String, String> getWord() {
    wordCounter += 1;
    var rand = Random();
    int wordLength = _words.length;
    int randNumber = rand.nextInt(wordLength);
    bool notUnique = true;
    if (wordCounter - 1 == _words.length) {
      notUnique = false;
      return {'word': '', 'category': ''};
    }
    while (notUnique) {
      if (!_usedNumbers.contains(randNumber)) {
        notUnique = false;
        _usedNumbers.add(randNumber);
        
        // Parse the word and category from the line
        String selectedLine = _words[randNumber];
        List<String> parts = selectedLine.split('|');
        
        if (parts.length >= 2) {
          return {
            'word': parts[0].trim().toUpperCase(),
            'category': parts[1].trim()
          };
        } else {
          // Fallback if no category is found
          return {
            'word': selectedLine.trim().toUpperCase(),
            'category': 'General'
          };
        }
      } else {
        randNumber = rand.nextInt(wordLength);
      }
    }
    
    // Fallback return (should never reach here)
    return {'word': '', 'category': ''};
  }

  String getHiddenWord(int wordLength) {
    String hiddenWord = '';
    for (int i = 0; i < wordLength; i++) {
      hiddenWord += '_';
    }
    return hiddenWord;
  }
}
