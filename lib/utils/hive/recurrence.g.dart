// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurrence.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecurrenceAdapter extends TypeAdapter<Recurrence> {
  @override
  final int typeId = 0;

  @override
  Recurrence read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Recurrence(
      option: fields[0] as String,
      date: fields[1] as DateTime,
      customDates: (fields[3] as List?)?.cast<DateTime>(),
      exceptions: (fields[2] as List?)?.cast<DateTime>(),
      customDays: (fields[4] as List?)?.cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, Recurrence obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.option)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.exceptions)
      ..writeByte(3)
      ..write(obj.customDates)
      ..writeByte(4)
      ..write(obj.customDays);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecurrenceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
