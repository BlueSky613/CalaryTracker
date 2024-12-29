// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'breakfastmodel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BreakFastModelAdapter extends TypeAdapter<BreakFastModel> {
  @override
  final int typeId = 1;

  @override
  BreakFastModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BreakFastModel(
      foodImage: fields[1] as String?,
      foodName: fields[2] as String?,
      foodDes: fields[3] as String?,
      calories: fields[4] as String?,
      protein: fields[5] as String?,
      carbs: fields[6] as String?,
      fat: fields[7] as String?,
      date: fields[8] as String?,
      time: fields[9] as String?,
      category: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, BreakFastModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(1)
      ..write(obj.foodImage)
      ..writeByte(2)
      ..write(obj.foodName)
      ..writeByte(3)
      ..write(obj.foodDes)
      ..writeByte(4)
      ..write(obj.calories)
      ..writeByte(5)
      ..write(obj.protein)
      ..writeByte(6)
      ..write(obj.carbs)
      ..writeByte(7)
      ..write(obj.fat)
      ..writeByte(8)
      ..write(obj.date)
      ..writeByte(9)
      ..write(obj.time)
      ..writeByte(10)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BreakFastModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
