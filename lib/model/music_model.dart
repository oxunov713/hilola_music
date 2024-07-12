class MusicModel {
  int id;
  String path;
  String name;
  Duration? duration;

  MusicModel({required this.id, required this.path, required this.name, this.duration});

  factory MusicModel.fromJson(Map<String, Object?> json) {
    return MusicModel(
      id: json['id'] as int,
      path: json['path'] as String,
      name: json['name'] as String,
      duration: json['duration'] != null ? Duration(milliseconds: json['duration'] as int) : null,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'path': path,
      'name': name,
      'duration': duration?.inMilliseconds,
    };
  }
}
