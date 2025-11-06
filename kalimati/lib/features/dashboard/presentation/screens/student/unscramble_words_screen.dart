import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UnscrambleWordsScreen extends StatefulWidget {
  final String packageTitle;

  const UnscrambleWordsScreen({super.key, required this.packageTitle});

  @override
  State<UnscrambleWordsScreen> createState() => _UnscrambleWordsScreenState();
}

class _UnscrambleWordsScreenState extends State<UnscrambleWordsScreen> {
  List<String> words = [];
  int currentIndex = 0;
  String scrambledWord = '';
  final TextEditingController _controller = TextEditingController();
  String feedback = '';

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  Future<void> _loadWords() async {
    final jsonStr = await rootBundle.loadString('assets/packages.json');
    final List<dynamic> packages = json.decode(jsonStr);
    final pkg = packages.firstWhere(
      (p) => p['title'] == widget.packageTitle,
      orElse: () => null,
    );

    if (pkg != null && pkg['words'] != null) {
      words = (pkg['words'] as List<dynamic>)
          .map((w) => w['text'].toString())
          .toList();
      _setNextWord();
    } else {
      setState(() {
        feedback = 'No words found for this package.';
      });
    }
  }

  void _setNextWord() {
    if (currentIndex < words.length) {
      String currentWord = words[currentIndex];
      scrambledWord = _scrambleWord(currentWord);
      _controller.clear();
      feedback = '';
      setState(() {});
    } else {
      setState(() {
        feedback = 'You finished all the words!';
      });
    }
  }

  String _scrambleWord(String word) {
    List<String> chars = word.split('');
    chars.shuffle(Random());
    return chars.join('');
  }

  void _checkAnswer() {
    if (_controller.text.trim().toLowerCase() ==
        words[currentIndex].toLowerCase()) {
      setState(() {
        feedback = 'Correct!';
      });
      Future.delayed(const Duration(seconds: 1), () {
        currentIndex++;
        _setNextWord();
      });
    } else {
      setState(() {
        feedback = 'Try again!';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isFinished = currentIndex >= words.length;

    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 179, 199, 235),
        title: Text(widget.packageTitle,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: words.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(24.0),
              child: isFinished
                  ? Center(
                      child: Text(
                        feedback,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Scrambled word cards
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: scrambledWord.split('').map((letter) {
                            return Card(
                              color: Colors.indigo.shade100,
                              margin: const EdgeInsets.all(6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Text(
                                  letter.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 40),

                        // Input text field
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: TextField(
                            controller: _controller,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              hintText: 'Type the correct word here',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Check Answer button
                        ElevatedButton(
                          onPressed: _checkAnswer,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'Check Answer',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Feedback
                        Text(
                          feedback,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: feedback.contains('Correct')
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
            ),
    );
  }
}
