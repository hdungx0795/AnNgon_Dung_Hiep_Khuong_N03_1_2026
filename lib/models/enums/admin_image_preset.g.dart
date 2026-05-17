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
      case 6:
        return AdminImagePreset.superBurger;
      case 7:
        return AdminImagePreset.noodle;
      case 8:
        return AdminImagePreset.ramen;
      case 9:
        return AdminImagePreset.coffee;
      case 10:
        return AdminImagePreset.soju;
      case 11:
        return AdminImagePreset.cake;
      case 12:
        return AdminImagePreset.cupcake;
      case 13:
        return AdminImagePreset.superCombo;
      case 14:
        return AdminImagePreset.chubbyCombo;
      case 15:
        return AdminImagePreset.matchaCombo;
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
      case AdminImagePreset.superBurger:
        writer.writeByte(6);
        break;
      case AdminImagePreset.noodle:
        writer.writeByte(7);
        break;
      case AdminImagePreset.ramen:
        writer.writeByte(8);
        break;
      case AdminImagePreset.coffee:
        writer.writeByte(9);
        break;
      case AdminImagePreset.soju:
        writer.writeByte(10);
        break;
      case AdminImagePreset.cake:
        writer.writeByte(11);
        break;
      case AdminImagePreset.cupcake:
        writer.writeByte(12);
        break;
      case AdminImagePreset.superCombo:
        writer.writeByte(13);
        break;
      case AdminImagePreset.chubbyCombo:
        writer.writeByte(14);
        break;
      case AdminImagePreset.matchaCombo:
        writer.writeByte(15);
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
