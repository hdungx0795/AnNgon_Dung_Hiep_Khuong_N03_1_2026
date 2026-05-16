// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_image_preset.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AdminImagePresetAdapter extends TypeAdapter<AdminImagePreset> {
  @override
  final int typeId = 13;

  @override
  AdminImagePreset read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AdminImagePreset.burger;
      case 1:
        return AdminImagePreset.pizza;
      case 2:
        return AdminImagePreset.drink;
      case 3:
        return AdminImagePreset.chicken;
      case 4:
        return AdminImagePreset.dessert;
      case 5:
        return AdminImagePreset.combo;
      default:
        return AdminImagePreset.burger;
    }
  }

  @override
  void write(BinaryWriter writer, AdminImagePreset obj) {
    switch (obj) {
      case AdminImagePreset.burger:
        writer.writeByte(0);
        break;
      case AdminImagePreset.pizza:
        writer.writeByte(1);
        break;
      case AdminImagePreset.drink:
        writer.writeByte(2);
        break;
      case AdminImagePreset.chicken:
        writer.writeByte(3);
        break;
      case AdminImagePreset.dessert:
        writer.writeByte(4);
        break;
      case AdminImagePreset.combo:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdminImagePresetAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
