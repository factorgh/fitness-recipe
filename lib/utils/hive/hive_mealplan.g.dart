// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_mealplan.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveMealPlanAdapter extends TypeAdapter<HiveMealPlan> {
  @override
  final int typeId = 1;

  @override
  HiveMealPlan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveMealPlan(
      id: fields[0] as String?,
      name: fields[1] as String,
      duration: fields[2] as String,
      startDate: fields[3] as DateTime?,
      endDate: fields[4] as DateTime?,
      datesArray: (fields[5] as List?)?.cast<DateTime>(),
      isDraft: fields[11] as bool?,
      meals: (fields[6] as List?)?.cast<HiveMeal>(),
      trainees: (fields[7] as List).cast<String>(),
      createdBy: fields[8] as String,
      createdAt: fields[9] as DateTime?,
      updatedAt: fields[10] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, HiveMealPlan obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.duration)
      ..writeByte(3)
      ..write(obj.startDate)
      ..writeByte(4)
      ..write(obj.endDate)
      ..writeByte(5)
      ..write(obj.datesArray)
      ..writeByte(6)
      ..write(obj.meals)
      ..writeByte(7)
      ..write(obj.trainees)
      ..writeByte(8)
      ..write(obj.createdBy)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.updatedAt)
      ..writeByte(11)
      ..write(obj.isDraft);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveMealPlanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
