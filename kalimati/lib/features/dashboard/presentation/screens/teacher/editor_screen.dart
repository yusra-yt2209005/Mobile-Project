// contains editing for teachers' created learning packages
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kalimati/features/dashboard/domain/entities/user.dart';

class PackageEditorScreen extends StatefulWidget {
  final User user;
  final Map<String, dynamic>? existingPackage;

  const PackageEditorScreen({
    super.key,
    required this.user,
    this.existingPackage,
  });

  @override
  State<PackageEditorScreen> createState() => _PackageEditorScreenState();
}

class _PackageEditorScreenState extends State<PackageEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late Map<String, dynamic> _packageData;
  final List<Map<String, dynamic>> _words = [];

  // Controllers for package fields
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _levelController = TextEditingController();
  final _languageController = TextEditingController();
  final _iconUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializePackageData();
  }

  void _initializePackageData() {
    if (widget.existingPackage != null) {
      // Editing existing package
      _packageData = Map<String, dynamic>.from(widget.existingPackage!);
      _words.addAll(List<Map<String, dynamic>>.from(_packageData['words'] ?? []));
      
      // Set controller values
      _titleController.text = _packageData['title'] ?? '';
      _descriptionController.text = _packageData['description'] ?? '';
      _categoryController.text = _packageData['category'] ?? '';
      _levelController.text = _packageData['level'] ?? '';
      _languageController.text = _packageData['language'] ?? '';
      _iconUrlController.text = _packageData['iconUrl'] ?? '';
    } else {
      // Creating new package
      _packageData = {
        'packageId': 'p${DateTime.now().millisecondsSinceEpoch}',
        'author': widget.user.email,
        'title': '',
        'description': '',
        'category': '',
        'level': 'Beginner',
        'language': 'English',
        'iconUrl': '',
        'lastUpdatedDate': DateTime.now().toIso8601String(),
        'version': 1,
        'words': [],
      };
    }
  }

  void _savePackage() {
    if (_formKey.currentState!.validate()) {
      // Update package data from controllers
      _packageData['title'] = _titleController.text;
      _packageData['description'] = _descriptionController.text;
      _packageData['category'] = _categoryController.text;
      _packageData['level'] = _levelController.text;
      _packageData['language'] = _languageController.text;
      _packageData['iconUrl'] = _iconUrlController.text;
      _packageData['lastUpdatedDate'] = DateTime.now().toIso8601String();
      _packageData['words'] = _words;

      // TODO: Save to database using PackageRepository
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Package "${_packageData['title']}" saved!')),
      );

      // Navigate back
      context.pop();
    }
  }

  void _addWord() {
    showDialog(
      context: context,
      builder: (context) => AddWordDialog(
        onSave: (wordData) {
          setState(() {
            _words.add(wordData);
          });
        },
      ),
    );
  }

  void _editWord(int index) {
    showDialog(
      context: context,
      builder: (context) => AddWordDialog(
        existingWord: _words[index],
        onSave: (wordData) {
          setState(() {
            _words[index] = wordData;
          });
        },
      ),
    );
  }

  void _deleteWord(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Word'),
        content: Text('Are you sure you want to delete "${_words[index]['text']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _words.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _levelController.dispose();
    _languageController.dispose();
    _iconUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(widget.existingPackage == null ? 'Create New Package' : 'Edit Package'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _savePackage,
            tooltip: 'Save Package',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Package Icon Preview
              if (_iconUrlController.text.isNotEmpty)
                Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(_iconUrlController.text),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),

              // Package Details Section
              _buildSectionHeader('Package Details'),
              _buildTextField(
                controller: _titleController,
                label: 'Package Title *',
                hint: 'e.g., Places In Town',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              _buildTextField(
                controller: _descriptionController,
                label: 'Description *',
                hint: 'e.g., A list of common places found in town',
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _categoryController,
                      label: 'Category *',
                      hint: 'e.g., Travel, Food, Animals',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a category';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDropdownField(
                      controller: _levelController,
                      label: 'Level *',
                      options: const ['Beginner', 'Intermediate', 'Advanced'],
                    ),
                  ),
                ],
              ),
              
              Row(
                children: [
                  Expanded(
                    child: _buildDropdownField(
                      controller: _languageController,
                      label: 'Language *',
                      options: const ['English', 'Arabic', 'French', 'Spanish'],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _iconUrlController,
                      label: 'Icon URL',
                      hint: 'https://...',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Words Section
              _buildSectionHeader('Words in Package (${_words.length})'),
              
              if (_words.isEmpty)
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.lightbulb_outline, size: 48, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      const Text(
                        'No words added yet',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Add words to create your learning package',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              else
                Column(
                  children: [
                    for (int i = 0; i < _words.length; i++)
                      _buildWordCard(_words[i], i),
                  ],
                ),

              const SizedBox(height: 80), // Space for FAB
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addWord,
        icon: const Icon(Icons.add),
        label: const Text('Add Word'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
        maxLines: maxLines,
        validator: validator,
      ),
    );
  }

  Widget _buildDropdownField({
    required TextEditingController controller,
    required String label,
    required List<String> options,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        value: controller.text.isEmpty ? options.first : controller.text,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
        items: options.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? newValue) {
          controller.text = newValue!;
        },
      ),
    );
  }

  Widget _buildWordCard(Map<String, dynamic> word, int index) {
    final definitions = List<Map<String, dynamic>>.from(word['definitions'] ?? []);
    final sentences = List<Map<String, dynamic>>.from(word['sentences'] ?? []);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    word['text'] ?? 'No word',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _editWord(index),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteWord(index),
                ),
              ],
            ),
            
            if (definitions.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Definitions: ${definitions.length}',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
            
            if (sentences.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                'Sentences: ${sentences.length}',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Add/Edit Word Dialog
class AddWordDialog extends StatefulWidget {
  final Map<String, dynamic>? existingWord;
  final Function(Map<String, dynamic>) onSave;

  const AddWordDialog({
    super.key,
    this.existingWord,
    required this.onSave,
  });

  @override
  State<AddWordDialog> createState() => _AddWordDialogState();
}

class _AddWordDialogState extends State<AddWordDialog> {
  final _wordController = TextEditingController();
  final List<Map<String, dynamic>> _definitions = [];
  final List<Map<String, dynamic>> _sentences = [];

  @override
  void initState() {
    super.initState();
    if (widget.existingWord != null) {
      _wordController.text = widget.existingWord!['text'] ?? '';
      _definitions.addAll(List<Map<String, dynamic>>.from(widget.existingWord!['definitions'] ?? []));
      _sentences.addAll(List<Map<String, dynamic>>.from(widget.existingWord!['sentences'] ?? []));
    }
  }

  void _saveWord() {
    if (_wordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a word')),
      );
      return;
    }

    final wordData = {
      'text': _wordController.text,
      'definitions': _definitions,
      'sentences': _sentences,
    };

    widget.onSave(wordData);
    Navigator.pop(context);
  }

  void _addDefinition() {
    showDialog(
      context: context,
      builder: (context) => AddDefinitionDialog(
        onSave: (definition) {
          setState(() {
            _definitions.add(definition);
          });
        },
      ),
    );
  }

  void _addSentence() {
    showDialog(
      context: context,
      builder: (context) => AddSentenceDialog(
        onSave: (sentence) {
          setState(() {
            _sentences.add(sentence);
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.existingWord == null ? 'Add New Word' : 'Edit Word',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            
            TextFormField(
              controller: _wordController,
              decoration: const InputDecoration(
                labelText: 'Word *',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Definitions Section
            _buildListSection(
              title: 'Definitions',
              items: _definitions,
              onAdd: _addDefinition,
              itemBuilder: (item, index) => ListTile(
                title: Text(item['text'] ?? ''),
                subtitle: Text('Source: ${item['source'] ?? 'Unknown'}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      _definitions.removeAt(index);
                    });
                  },
                ),
              ),
            ),

            // Sentences Section
            _buildListSection(
              title: 'Sentences',
              items: _sentences,
              onAdd: _addSentence,
              itemBuilder: (item, index) => ListTile(
                title: Text(item['text'] ?? ''),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      _sentences.removeAt(index);
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _saveWord,
                  child: const Text('Save Word'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListSection({
    required String title,
    required List<Map<String, dynamic>> items,
    required VoidCallback onAdd,
    required Widget Function(Map<String, dynamic>, int) itemBuilder,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('$title (${items.length})', style: const TextStyle(fontWeight: FontWeight.bold)),
            const Spacer(),
            TextButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: Text('Add $title'),
            ),
          ],
        ),
        if (items.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text('No  added', style: TextStyle(color: Colors.grey)),   // $title
          )
        else
          ...items.asMap().entries.map((entry) => itemBuilder(entry.value, entry.key)),
        const SizedBox(height: 16),
      ],
    );
  }
}

// Add Definition Dialog
class AddDefinitionDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;

  const AddDefinitionDialog({super.key, required this.onSave});

  @override
  State<AddDefinitionDialog> createState() => _AddDefinitionDialogState();
}

class _AddDefinitionDialogState extends State<AddDefinitionDialog> {
  final _definitionController = TextEditingController();
  final _sourceController = TextEditingController(text: 'Wikipedia');

  void _saveDefinition() {
    if (_definitionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a definition')),
      );
      return;
    }

    widget.onSave({
      'text': _definitionController.text,
      'source': _sourceController.text,
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Add Definition', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextFormField(
              controller: _definitionController,
              decoration: const InputDecoration(
                labelText: 'Definition *',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _sourceController,
              decoration: const InputDecoration(
                labelText: 'Source',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _saveDefinition,
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Add Sentence Dialog
class AddSentenceDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;

  const AddSentenceDialog({super.key, required this.onSave});

  @override
  State<AddSentenceDialog> createState() => _AddSentenceDialogState();
}

class _AddSentenceDialogState extends State<AddSentenceDialog> {
  final _sentenceController = TextEditingController();

  void _saveSentence() {
    if (_sentenceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a sentence')),
      );
      return;
    }

    widget.onSave({
      'text': _sentenceController.text,
      'resources': [], // Can be extended to add resources later
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Add Sentence', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextFormField(
              controller: _sentenceController,
              decoration: const InputDecoration(
                labelText: 'Sentence *',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _saveSentence,
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}