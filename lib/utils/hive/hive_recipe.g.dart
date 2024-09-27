// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_recipe.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveRecipeAdapter extends TypeAdapter<HiveRecipe> {
  @override
  final int typeId = 3;

  @override
  HiveRecipe read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveRecipe(
      id: fields[0] as String?,
      title: fields[1] as String,
      ingredients: (fields[2] as List).cast<String>(),
      instructions: fields[3] as String,
      description: fields[4] as String,
      facts: fields[5] as String,
      status: fields[6] as String,
      period: fields[7] as String,
      imageUrl: fields[8] as String,
      ratings: (fields[9] as List?)?.cast<Rating>(),
      createdBy: fields[10] as String,
      createdAt: fields[11] as DateTime,
      updatedAt: fields[12] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, HiveRecipe obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.ingredients)
      ..writeByte(3)
      ..write(obj.instructions)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.facts)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.period)
      ..writeByte(8)
      ..write(obj.imageUrl)
      ..writeByte(9)
      ..write(obj.ratings)
      ..writeByte(10)
      ..write(obj.createdBy)
      ..writeByte(11)
      ..write(obj.createdAt)
      ..writeByte(12)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveRecipeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
