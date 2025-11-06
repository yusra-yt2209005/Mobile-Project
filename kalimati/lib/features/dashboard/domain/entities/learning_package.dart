import 'package:floor/floor.dart';

@Entity(tableName: 'learning_packages')
class LearningPackage {
  @PrimaryKey()
  final String packageId;
  final String author;
  final String category;
  final String description;
  final String? iconUrl;

  @ColumnInfo(name: 'keywords')
  final String keywords; // Store as comma-separated string

  final String language;

  @ColumnInfo(name: 'last_updated_date')
  final String lastUpdatedDate;

  final String level;
  final String title;
  final int version;

  LearningPackage({
    required this.packageId,
    required this.author,
    required this.category,
    required this.description,
    this.iconUrl,
    required this.keywords,
    required this.language,
    required this.lastUpdatedDate,
    required this.level,
    required this.title,
    required this.version,
  });

  // JSON serialization
  factory LearningPackage.fromJson(Map<String, dynamic> json) {
    return LearningPackage(
      packageId: json['packageId'] as String,
      author: json['author'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      iconUrl: json['iconUrl'] as String?,
      keywords:
          (json['keywords'] as List<dynamic>?)?.cast<String>().join(',') ?? '',
      language: json['language'] as String,
      lastUpdatedDate: json['lastUpdatedDate'] as String, // ← Store as String
      level: json['level'] as String,
      title: json['title'] as String,
      version: json['version'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'packageId': packageId,
      'author': author,
      'category': category,
      'description': description,
      'iconUrl': iconUrl,
      'keywords': keywords.split(','),
      'language': language,
      'lastUpdatedDate': lastUpdatedDate,
      'level': level,
      'title': title,
      'version': version,
    };
  }

  LearningPackage copyWith({
    String? packageId,
    String? author,
    String? category,
    String? description,
    String? iconUrl,
    String? keywords,
    String? language,
    String? lastUpdatedDate,
    String? level,
    String? title,
    int? version,
  }) {
    return LearningPackage(
      packageId: packageId ?? this.packageId,
      author: author ?? this.author,
      category: category ?? this.category,
      description: description ?? this.description,
      iconUrl: iconUrl ?? this.iconUrl,
      keywords: keywords ?? this.keywords,
      language: language ?? this.language,
      lastUpdatedDate: lastUpdatedDate ?? this.lastUpdatedDate,
      level: level ?? this.level,
      title: title ?? this.title,
      version: version ?? this.version,
    );
  }
}
