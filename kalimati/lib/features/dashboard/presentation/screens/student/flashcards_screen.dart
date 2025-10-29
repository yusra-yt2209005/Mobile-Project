import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class FlashCardsScreen extends StatefulWidget {
  final String packageTitle;

  const FlashCardsScreen({super.key, required this.packageTitle});

  @override
  State<FlashCardsScreen> createState() => _FlashCardsScreenState();
}

class _FlashCardsScreenState extends State<FlashCardsScreen>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> _flashcards = [];
  int _currentIndex = 0;
  bool _showDefinition = false;
  bool _showSentences = false;
  bool _isLoading = true;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _loadFlashcards();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadFlashcards() async {
    try {
      final jsonStr = await rootBundle.loadString('assets/packages.json');
      final List<dynamic> packages = json.decode(jsonStr);

      final package = packages.firstWhere(
        (p) => p['title'] == widget.packageTitle,
        orElse: () => null,
      );

      if (package != null && package['words'] != null) {
        final words = (package['words'] as List).map<Map<String, dynamic>>((
          word,
        ) {
          final String wordText = word['text'] ?? '';
          final String definitionText =
              (word['definitions'] != null &&
                  (word['definitions'] as List).isNotEmpty)
              ? word['definitions'][0]['text']
              : 'No definition available';

          final List<String> sentences =
              (word['sentences'] as List?)
                  ?.map<String>((s) => s['text'].toString())
                  .toList() ??
              [];

          return {
            'word': wordText,
            'definition': definitionText,
            'sentences': sentences,
          };
        }).toList();

        setState(() {
          _flashcards = words;
          _isLoading = false;
        });
      } else {
        setState(() {
          _flashcards = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading flashcards: $e");
      setState(() => _isLoading = false);
    }
  }

  void _flipCard() {
    if (_controller.isAnimating) return;
    setState(() {
      _showDefinition = !_showDefinition;
      _showSentences = false; // Hide sentences on flip
      if (_showDefinition) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  void _nextCard() {
    if (_currentIndex < _flashcards.length - 1) {
      setState(() {
        _currentIndex++;
        _showDefinition = false;
        _showSentences = false;
        _controller.reverse();
      });
    }
  }

  void _previousCard() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _showDefinition = false;
        _showSentences = false;
        _controller.reverse();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentCard = _flashcards.isNotEmpty
        ? _flashcards[_currentIndex]
        : null;

    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 179, 199, 235),
        centerTitle: true,
        title: Text(
          '${widget.packageTitle} - Flash Cards',
          style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _flashcards.isEmpty
          ? const Center(
              child: Text(
                'No flashcards found for this package.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    "Tap the card to flip",
                    style: GoogleFonts.nunito(
                      fontSize: 18,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 20),

                  GestureDetector(
                    onTap: _flipCard,
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        final angle = _controller.value * 3.1416;
                        final isBack = angle > 1.57;
                        return Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..rotateY(angle),
                          child: isBack
                              ? Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.identity()
                                    ..rotateY(3.1416),
                                  child: _buildCardBack(currentCard!),
                                )
                              : _buildCardFront(currentCard!),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 25),

                  if (_showDefinition)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo.shade200,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 14,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _showSentences = !_showSentences;
                          });
                        },
                        child: Text(
                          _showSentences
                              ? "Hide Sentences"
                              : "Show Used in Sentences",
                          style: GoogleFonts.nunito(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                  // 📘 Sentence examples
                  if (_showSentences)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          for (var s in currentCard!['sentences'])
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Text(
                                '• $s',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.simonetta(
                                  fontSize: 18,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 25),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        iconSize: 50,
                        color: Colors.indigo,
                        onPressed: _previousCard,
                        icon: const Icon(Icons.arrow_back_rounded),
                      ),
                      const SizedBox(width: 40),
                      IconButton(
                        iconSize: 50,
                        color: Colors.indigo,
                        onPressed: _nextCard,
                        icon: const Icon(Icons.arrow_forward_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${_currentIndex + 1} / ${_flashcards.length}',
                    style: GoogleFonts.nunito(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  Widget _buildCardFront(Map<String, dynamic> card) {
    return Card(
      elevation: 10,
      color: Colors.blue.shade200,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Container(
        width: 340,
        height: 280,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(30),
        child: Text(
          card['word'],
          textAlign: TextAlign.center,
          style: GoogleFonts.bubblegumSans(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildCardBack(Map<String, dynamic> card) {
    return Card(
      elevation: 10,
      color: Colors.indigo.shade200,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Container(
        width: 340,
        height: 280,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(25),
        child: Text(
          card['definition'],
          textAlign: TextAlign.center,
          style: GoogleFonts.nunito(fontSize: 22, color: Colors.white),
        ),
      ),
    );
  }
}
