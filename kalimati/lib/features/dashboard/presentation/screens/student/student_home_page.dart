// shows list of all learning packages for all students
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:kalimati/core/navigations/app_router.dart';

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({super.key});

  @override
  State<StatefulWidget> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  late Future<List<LearningPackage>> _future;
  String _query = '';
  List<LearningPackage> _all = [];
  List<LearningPackage> _filtered = [];

  @override
  void initState() {
    super.initState();
    _future = _loadPackages();
  }

  Future<List<LearningPackage>> _loadPackages() async {
    // Read the JSON array from assets
    final jsonStr = await rootBundle.loadString('assets/packages.json');
    final list = json.decode(jsonStr) as List<dynamic>;

    final pkgs = list
        .map((e) => LearningPackage.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    // Cache for search
    _all = pkgs;
    _filtered = pkgs;
    return pkgs;
  }

  void _applySearch(String q) {
    setState(() {
      _query = q;
      if (_query.trim().isEmpty) {
        _filtered = _all;
      } else {
        final lq = _query.toLowerCase();
        _filtered = _all.where((p) {
          return p.title.toLowerCase().contains(lq) ||
              p.description.toLowerCase().contains(lq) ||
              p.category.toLowerCase().contains(lq) ||
              p.language.toLowerCase().contains(lq) ||
              p.level.toLowerCase().contains(lq);
        }).toList();
      }
    });
  }

  Future<void> _refresh() async {
    final pkgs = await _loadPackages();
    setState(() {
      _filtered = pkgs;
      _query = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 179, 199, 235),
        centerTitle: true,
        title: const Text(
          'Learning Packages',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          // back button---------------------------
          onPressed: () {
            context.goNamed(Routes.home); // go back to home screen
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: FutureBuilder<List<LearningPackage>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(
              child: Text('Failed to load packages:\n${snap.error}'),
            );
          }

          // search + list
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search title, category, language, level…',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: _applySearch,
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refresh,
                  child: _filtered.isEmpty
                      ? const Center(child: Text('No packages found'))
                      : ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: _filtered.length,
                          itemBuilder: (context, i) {
                            final p = _filtered[i];
                            return Card(
                              elevation: 3,
                              margin: const EdgeInsets.only(bottom: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              // child: InkWell(
                              //   borderRadius: BorderRadius.circular(16),
                              //   onTap: () => context.pushNamed(
                              //     Routes.packageDetailScreen,
                              //   ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // --- Top row of card: Icon + Title ------------------------------------------------------------------
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        _PackageAvatar(iconUrl: p.iconUrl),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            p.title,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),

                                    // --- Info ----------------------------------------------------------------------
                                    Wrap(
                                      spacing: 8,
                                      children: [
                                        Chip(label: Text(p.category)),
                                        Chip(label: Text('Level: ${p.level}')),
                                        Chip(label: Text(p.language)),
                                      ],
                                    ),

                                    const SizedBox(height: 10),

                                    // --- Description --------------------------------------------------------------------------
                                    Text(
                                      p.description,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade700,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),

                                    const SizedBox(height: 12),

                                    // --- Button to view details -------------------------------------------------------------------
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: FilledButton.icon(
                                        icon: const Icon(Icons.open_in_new),
                                        label: const Text('View Details'),
                                        onPressed: () => context.pushNamed(
                                          Routes.gameSelectionScreen,
                                          extra: p.title,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // ),
                            );
                          },
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _PackageAvatar extends StatelessWidget {
  final String? iconUrl;
  const _PackageAvatar({this.iconUrl});

  @override
  Widget build(BuildContext context) {
    if (iconUrl == null || iconUrl!.isEmpty) {
      return const CircleAvatar(child: Icon(Icons.menu_book));
    }
    return CircleAvatar(
      backgroundImage: NetworkImage(iconUrl!),
      onBackgroundImageError: (_, __) {},
      child: const SizedBox.shrink(), // keeps size even while loading
    );
  }
}

class LearningPackage {
  final String packageId;
  final String author;
  final String title;
  final String description;
  final String language;
  final String level;
  final String category;
  final String? iconUrl;
  final String lastUpdatedDate;

  LearningPackage({
    // constructor
    required this.packageId,
    required this.author,
    required this.title,
    required this.description,
    required this.language,
    required this.level,
    required this.category,
    this.iconUrl,
    required this.lastUpdatedDate,
  });

  factory LearningPackage.fromJson(Map<String, dynamic> json) {
    return LearningPackage(
      packageId: json['packageId']?.toString() ?? '',
      author: json['author'] ?? '',
      title: json['title'] ?? '(no title)',
      description: json['description'] ?? '',
      language: json['language'] ?? '',
      level: json['level'] ?? '',
      category: json['category'] ?? '',
      iconUrl: json['iconUrl'],
      lastUpdatedDate: json['lastUpdatedDate'] ?? '',
    );
  }
}
