// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_model.dart';

class VideoModelAdapter extends TypeAdapter<VideoModel> {
  @override
  final int typeId = 0;

  @override
  VideoModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VideoModel(
      id: fields[0] as String,
      url: fields[1] as String,
      likes: fields[2] as int,
      likedBy: (fields[3] as List).cast<String>(),
      viewers: (fields[4] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, VideoModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.url)
      ..writeByte(2)
      ..write(obj.likes)
      ..writeByte(3)
      ..write(obj.likedBy)
      ..writeByte(4)
      ..write(obj.viewers);
  }
}
