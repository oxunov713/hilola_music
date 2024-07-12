class MusicModel {
  String? path;
  String? name;
  int? id;

  MusicModel({
    required this.id,
    required this.path,
    required this.name,
  });

  factory MusicModel.fromJson(Map<String, Object?> json) => MusicModel(
        path: json["path"] as String?,
        id: json["id"] as int?,
        name: json["name"] as String?,
      );
}
