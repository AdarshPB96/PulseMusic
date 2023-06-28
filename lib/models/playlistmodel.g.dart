// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlistmodel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlaylistSongsAdapter extends TypeAdapter<PlaylistSongs> {
  @override
  final int typeId = 4;

  @override
  PlaylistSongs read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlaylistSongs(
      playlistName: fields[0] as String?,
      playlistsSongs: (fields[1] as List?)?.cast<Songs>(),
    );
  }

  @override
  void write(BinaryWriter writer, PlaylistSongs obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.playlistName)
      ..writeByte(1)
      ..write(obj.playlistsSongs);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlaylistSongsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
