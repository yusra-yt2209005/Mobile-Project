import 'package:floor/floor.dart';
import 'package:kalimati/features/dashboard/domain/entities/word.dart';

/*
childColumns: "Which column am I pointing FROM?" (in my own table)
parentColumns: "Which column am I pointing TO?" (in the parent table)
*/
@Entity(
  tableName: 'definitions',
  foreignKeys: [
    ForeignKey(
      childColumns: ['wordId'],
      parentColumns: ['id'],
      entity: Word,
      onDelete: ForeignKeyAction.cascade,
    ),
  ],
)
class Definition {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String text;
  final String source;
  final int wordId; // Foreign key to word

  Definition({
    this.id,
    required this.text,
    required this.source,
    required this.wordId,
  });

  // JSON serialization
  factory Definition.fromJson(Map<String, dynamic> json) {
    return Definition(
      id: json['id'] as int?,
      text: json['text'] as String,
      source: json['source'] as String,
      wordId: json['wordId'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'text': text, 'source': source, 'wordId': wordId};
  }

  Definition copyWith({int? id, String? text, String? source, int? wordId}) {
    return Definition(
      id: id ?? this.id,
      text: text ?? this.text,
      source: source ?? this.source,
      wordId: wordId ?? this.wordId,
    );
  }
}
/* class Definition {
  final String definitionId;
  final String text;
  final String language;

  Definition({
    required this.definitionId,
    required this.text,
    required this.language,
  });
}
 */