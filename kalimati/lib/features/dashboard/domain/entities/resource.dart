import 'package:floor/floor.dart';
import 'package:kalimati/features/dashboard/domain/entities/sentence.dart';
import 'package:kalimati/features/dashboard/domain/entities/word.dart';
/**/

@Entity(
  tableName: 'resources',
  foreignKeys: [
    ForeignKey(
      childColumns: ['sentenceId'],
      parentColumns: ['id'],
      entity: Sentence,
      onDelete: ForeignKeyAction.cascade,
    ),
    ForeignKey(
      childColumns: ['wordId'],
      parentColumns: ['id'],
      entity: Word,
      onDelete: ForeignKeyAction.cascade,
    ),
  ],
)
class Resource {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String extension;
  final String resourceUrl;
  final String title;

  @ColumnInfo(name: 'type')
  final String type;

  final int? sentenceId; // Foreign key to sentence (nullable)
  final int? wordId; // Foreign key to word (nullable)

  Resource({
    this.id,
    required this.extension,
    required this.resourceUrl,
    required this.title,
    required this.type,
    this.sentenceId,
    this.wordId,
  });

  // JSON serialization
  factory Resource.fromJson(Map<String, dynamic> json) {
    return Resource(
      id: json['id'] as int?,
      extension: json['extension'] as String,
      resourceUrl: json['resourceUrl'] as String,
      title: json['title'] as String,
      type: json['type'] as String,
      sentenceId: json['sentenceId'] as int?,
      wordId: json['wordId'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'extension': extension,
      'resourceUrl': resourceUrl,
      'title': title,
      'type': type,
      'sentenceId': sentenceId,
      'wordId': wordId,
    };
  }

  Resource copyWith({
    int? id,
    String? extension,
    String? resourceUrl,
    String? title,
    String? type,
    int? sentenceId,
    int? wordId,
  }) {
    return Resource(
      id: id ?? this.id,
      extension: extension ?? this.extension,
      resourceUrl: resourceUrl ?? this.resourceUrl,
      title: title ?? this.title,
      type: type ?? this.type,
      sentenceId: sentenceId ?? this.sentenceId,
      wordId: wordId ?? this.wordId,
    );
  }
}
