import 'package:floor/floor.dart';
import 'package:kalimati/features/dashboard/domain/entities/word.dart';



@Entity(
  tableName: 'sentences',
  foreignKeys: [
    ForeignKey(
      childColumns: ['wordId'],
      parentColumns: ['id'],
      entity: Word,
      onDelete: ForeignKeyAction.cascade,
    ),
  ],
)
class Sentence {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String text;
  final int wordId; // Foreign key to word

  Sentence({this.id, required this.text, required this.wordId});

  // JSON serialization
  factory Sentence.fromJson(Map<String, dynamic> json) {
    return Sentence(
      id: json['id'] as int?,
      text: json['text'] as String,
      wordId: json['wordId'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'text': text, 'wordId': wordId};
  }

  Sentence copyWith({int? id, String? text, int? wordId}) {
    return Sentence(
      id: id ?? this.id,
      text: text ?? this.text,
      wordId: wordId ?? this.wordId,
    );
  }
}
/* 
class Sentence {
  final String sentenceId;
  final String text;
  final List<Resource> resources;

  Sentence({
    required this.sentenceId,
    required this.text,
    required this.resources,
  });
}
 */