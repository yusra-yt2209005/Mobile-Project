import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class MatchWordDefinitionScreen extends StatefulWidget {
  final String packageTitle;

  const MatchWordDefinitionScreen({super.key, required this.packageTitle});

  @override
  State<MatchWordDefinitionScreen> createState() =>
      _MatchWordDefinitionScreenState();
}

class _MatchWordDefinitionScreenState extends State<MatchWordDefinitionScreen> {
  List<Map<String, dynamic>> _words = [];
  List<Map<String, dynamic>> _definitions = [];
  Map<int, int> _matches = {}; // wordIndex -> definitionIndex
  int? _selectedWord;
  String _feedbackMessage = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final jsonStr = await rootBundle.loadString('assets/packages.json');
    final List<dynamic> packages = json.decode(jsonStr);

    final package = packages.firstWhere(
      (p) => p['title'] == widget.packageTitle,
      orElse: () => null,
    );

    if (package == null || package['words'] == null) return;

    final wordsList = List<Map<String, dynamic>>.from(package['words']);

    final wordItems = <Map<String, dynamic>>[];
    final defItems = <Map<String, dynamic>>[];

    for (var i = 0; i < wordsList.length; i++) {
      final wordText = wordsList[i]['text'];
      final defs = List<Map<String, dynamic>>.from(wordsList[i]['definitions']);

      final firstDef = defs.isNotEmpty ? defs.first['text'] : 'No definition';

      wordItems.add({'word': wordText, 'index': i});
      defItems.add({'definition': firstDef, 'index': i});
    }

    setState(() {
      _words = wordItems;
      _definitions = defItems..shuffle();
      _isLoading = false;
    });
  }

  void _onWordTap(int index) {
    if (_isMatched(index)) return; // Ignore already matched words
    setState(() {
      _selectedWord = index;
      _feedbackMessage = '';
    });
  }

  void _onDefinitionTap(int index) {
    if (_selectedWord == null) return;

    final wordIndex = _selectedWord!;
    final defIndex = index;

    setState(() {
      if (_words[wordIndex]['index'] == _definitions[defIndex]['index']) {
        // Correct match
        _matches[wordIndex] = defIndex;
        _feedbackMessage = 'Correct!';
      } else {
        _feedbackMessage = 'Try again!';
      }

      _selectedWord = null;

      // Reset all if all words are matched
      if (_matches.length == _words.length) {
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            _matches.clear();
            _feedbackMessage = '';
          });
        });
      }
    });
  }

  bool _isMatched(int wordIndex) => _matches.containsKey(wordIndex);

  bool _isDefMatched(int defIndex) =>
      _matches.containsValue(defIndex); // for coloring definitions

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 179, 199, 235),
        centerTitle: true,
        title: Text(
          '${widget.packageTitle} - Match Words',
          style: GoogleFonts.bubblegumSans(fontSize: 22),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    "Tap a word, then its matching definition!",
                    style: GoogleFonts.nunito(
                      fontSize: 18,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Row(
                      children: [
                        // Words column
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                "Words",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.bubblegumSans(
                                    fontSize: 22, color: Colors.black87),
                              ),
                              const SizedBox(height: 10),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: _words.length,
                                  itemBuilder: (context, index) {
                                    final isSelected = _selectedWord == index;
                                    final isMatched = _isMatched(index);
                                    return GestureDetector(
                                      onTap: () => _onWordTap(index),
                                      child: Card(
                                        color: isMatched
                                            ? Colors.green.shade200
                                            : isSelected
                                                ? const Color.fromARGB(
                                                    255, 189, 161, 237)
                                                : Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        elevation: 4,
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Center(
                                            child: Text(
                                              _words[index]['word'],
                                              style: GoogleFonts.simonetta(
                                                fontSize: 18,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Definitions column
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                "Definitions",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.bubblegumSans(
                                    fontSize: 22, color: Colors.black87),
                              ),
                              const SizedBox(height: 10),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: _definitions.length,
                                  itemBuilder: (context, index) {
                                    final isMatched = _isDefMatched(index);
                                    return GestureDetector(
                                      onTap: () => _onDefinitionTap(index),
                                      child: Card(
                                        color: isMatched
                                            ? Colors.green.shade200
                                            : Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        elevation: 4,
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Text(
                                            _definitions[index]['definition'],
                                            style: GoogleFonts.simonetta(
                                              fontSize: 16,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      _feedbackMessage,
                      key: ValueKey(_feedbackMessage),
                      style: GoogleFonts.nunito(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: _feedbackMessage.contains('Correct')
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }
}
