enum ResourceType { Photo, Video, Website }

extension ResourceTypeExtension on ResourceType {
  String get name {
    switch (this) {
      case ResourceType.Photo:
        return 'Photo';
      case ResourceType.Video:
        return 'Video';
      case ResourceType.Website:
        return 'Website';
    }
  }

  static ResourceType fromString(String type) {
    switch (type) {
      case 'Photo':
        return ResourceType.Photo;
      case 'Video':
        return ResourceType.Video;
      case 'Website':
        return ResourceType.Website;
      default:
        return ResourceType.Photo;
    }
  }
}
