

import 'package:floor/floor.dart';
import 'package:kalimati/features/dashboard/domain/entities/learning_package.dart';

@Entity(
  tableName: 'words',
  foreignKeys: [
    ForeignKey(
      childColumns: ['packageId'],
      parentColumns: ['packageId'],
      entity: LearningPackage,
      onDelete: ForeignKeyAction.cascade,
    ),
  ],
)
class Word {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  
  final String text;
  final String packageId; // Foreign key to learning package

  Word({
    this.id,
    required this.text,
    required this.packageId,
  });

  // JSON serialization
  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      id: json['id'] as int?,
      text: json['text'] as String,
      packageId: json['packageId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'packageId': packageId,
    };
  }

  Word copyWith({
    int? id,
    String? text,
    String? packageId,
  }) {
    return Word(
      id: id ?? this.id,
      text: text ?? this.text,
      packageId: packageId ?? this.packageId,
    );
  }
}

/* class Word {
  final String wordId;
  final String text;
  final List<Definition> definitions;
  final List<Sentence> sentences;
  final List<Resource> resources;

  Word({
    required this.wordId,
    required this.text,
    required this.definitions,
    required this.sentences,
    required this.resources,
  });
} */
