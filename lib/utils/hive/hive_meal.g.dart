// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_meal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveMealAdapter extends TypeAdapter<HiveMeal> {
  @override
  final int typeId = 0;

  @override
  HiveMeal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveMeal(
      id: fields[0] as String?,
      mealType: fields[1] as String,
      recipes: (fields[3] as List).cast<HiveRecipe>(),
      timeOfDay: fields[2] as String,
      isDraft: fields[6] as bool,
      recurrence: fields[4] as HiveRecurrence?,
      date: fields[5] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, HiveMeal obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.mealType)
      ..writeByte(2)
      ..write(obj.timeOfDay)
      ..writeByte(3)
      ..write(obj.recipes)
      ..writeByte(4)
      ..write(obj.recurrence)
      ..writeByte(5)
      ..write(obj.date)
      ..writeByte(6)
      ..write(obj.isDraft);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveMealAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
