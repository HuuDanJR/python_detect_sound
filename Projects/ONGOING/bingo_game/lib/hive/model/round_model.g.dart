// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'round_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RoundModelAdapter extends TypeAdapter<RoundModel> {
  @override
  final int typeId = 1;

  @override
  RoundModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RoundModel(
      round: (fields[0] as List).cast<int>(),
      roundId: fields[1] as String,
      createAt: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RoundModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.round)
      ..writeByte(1)
      ..write(obj.roundId)
      ..writeByte(2)
      ..write(obj.createAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoundModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
