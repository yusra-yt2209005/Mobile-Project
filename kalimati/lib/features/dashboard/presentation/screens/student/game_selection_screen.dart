import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kalimati/features/dashboard/presentation/screens/student/flashcards_screen.dart';

class GameSelectionScreen extends StatefulWidget {
  final String packageTitle;

  const GameSelectionScreen({super.key, required this.packageTitle});

  @override
  State<GameSelectionScreen> createState() => _GameSelectionScreenState();
}

class _GameSelectionScreenState extends State<GameSelectionScreen> {
  String packageDescription = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPackageDescription();
  }

  Future<void> _loadPackageDescription() async {
    final jsonStr = await rootBundle.loadString('assets/packages.json');
    final List<dynamic> packages = json.decode(jsonStr);

    final pkg = packages.firstWhere(
      (p) => p['title'] == widget.packageTitle,
      orElse: () => null,
    );

    setState(() {
      packageDescription = pkg != null
          ? pkg['description'] ?? ''
          : 'No description found';
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 179, 199, 235),
        centerTitle: true,
        title: Text(
          widget.packageTitle,
          style: const TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  Text(
                    'Package name:',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.w600,
                      fontFamily: GoogleFonts.bubblegumSans().fontFamily,
                    ),
                  ),
                  Text(
                    widget.packageTitle,
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: GoogleFonts.simonetta().fontFamily,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 📖 Description
                  Text(
                    'Package description:',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.w600,
                      fontFamily: GoogleFonts.bubblegumSans().fontFamily,
                    ),
                  ),
                  Text(
                    packageDescription,
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: GoogleFonts.simonetta().fontFamily,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 35),

                  Center(
                    child: Text(
                      "Which game would you like to play?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.bubblegumSans().fontFamily,
                        color: Colors.black87,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // 🟣 Flash Cards
                  _buildGameCard(
                    context,
                    title: "Flash Cards",
                    icon: Icons.style,
                    color: const Color.fromARGB(255, 189, 161, 237),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FlashCardsScreen(
                            packageTitle: widget.packageTitle,
                          ),
                        ),
                      );
                    },
                  ),
                  _buildGameCard(
                    context,
                    title: "Unscramble Words",
                    icon: Icons.text_fields,
                    color: const Color.fromARGB(255, 189, 161, 237),
                    onTap: () {
                      // TODO: Add navigation later
                    },
                  ),

                  _buildGameCard(
                    context,
                    title: "Match Word & Definition",
                    icon: Icons.compare_arrows,
                    color: const Color.fromARGB(255, 189, 161, 237),
                    onTap: () {
                      // TODO: Add navigation later
                    },
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildGameCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        splashColor: Colors.white.withOpacity(0.2),
        child: Card(
          color: color,
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 40),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.fuzzyBubbles().fontFamily,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
