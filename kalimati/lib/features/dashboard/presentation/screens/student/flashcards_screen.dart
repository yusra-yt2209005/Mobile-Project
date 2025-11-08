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
  bool _showWord = false; // Changed: now shows definition first by default
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

          // Extract sentences with their images
          final List<Map<String, dynamic>> sentencesWithImages = [];
          if (word['sentences'] != null) {
            for (final sentence in word['sentences'] as List) {
              final String sentenceText = sentence['text']?.toString() ?? '';
              
              // Extract image URLs from resources
              final List<String> imageUrls = [];
              if (sentence['resources'] != null) {
                for (final resource in sentence['resources'] as List) {
                  if (resource['type'] == 'Photo' && resource['url'] != null) {
                    imageUrls.add(resource['url'].toString());
                  }
                }
              }
              
              sentencesWithImages.add({
                'text': sentenceText,
                'images': imageUrls,
              });
            }
          }

          return {
            'word': wordText,
            'definition': definitionText,
            'sentences': sentencesWithImages,
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
      _showWord = !_showWord; // Changed: now toggles between definition and word
      _showSentences = false; // Hide sentences on flip
      if (_showWord) {
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
        _showWord = false; // Reset to show definition first
        _showSentences = false;
        _controller.reverse();
      });
    }
  }

  void _previousCard() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _showWord = false; // Reset to show definition first
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
      backgroundColor: const Color(0xFFF8F4FF), // Very light lilac background
      appBar: AppBar(
        backgroundColor: const Color(0xFFB39DDB), // Light purple
        centerTitle: true,
        title: Text(
          '${widget.packageTitle} - Flash Cards',
          style: GoogleFonts.comicNeue(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFB39DDB)),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Loading magical cards... ✨',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : _flashcards.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.auto_awesome, size: 80, color: Colors.purple.shade200),
                  const SizedBox(height: 20),
                  Text(
                    'No flashcards found for this package. ✨',
                    style: GoogleFonts.comicNeue(
                      fontSize: 20,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            
            // Fun instruction text
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFD1C4E9), // Light purple
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.auto_awesome, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    "Tap to reveal the word! ✨",
                    style: GoogleFonts.comicNeue(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 25),

            // Flashcard
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
                      child: _buildCardBack(currentCard!), // Shows word
                    )
                        : _buildCardFront(currentCard!), // Shows definition
                  );
                },
              ),
            ),

            const SizedBox(height: 25),

            // Show Sentences Button
            if (_showWord) // Only show when word is visible
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB39DDB), // Light purple
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    elevation: 6,
                    shadowColor: Colors.purple.withOpacity(0.2),
                  ),
                  onPressed: () {
                    setState(() {
                      _showSentences = !_showSentences;
                    });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _showSentences ? Icons.visibility_off : Icons.visibility,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _showSentences ? "Hide Examples" : "Show Examples! 🌟",
                        style: GoogleFonts.comicNeue(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // 📘 Sentence examples with images
            if (_showSentences)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    for (var sentenceData in currentCard!['sentences'])
                      _buildSentenceWithImages(sentenceData),
                  ],
                ),
              ),

            const SizedBox(height: 25),

            // Navigation buttons
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Previous button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB39DDB),
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(16),
                      elevation: 6,
                    ),
                    onPressed: _previousCard,
                    child: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                  ),

                  // Card counter
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      '${_currentIndex + 1} / ${_flashcards.length}',
                      style: GoogleFonts.comicNeue(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFB39DDB),
                      ),
                    ),
                  ),

                  // Next button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB39DDB),
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(16),
                      elevation: 6,
                    ),
                    onPressed: _nextCard,
                    child: const Icon(Icons.arrow_forward, color: Colors.white, size: 30),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSentenceWithImages(Map<String, dynamic> sentenceData) {
    final String sentenceText = sentenceData['text'];
    final List<String> imageUrls = List<String>.from(sentenceData['images'] ?? []);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Sentence text in a fun speech bubble style
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3E5F5),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: const Color(0xFFD1C4E9), width: 2),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.auto_awesome, color: Color(0xFFB39DDB), size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        sentenceText,
                        style: GoogleFonts.comicNeue(
                          fontSize: 18,
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Centered larger images
              if (imageUrls.isNotEmpty)
                Column(
                  children: [
                    // Single centered image or grid for multiple images
                    if (imageUrls.length == 1)
                      // Single large centered image
                      Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: const Color(0xFFD1C4E9),
                            width: 3,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            imageUrls[0],
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8F4FF),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFB39DDB)),
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8F4FF),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.photo, 
                                        color: Color(0xFFB39DDB), size: 50),
                                    SizedBox(height: 8),
                                    Text(
                                      'Image not available',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFFB39DDB),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    else
                      // Grid for multiple images
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.2,
                        ),
                        itemCount: imageUrls.length,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: const Color(0xFFD1C4E9),
                                width: 3,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                imageUrls[index],
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF8F4FF),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Center(
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFB39DDB)),
                                      ),
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF8F4FF),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.photo, 
                                            color: Color(0xFFB39DDB), size: 30),
                                        SizedBox(height: 4),
                                        Text(
                                          'Image',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFFB39DDB),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardFront(Map<String, dynamic> card) {
    return Card(
      elevation: 12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: Container(
        width: 340,
        height: 280,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE1BEE7), Color(0xFFD1C4E9)], // Lighter purple
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                card['definition'], // Shows definition first
                textAlign: TextAlign.center,
                style: GoogleFonts.comicNeue(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
              ),
            ),
            // Fun corner decorations
            Positioned(
              top: 15,
              left: 15,
              child: Icon(Icons.auto_awesome, color: Colors.white.withOpacity(0.7), size: 24),
            ),
            Positioned(
              bottom: 15,
              right: 15,
              child: Icon(Icons.auto_awesome, color: Colors.white.withOpacity(0.7), size: 24),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardBack(Map<String, dynamic> card) {
    return Card(
      elevation: 12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: Container(
        width: 340,
        height: 280,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFB39DDB), Color(0xFF9575CD)], // Light purple
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                card['word'], // Shows word after flip
                textAlign: TextAlign.center,
                style: GoogleFonts.comicNeue(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
              ),
            ),
            // Fun corner decorations
            Positioned(
              top: 15,
              right: 15,
              child: Icon(Icons.star, color: Colors.white.withOpacity(0.7), size: 24),
            ),
            Positioned(
              bottom: 15,
              left: 15,
              child: Icon(Icons.star, color: Colors.white.withOpacity(0.7), size: 24),
            ),
          ],
        ),
      ),
    );
  }
}