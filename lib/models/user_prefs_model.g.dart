// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_prefs_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserPrefsModelAdapter extends TypeAdapter<UserPrefsModel> {
  @override
  final int typeId = 9;

  @override
  UserPrefsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserPrefsModel(
      favoriteIds: (fields[0] as List).cast<int>(),
      isDarkMode: fields[1] as bool,
      onboardingDone: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, UserPrefsModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.favoriteIds)
      ..writeByte(1)
      ..write(obj.isDarkMode)
      ..writeByte(2)
      ..write(obj.onboardingDone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserPrefsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
