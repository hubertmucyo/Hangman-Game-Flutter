import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hangman/components/word_button.dart';
import 'package:flutter_hangman/screens/home_screen.dart';
import 'package:flutter_hangman/utilities/alphabet.dart';
import 'package:flutter_hangman/utilities/constants.dart';
import 'package:flutter_hangman/utilities/hangman_words.dart';
import 'package:flutter_hangman/utilities/score_db.dart' as score_database;
import 'package:flutter_hangman/utilities/user_scores.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key, required this.hangmanObject});

  final HangmanWords hangmanObject;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final database = score_database.openDB();
  int lives = 5;
  Alphabet englishAlphabet = Alphabet();
  late String word;
  late String category;
  late String hiddenWord;
  List<String> wordList = [];
  List<int> hintLetters = [];
  late List<bool> buttonStatus;
  late List<bool> usedLetters;
  late bool hintStatus;
  int hangState = 0;
  int wordCount = 0;
  bool finishedGame = false;
  bool resetGame = false;
  final FocusNode _focusNode = FocusNode();

  void newGame() {
    setState(() {
      widget.hangmanObject.resetWords();
      englishAlphabet = Alphabet();
      lives = 5;
      wordCount = 0;
      finishedGame = false;
      resetGame = false;
      initWords();
    });
  }

  Widget createButton(index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0.8, vertical: 2.5), // Much closer spacing
      child: Center(
        child: WordButton(
          buttonTitle: englishAlphabet.alphabet[index].toUpperCase(),
          onPress: buttonStatus[index] ? () => wordPress(index) : null,
          isUsed: usedLetters[index],
        ),
      ),
    );
  }

  void returnHomePage() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
      ModalRoute.withName('homePage'),
    );
  }

  void initWords() {
    finishedGame = false;
    resetGame = false;
    hintStatus = true;
    hangState = 0;
    buttonStatus = List.generate(26, (index) => true);
    usedLetters = List.generate(26, (index) => false);
    wordList = [];
    hintLetters = [];
    
    var wordData = widget.hangmanObject.getWord();
    word = wordData['word'] ?? '';
    category = wordData['category'] ?? 'General';
    
    if (word.isNotEmpty) {
      hiddenWord = widget.hangmanObject.getHiddenWord(word.length);
    } else {
      returnHomePage();
    }

    for (int i = 0; i < word.length; i++) {
      wordList.add(word[i]);
      hintLetters.add(i);
    }
    
    // Focus for keyboard input
    _focusNode.requestFocus();
  }

  void handleKeyPress(String key) {
    if (finishedGame || lives == 0) return;
    
    key = key.toLowerCase();
    if (englishAlphabet.alphabet.contains(key)) {
      int index = englishAlphabet.alphabet.indexOf(key);
      if (buttonStatus[index]) {
        wordPress(index);
      }
    }
  }

  void wordPress(int index) {
    if (lives == 0) {
      returnHomePage();
    }

    if (finishedGame) {
      setState(() {
        resetGame = true;
      });
      return;
    }

    bool check = false;
    setState(() {
      usedLetters[index] = true;
      
      // Create a list to track which positions were filled
      List<String> newHiddenWord = hiddenWord.split('');
      
      for (int i = 0; i < wordList.length; i++) {
        if (wordList[i].toLowerCase() == englishAlphabet.alphabet[index]) {
          check = true;
          wordList[i] = '';
          newHiddenWord[i] = word[i];
        }
      }
      
      // Update the hidden word
      hiddenWord = newHiddenWord.join('');
      
      for (int i = 0; i < wordList.length; i++) {
        if (wordList[i] == '') {
          hintLetters.remove(i);
        }
      }
      
      if (!check) {
        hangState += 1;
      }

      if (hangState == 6) {
        finishedGame = true;
        lives -= 1;
        if (lives < 1) {
          if (wordCount > 0) {
            Score score = Score(
                id: 1,
                scoreDate: DateTime.now().toString(),
                userScore: wordCount);
            score_database.manipulateDatabase(score, database);
          }
          Alert(
              style: kGameOverAlertStyle,
              context: context,
              title: "Game Over!",
              desc: "Your score is $wordCount",
              buttons: [
                DialogButton(
                  color: kDialogButtonColor,
                  onPressed: () => returnHomePage(),
                  child: Icon(
                    MdiIcons.home,
                    size: 30.0,
                  ),
                ),
                DialogButton(
                  onPressed: () {
                    newGame();
                    Navigator.pop(context);
                  },
                  color: kDialogButtonColor,
                  child: Icon(MdiIcons.refresh, size: 30.0),
                ),
              ]).show();
        } else {
          Alert(
            context: context,
            style: kFailedAlertStyle,
            type: AlertType.error,
            title: word,
            desc: "Category: $category",
            buttons: [
              DialogButton(
                radius: BorderRadius.circular(10),
                width: 127,
                color: kDialogButtonColor,
                height: 52,
                child: Icon(
                  MdiIcons.arrowRightThick,
                  size: 30.0,
                ),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                    initWords();
                  });
                },
              ),
            ],
          ).show();
        }
      }

      buttonStatus[index] = false;
      if (hiddenWord == word) {
        finishedGame = true;
        Alert(
          context: context,
          style: kSuccessAlertStyle,
          type: AlertType.success,
          title: word,
          desc: "Category: $category",
          buttons: [
            DialogButton(
              radius: BorderRadius.circular(10),
              width: 127,
              color: kDialogButtonColor,
              height: 52,
              child: Icon(
                MdiIcons.arrowRightThick,
                size: 30.0,
              ),
              onPressed: () {
                setState(() {
                  wordCount += 1;
                  Navigator.pop(context);
                  initWords();
                });
              },
            )
          ],
        ).show();
      }
    });
  }

  void useHint() {
    if (hintStatus && hintLetters.isNotEmpty && !finishedGame && lives > 1) {
      setState(() {
        int rand = Random().nextInt(hintLetters.length);
        int letterIndex = englishAlphabet.alphabet.indexOf(wordList[hintLetters[rand]].toLowerCase());
        wordPress(letterIndex);
        hintStatus = false;
        lives -= 1; // Sacrifice one life for hint
      });
    }
  }

  @override
  void initState() {
    super.initState();
    initWords();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (resetGame) {
      setState(() {
        initWords();
      });
    }
    
    return KeyboardListener(
      focusNode: _focusNode,
      onKeyEvent: (KeyEvent event) {
        if (event is KeyDownEvent) {
          final key = event.logicalKey.keyLabel;
          if (key.length == 1 && key.toLowerCase().contains(RegExp(r'[a-z]'))) {
            handleKeyPress(key);
          }
        }
      },
      child: PopScope(
        canPop: false,
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(6.0, 8.0, 6.0, 35.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Stack(
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.only(top: 0.5),
                                      child: IconButton(
                                        tooltip: 'Lives',
                                        highlightColor: Colors.transparent,
                                        splashColor: Colors.transparent,
                                        iconSize: 50, // Much larger
                                        icon: Icon(MdiIcons.heart, 
                                          color: const Color(0xFFFF1744), // Bright red for visibility
                                        ),
                                        onPressed: () {},
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          11.0, 10.0, 0, 1.0), // Adjusted for larger icon
                                      alignment: Alignment.center,
                                      child: SizedBox(
                                        height: 48, // Larger to match icon
                                        width: 48,
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Text(
                                              lives.toString() == "1"
                                                  ? "I"
                                                  : lives.toString(),
                                              style: const TextStyle(
                                                color: Colors.white, // White for better contrast
                                                fontSize: 22, // Slightly larger
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'LuckiestGuy', // Bolder font
                                                shadows: [
                                                  Shadow(
                                                    color: Colors.black54,
                                                    offset: Offset(1, 1),
                                                    blurRadius: 2,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              child: Text(
                                wordCount == 1 ? "I" : '$wordCount',
                                style: kWordCounterTextStyle,
                              ),
                            ),
                            SizedBox(
                              child: IconButton(
                                tooltip: 'Hint (Costs 1 life)',
                                iconSize: 50, // Much larger
                                icon: Icon(MdiIcons.lightbulb,
                                  color: hintStatus && lives > 1 
                                    ? const Color(0xFFFFD700) // Bright yellow when available
                                    : Colors.grey.shade400, // Gray when disabled
                                ),
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onPressed: hintStatus && lives > 1
                                    ? () {
                                        useHint();
                                      }
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Category Display - Cartoon Style
                      Container(
                        margin: const EdgeInsets.only(bottom: 15.0),
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFD700), // Sunny yellow background
                          borderRadius: BorderRadius.circular(25.0),
                          border: Border.all(color: const Color(0xFFFF6B35), width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              offset: const Offset(3, 3),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('📂 ', style: TextStyle(fontSize: 18)),
                            Text(
                              'Category: $category',
                              style: const TextStyle(
                                color: Color(0xFF2F4F4F), // Dark gray for readability
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'PatrickHand',
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      Expanded(
                        flex: 6,
                        child: Container(
                          alignment: Alignment.bottomCenter,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Image.asset(
                              'images/$hangState.png',
                              height: 1001,
                              width: 991,
                              gaplessPlayback: true,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 35.0),
                          alignment: Alignment.center,
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              hiddenWord,
                              style: kWordTextStyle,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(4.0, 1.0, 4.0, 6.0), // Minimal padding for very tight layout
                  child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      TableRow(children: [
                        TableCell(child: createButton(0)),
                        TableCell(child: createButton(1)),
                        TableCell(child: createButton(2)),
                        TableCell(child: createButton(3)),
                        TableCell(child: createButton(4)),
                        TableCell(child: createButton(5)),
                        TableCell(child: createButton(6)),
                      ]),
                      TableRow(children: [
                        TableCell(child: createButton(7)),
                        TableCell(child: createButton(8)),
                        TableCell(child: createButton(9)),
                        TableCell(child: createButton(10)),
                        TableCell(child: createButton(11)),
                        TableCell(child: createButton(12)),
                        TableCell(child: createButton(13)),
                      ]),
                      TableRow(children: [
                        TableCell(child: createButton(14)),
                        TableCell(child: createButton(15)),
                        TableCell(child: createButton(16)),
                        TableCell(child: createButton(17)),
                        TableCell(child: createButton(18)),
                        TableCell(child: createButton(19)),
                        TableCell(child: createButton(20)),
                      ]),
                      TableRow(children: [
                        TableCell(child: createButton(21)),
                        TableCell(child: createButton(22)),
                        TableCell(child: createButton(23)),
                        TableCell(child: createButton(24)),
                        TableCell(child: createButton(25)),
                        const TableCell(child: Text('')),
                        const TableCell(child: Text('')),
                      ]),
                    ],
                  ),
                ),
                
                // Keyboard instructions - Cartoon Style
                Container(
                  padding: const EdgeInsets.all(12.0),
                  margin: const EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(color: const Color(0xFF4ECDC4), width: 2),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('⌨️ ', style: TextStyle(fontSize: 16)),
                      Text(
                        'Tip: You can also type letters on your keyboard!',
                        style: TextStyle(
                          color: Color(0xFF2F4F4F),
                          fontSize: 14.0,
                          fontFamily: 'Baloo2',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}