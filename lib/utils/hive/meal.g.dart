// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MealAdapter extends TypeAdapter<Meal> {
  @override
  final int typeId = 0;

  @override
  Meal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Meal(
      id: fields[0] as String,
      mealType: fields[1] as String,
      timeOfDay: fields[2] as String,
      recipes: (fields[3] as List).cast<String>(),
      recurrence: fields[4] as String,
      date: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Meal obj) {
    writer
      ..writeByte(6)
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
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MealAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
