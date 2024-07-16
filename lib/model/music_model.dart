class MusicModel {
  final int id;
  final String name;
  final String path;
  String? imagePath;
  Duration? duration;

  MusicModel({
    required this.id,
    required this.name,
    required this.path,
    required this.imagePath,
    this.duration,
  });

  factory MusicModel.fromJson(Map<String, Object?> json) {
    return MusicModel(
      id: json['id'] as int,
      name: json['name'] as String,
      path: json['path'] as String,
      imagePath: json['imagePath'] as String?,
      duration: json['duration'] != null
          ? Duration(milliseconds: json['duration'] as int)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'path': path,
      'imagePath': imagePath,
      'duration': duration?.inMilliseconds,
    };
  }
}