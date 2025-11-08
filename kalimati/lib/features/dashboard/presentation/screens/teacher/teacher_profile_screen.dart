import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:kalimati/features/dashboard/domain/entities/user.dart';

class TeacherProfileScreen extends StatefulWidget {
  final User user;
  const TeacherProfileScreen({super.key, required this.user});

  @override
  State<TeacherProfileScreen> createState() => _TeacherProfileScreenState();
}

class _TeacherProfileScreenState extends State<TeacherProfileScreen> {
  List<Map<String, dynamic>> _packages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPackages();
  }

  Future<void> _loadPackages() async {
    final jsonStr = await rootBundle.loadString('assets/packages.json');
    final List<dynamic> allPackages = json.decode(jsonStr);

    final teacherPackages = allPackages
        .where((p) => p['author'] == widget.user.email)
        .toList();

    setState(() {
      _packages = List<Map<String, dynamic>>.from(teacherPackages);
      _isLoading = false;
    });
  }

  /* void _editPackage(int index) {
    final pkg = _packages[index];
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Edit "${pkg['title']}"')));
  } */

  void _deletePackage(int index) {
    setState(() {
      _packages.removeAt(index);
    });
  }
  
  void _editPackage(int index) {
    final pkg = _packages[index];
    context.pushNamed(
      'package-editor',
      extra: {
        'user': widget.user,
        'package': pkg,
      },
    );
  }

  void _addPackage() {
    context.pushNamed(
      'package-editor',
      extra: {
        'user': widget.user,
        'package': null, // Indicates new package
      },
    );
  }

/*   void _addPackage() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Add a new package')));
  }
 */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: Text(
          'Profile',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              final shouldLogout = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Yes'),
                    ),
                  ],
                ),
              );
              if (shouldLogout ?? false) {
                context.goNamed('teacher-login');
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white,
                      child: widget.user.photoUrl.isNotEmpty
                          ? ClipOval(
                              child: SizedBox(
                                width: 120, // 2 * radius
                                height: 120,
                                child: Image.network(
                                  widget.user.photoUrl,
                                  fit: BoxFit.contain,
                                  alignment: Alignment.center,
                                  loadingBuilder: (context, child, progress) {
                                    if (progress == null) return child;
                                    return const Center(
                                      child: SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stack) =>
                                      const Icon(Icons.person, size: 60),
                                ),
                              ),
                            )
                          : const Icon(Icons.person, size: 60),
                    ),

                    const SizedBox(height: 16),
                    Text(
                      '${widget.user.firstName} ${widget.user.lastName}',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.user.email,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.user.role,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 30),

                    // --- Packages List ---
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'My Packages',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _packages.isEmpty
                        ? const Text("You haven't created any packages yet.")
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _packages.length,
                            itemBuilder: (context, index) {
                              final pkg = _packages[index];
                              return Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 8,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    children: [
                                      if (pkg['iconUrl'] != null)
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          child: Image.network(
                                            pkg['iconUrl'],
                                            width: 60,
                                            height: 60,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      if (pkg['iconUrl'] != null)
                                        const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              pkg['title'] ?? 'No title',
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              pkg['description'] ?? '',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                              Icons.edit,
                                              color: Colors.blue,
                                            ),
                                            onPressed: () =>
                                                _editPackage(index),
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            onPressed: () =>
                                                _deletePackage(index),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addPackage,
        icon: const Icon(Icons.add),
        label: const Text('Add New Package'),
      ),
    );
  }
}
