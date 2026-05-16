// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_product_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AdminProductModelAdapter extends TypeAdapter<AdminProductModel> {
  @override
  final int typeId = 12;

  @override
  AdminProductModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AdminProductModel(
      id: fields[0] as int,
      name: fields[1] as String,
      description: fields[2] as String,
      price: fields[3] as int,
      category: fields[4] as Category,
      imagePreset: fields[5] as AdminImagePreset,
      isActive: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, AdminProductModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.imagePreset)
      ..writeByte(6)
      ..write(obj.isActive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdminProductModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
