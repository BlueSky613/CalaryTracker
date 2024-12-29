// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userdatamodel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserDataModelAdapter extends TypeAdapter<UserDataModel> {
  @override
  final int typeId = 0;

  @override
  UserDataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserDataModel(
      timestamp: fields[0] as String?,
      breakfastList: (fields[1] as List?)?.cast<BreakFastModel>(),
      lunchList: (fields[2] as List?)?.cast<BreakFastModel>(),
      dinnerList: (fields[3] as List?)?.cast<BreakFastModel>(),
      snacksList: (fields[4] as List?)?.cast<BreakFastModel>(),
      caloriesGoal: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserDataModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.timestamp)
      ..writeByte(1)
      ..write(obj.breakfastList)
      ..writeByte(2)
      ..write(obj.lunchList)
      ..writeByte(3)
      ..write(obj.dinnerList)
      ..writeByte(4)
      ..write(obj.snacksList)
      ..writeByte(5)
      ..write(obj.caloriesGoal);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserDataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
